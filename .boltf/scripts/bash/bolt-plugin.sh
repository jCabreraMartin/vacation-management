#!/bin/bash
# Bolt Framework — bolt plugin (thin wrapper over `copilot plugin` / `claude plugin`)
#
# Implements list/config/add/remove/status/update as described in
# docs/bolt-plugin-distribution-proposal.md ("El comando `bolt plugin`"). Bolt does not
# reimplement install/uninstall/update — it only delegates to whichever native CLI(s)
# (copilot, claude) are detected on PATH, and persists Bolt-specific bookkeeping
# (.boltf/memory/plugins-state.yaml) that the native CLIs don't know about.
#
# Claude Code plugins are installed with --scope project (writes to the project's own
# .claude/settings.json, not the user's global profile) instead of the CLI default (user
# scope) — see "Alcance por proyecto (scope)" in the proposal doc. Copilot CLI has no
# equivalent scope concept for `plugin install`, so this script never calls
# `copilot plugin install/uninstall/update` for bolt-framework plugins — Copilot mounts
# them at runtime via --plugin-dir instead (start-bolt-copilot.sh / Start-BoltCopilot.ps1),
# which reads plugins-state.yaml on every launch.
#
# Claude Code's own --scope project flag has been observed (2026-08-12) to still write to
# the user's GLOBAL ~/.claude/settings.json instead of the project's .claude/settings.json
# in some environments. As a belt-and-braces fallback, set_claude_enabled_plugins writes
# enabledPlugins directly into the project's .claude/settings.json after every
# config/add/remove, independent of what the native CLI actually did.
#
# Plugin CONTENT (the actual plugins/<id>/ folders) is delivered by a plain `git`
# sparse-checkout against the real marketplace repo (Avanade-Region-Spain/bolt-framework-
# marketplace, overridable via $BOLT_MARKETPLACE_REMOTE for tests) — see
# sync_marketplace_cache / sync_selected_plugins below — NOT via `claude plugin install`.
# Two reasons: (1) Claude Code's managed-marketplace-source allow-list blocks this repo as a
# `claude plugin marketplace add` source on enterprise-policy machines, but does not affect
# plain git operations against the same repo; (2) Copilot CLI (the large majority of users)
# has no install mechanism for bolt-framework plugins at all, so content delivery cannot
# depend on Claude being installed. `claude plugin marketplace add`/`install` still run
# afterwards against the LOCAL `./` directory this sync step populates (unaffected by the
# allow-list, since it's a local path, not a github: source) purely so Claude's own native
# plugin UX picks them up too — they are not the content-delivery mechanism.
#
# bolt-foundation (the essential Bolt agents) is always installed (decision #4) — never shown
# in the checklist, can't be removed.
#
# Plugin dependencies are declared in each plugin's .claude-plugin/plugin.json
# (`dependencies`). Selecting a plugin also selects (and syncs) its dependencies,
# transitively; a plugin required by another installed plugin can't be removed.
#
# Requires: git (plugin content sync), jq (marketplace.json / settings.json parsing).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
MARKETPLACE_NAME="bolt-framework"
MANDATORY_PLUGIN="bolt-foundation"
STATE_FILE="$PROJECT_ROOT/.boltf/memory/plugins-state.yaml"
MARKETPLACE_FILE="$PROJECT_ROOT/.claude-plugin/marketplace.json"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; GRAY='\033[0;90m'; NC='\033[0m'
info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
ok()   { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
err()  { echo -e "${RED}❌ $1${NC}"; }
step() { echo -e "\n${CYAN}$1${NC}"; }

usage() {
    cat <<'EOF'
bolt plugin — wrapper fino sobre 'copilot plugin' / 'claude plugin'

Uso:
  bolt-plugin.sh list
      Delega en <cliente> plugin list (por cada CLI detectada).

  bolt-plugin.sh config [--yes]
      Menú checklist de plugins -> sincroniza contenido desde el marketplace real (git)
      + instala/desinstala vía CLI nativa + persiste .boltf/memory/plugins-state.yaml.

  bolt-plugin.sh add <id> [--yes]
  bolt-plugin.sh remove <id>
  bolt-plugin.sh status
  bolt-plugin.sh update [<id>] [--all] [--yes]

Flags:
  --all                Con 'update' sin <id>: delega en '<cliente> plugin update --all'.
  --yes                Auto-confirma sin preguntar (uso en CI / Test-InitFlows).
  --help               Muestra esta ayuda.

Nota: Claude Code instala con --scope project (.claude/settings.json del proyecto).
Copilot CLI no instala nada -- usa .boltf/scripts/bash/start-bolt-copilot.sh (o
Start-BoltCopilot.ps1) para lanzarlo con --plugin-dir por cada plugin seleccionado.

Ver: docs/bolt-plugin-distribution-proposal.md
EOF
}

COMMAND="${1:-}"
if [[ -n "$COMMAND" ]]; then shift; fi

PLUGIN_ID=""
ALL=false
YES=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all) ALL=true; shift ;;
        --yes) YES=true; shift ;;
        --help) usage; exit 0 ;;
        -*) err "Opción desconocida: $1"; usage; exit 1 ;;
        *) PLUGIN_ID="$1"; shift ;;
    esac
done

if [[ -z "$COMMAND" || "$COMMAND" == "--help" ]]; then
    usage
    exit 0
fi

# ─── CLI / marketplace discovery ─────────────────────────────────────────────
detect_clients() {
    CLIENTS=()
    command -v copilot >/dev/null 2>&1 && CLIENTS+=("copilot")
    command -v claude >/dev/null 2>&1 && CLIENTS+=("claude")
    if [[ ${#CLIENTS[@]} -eq 0 ]]; then
        err "No se encontró ni 'copilot' ni 'claude' en PATH. Instala al menos una CLI."
        exit 1
    fi
}

MARKETPLACE_REMOTE="${BOLT_MARKETPLACE_REMOTE:-https://github.com/Avanade-Region-Spain/bolt-framework-marketplace.git}"
MARKETPLACE_CACHE_DIR="$PROJECT_ROOT/.boltf/.cache/bolt-framework-marketplace"

# Ensures a sparse-checkout clone of the real marketplace repo exists locally and is fresh,
# with exactly '.claude-plugin' (manifest, for catalog discovery) plus any requested
# plugins/<id> paths checked out. Plain git — no copilot/claude dependency, and not subject
# to Claude Code's managed-marketplace-source allow-list (that only gates
# `claude plugin marketplace add`, a different code path — see register_marketplace, still
# pointed at the LOCAL './' directory this function's caller populates).
sync_marketplace_cache() {
    # Extra sparse paths beyond '.claude-plugin', one per arg (e.g. "plugins/bolt-foundation").
    command -v git >/dev/null 2>&1 || { err "Se requiere 'git' para sincronizar plugins desde el marketplace."; exit 1; }
    local -a all_paths=(".claude-plugin" "$@")

    if [[ ! -d "$MARKETPLACE_CACHE_DIR/.git" ]]; then
        rm -rf "$MARKETPLACE_CACHE_DIR"
        mkdir -p "$(dirname "$MARKETPLACE_CACHE_DIR")"
        git clone --filter=blob:none --no-checkout --sparse "$MARKETPLACE_REMOTE" "$MARKETPLACE_CACHE_DIR" >/dev/null 2>&1 \
            || { err "No se pudo clonar el marketplace remoto ($MARKETPLACE_REMOTE)"; exit 1; }
    fi

    local branch
    branch=$(git -C "$MARKETPLACE_CACHE_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        # Fetch at most once per run ($$ is the main shell PID even inside $(...) / <(...)
        # subshells): config/add/update call this several times and one fetch is enough.
        local stamp="$MARKETPLACE_CACHE_DIR/.git/bolt-fetched-$$"
        if [[ ! -f "$stamp" ]]; then
            git -C "$MARKETPLACE_CACHE_DIR" fetch --depth 1 origin "$branch" >/dev/null 2>&1
            git -C "$MARKETPLACE_CACHE_DIR" reset --hard "origin/$branch" >/dev/null 2>&1
            rm -f "$MARKETPLACE_CACHE_DIR"/.git/bolt-fetched-*
            : > "$stamp"
        fi
    fi

    git -C "$MARKETPLACE_CACHE_DIR" sparse-checkout set "${all_paths[@]}" >/dev/null 2>&1
    # sparse-checkout set alone doesn't materialize files into a working tree that was never
    # checked out (--no-checkout clone leaves it empty) — an explicit checkout does, and is a
    # cheap no-op when the files are already present.
    [[ -n "$branch" ]] && git -C "$MARKETPLACE_CACHE_DIR" checkout "$branch" >/dev/null 2>&1
}

# Catalog discovery — replaces the old "read a local project-root marketplace.json" logic.
# Same output shape as before (one plugin name per line), so every caller is unaffected.
get_marketplace_plugins() {
    command -v jq >/dev/null 2>&1 || { err "Se requiere 'jq' para leer marketplace.json"; exit 1; }
    sync_marketplace_cache
    local mp_path="$MARKETPLACE_CACHE_DIR/.claude-plugin/marketplace.json"
    [[ -f "$mp_path" ]] || { err "No se encontró .claude-plugin/marketplace.json en el marketplace remoto"; exit 1; }
    jq -r '.plugins[].name' "$mp_path"
}

# Materializes exactly $@ (plugin ids) into the project's local plugins/<id>/ (fetched via
# git sparse-checkout from the real marketplace), pruning only plugins/<id> previously recorded
# in plugins-state.yaml that are no longer selected (unmanaged dirs are never touched), and regenerates the project's own .claude-plugin/marketplace.json to match.
sync_selected_plugins() {
    local -a plugin_ids=("$@")
    local -a sparse_paths=()
    for id in "${plugin_ids[@]}"; do sparse_paths+=("plugins/$id"); done
    sync_marketplace_cache "${sparse_paths[@]}"

    mkdir -p "$PROJECT_ROOT/plugins"
    # State is rewritten by callers after this sync, so it still holds the previous selection here.
    local old_id
    while IFS= read -r old_id; do
        [[ -n "$old_id" ]] || continue
        [[ "$old_id" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || continue
        [[ " ${plugin_ids[*]} " == *" $old_id "* ]] && continue
        if [[ -d "$PROJECT_ROOT/plugins/$old_id" ]]; then rm -rf "$PROJECT_ROOT/plugins/$old_id"; fi
    done < <(get_plugins_state)

    for id in "${plugin_ids[@]}"; do
        local src="$MARKETPLACE_CACHE_DIR/plugins/$id"
        local dest="$PROJECT_ROOT/plugins/$id"
        if [[ ! -d "$src" ]]; then
            warn "Plugin '$id' no encontrado en el marketplace remoto (se omite)"
            continue
        fi
        rm -rf "$dest"
        cp -R "$src" "$dest"
    done

    if command -v jq >/dev/null 2>&1; then
        local plugins_json="[]"
        for id in "${plugin_ids[@]}"; do
            local entry
            entry=$(jq -n --arg name "$id" --arg source "./plugins/$id" '{name: $name, source: $source}')
            if [[ "$id" == "$MANDATORY_PLUGIN" ]]; then
                entry=$(echo "$entry" | jq '. + {defaultEnabled: true}')
            fi
            plugins_json=$(echo "$plugins_json" | jq --argjson e "$entry" '. + [$e]')
        done
        mkdir -p "$(dirname "$MARKETPLACE_FILE")"
        jq -n --arg name "$MARKETPLACE_NAME" --argjson plugins "$plugins_json" \
            '{name: $name, owner: {name: "Bolt Framework"}, plugins: $plugins}' > "$MARKETPLACE_FILE"
    else
        warn "jq no encontrado — no se pudo regenerar .claude-plugin/marketplace.json"
    fi
}

# ─── Plugin dependencies (declared in plugins/<id>/.claude-plugin/plugin.json) ─
# Prints the plugin ids listed in `dependencies` of a plugin folder ($1), one per line.
# Entries may be plain strings ("bolt-design", "bolt-design@mp") or objects ({name: ...}).
get_plugin_dependencies() {
    local pj="$1/.claude-plugin/plugin.json"
    [[ -f "$pj" ]] || return 0
    jq -r '(.dependencies // [])[] | (if type == "string" then . else .name end) | select(. != null) | split("@")[0]' "$pj" 2>/dev/null || true
}

# Expands the given plugin ids with all their (transitive) dependencies, read from the
# marketplace cache (sparse-checking out each newly discovered plugin first). Requested ids
# keep their order and come first. Must NOT be called in a subshell: sets the globals
# RESOLVED_IDS (closure) and REQUIRED_BY (dep -> "requester, requester").
resolve_plugin_dependencies() {
    command -v jq >/dev/null 2>&1 || { err "Se requiere 'jq' para resolver dependencias de plugins"; exit 1; }
    RESOLVED_IDS=()
    declare -gA REQUIRED_BY=()
    local -a sparse=()
    local id dep dir
    for id in "$@"; do
        [[ -n "$id" && ! " ${RESOLVED_IDS[*]:-} " =~ " $id " ]] && RESOLVED_IDS+=("$id")
    done
    for id in "${RESOLVED_IDS[@]}"; do sparse+=("plugins/$id"); done
    sync_marketplace_cache "${sparse[@]}"

    local i=0
    while [[ $i -lt ${#RESOLVED_IDS[@]} ]]; do
        id="${RESOLVED_IDS[$i]}"
        i=$((i + 1))
        dir="$MARKETPLACE_CACHE_DIR/plugins/$id"
        # Newly discovered dependency: materialize it before reading its plugin.json
        [[ -d "$dir" ]] || sync_marketplace_cache "${sparse[@]}"
        while IFS= read -r dep; do
            [[ -z "$dep" ]] && continue
            REQUIRED_BY[$dep]+="${REQUIRED_BY[$dep]:+, }$id"
            if [[ ! " ${RESOLVED_IDS[*]} " =~ " $dep " ]]; then
                RESOLVED_IDS+=("$dep")
                sparse+=("plugins/$dep")
            fi
        done < <(get_plugin_dependencies "$dir")
    done
}

# Prints which plugins were pulled in (or kept) only because another selected plugin needs
# them. Args: the explicitly requested ids. Reads RESOLVED_IDS / REQUIRED_BY.
print_dependency_notes() {
    local id
    for id in "${RESOLVED_IDS[@]}"; do
        [[ "$id" == "$MANDATORY_PLUGIN" || " $* " =~ " $id " ]] && continue
        info "$id incluido por dependencia (lo requiere: ${REQUIRED_BY[$id]:-?})"
    done
}

# Prints those of the installed ids ($2...) that depend, directly or transitively, on $1.
# Uses the plugin.json of the local plugins/<id> copies.
get_installed_dependents() {
    local target="$1"; shift
    local id cur d hit
    for id in "$@"; do
        [[ "$id" == "$target" ]] && continue
        local -a seen=() stack=("$id")
        hit=false
        while [[ ${#stack[@]} -gt 0 ]]; do
            cur="${stack[-1]}"
            unset 'stack[-1]'
            [[ " ${seen[*]:-} " =~ " $cur " ]] && continue
            seen+=("$cur")
            if [[ "$cur" == "$target" ]]; then hit=true; break; fi
            while IFS= read -r d; do
                [[ -n "$d" ]] && stack+=("$d")
            done < <(get_plugin_dependencies "$PROJECT_ROOT/plugins/$cur")
        done
        if $hit; then echo "$id"; fi
    done
}

register_marketplace() {
    local client="$1"
    local -a scope_args=()
    [[ "$client" == "claude" ]] && scope_args=(--scope project)
    (cd "$PROJECT_ROOT" && "$client" plugin marketplace add ./ "${scope_args[@]}" >/dev/null 2>&1) || true
}

invoke_client() {
    local client="$1"; shift
    echo -e "${GRAY}    \$ $client $*${NC}"
    "$client" "$@"
}

# Queries the native CLI's OWN installed-plugin state (ground truth) — NOT
# plugins-state.yaml, which only tracks Bolt's desired/pre-selected set and is
# written before any real `plugin install` call happens (see cmd_config).
#
# claude: `plugin list --json` is GLOBAL — it returns project-scope entries for
# EVERY project on the machine, each tagged with its own `projectPath`. Filtering
# only by scope=="project" (without also matching projectPath to $PROJECT_ROOT)
# makes an unrelated project's plugins look "installed here" and its own plugins
# look like they need (re)installing — which then makes `plugin uninstall
# --scope project` fail with "not installed in project scope" because it never
# was, for THIS project. Both scope AND projectPath must match.
get_installed_plugin_ids() {
    local client="$1"
    if [[ "$client" == "claude" ]]; then
        (cd "$PROJECT_ROOT" && claude plugin list --json 2>/dev/null) \
            | jq -r --arg suffix "@${MARKETPLACE_NAME}" --arg root "${PROJECT_ROOT%/}" \
                '.[] | select(.scope=="project" and (.id | endswith($suffix)) and ((.projectPath // "") | rtrimstr("/") | rtrimstr("\\")) == $root) | .id | sub($suffix; "")'
        return 0
    fi
    (cd "$PROJECT_ROOT" && "$client" plugin list 2>/dev/null) \
        | grep -oE "[[:alnum:]_-]+@${MARKETPLACE_NAME}" \
        | sed "s/@${MARKETPLACE_NAME}\$//"
}

# ─── plugins-state.yaml (Bolt-specific bookkeeping, not a file inventory) ────
get_plugins_state() {
    [[ -f "$STATE_FILE" ]] || return 0
    awk '/^installed:/{f=1;next} /^[^ ]/{f=0} f && /^[[:space:]]*-[[:space:]]*/{gsub(/^[[:space:]]*-[[:space:]]*/,"");print}' "$STATE_FILE"
}

set_plugins_state() {
    local ids=("$@")
    mkdir -p "$(dirname "$STATE_FILE")"
    {
        echo "# Bolt Framework — plugin selection state"
        echo "# Managed by \`bolt plugin\` (Invoke-BoltPlugin.ps1 / bolt-plugin.sh). No editar a mano."
        echo "version: 1"
        echo "updated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo "installed:"
        printf '%s\n' "${ids[@]}" | sort -u | sed 's/^/  - /'
    } > "$STATE_FILE"
}

# VS Code's built-in Copilot Chat agent picker only auto-discovers
# `.github/agents/*.agent.md`. Bolt ships agents/skills under
# `plugins/<id>/{agents,skills}/` instead, so this must be kept in sync with
# plugins-state.yaml on every config/add/remove — see init.sh's
# set_vscode_agent_discovery (same logic, duplicated here since this script
# has no shared dependency on init.sh).
set_vscode_agent_discovery() {
    local -a plugin_ids=("$@")
    local vscode_dir="$PROJECT_ROOT/.vscode"
    local settings_file="$vscode_dir/settings.json"
    mkdir -p "$vscode_dir"

    if ! command -v jq >/dev/null 2>&1; then
        warn "jq no encontrado — omitiendo actualización de .vscode/settings.json (añade chat.agentFilesLocations/chat.agentSkillsLocations a mano)"
        return 0
    fi

    local agents_json="{}"
    local skills_json="{}"
    for id in "${plugin_ids[@]}"; do
        [[ -d "$PROJECT_ROOT/plugins/$id/agents" ]] && agents_json=$(echo "$agents_json" | jq --arg k "plugins/$id/agents" '. + {($k): true}')
        [[ -d "$PROJECT_ROOT/plugins/$id/skills" ]] && skills_json=$(echo "$skills_json" | jq --arg k "plugins/$id/skills" '. + {($k): true}')
    done

    local existing="{}"
    if [[ -f "$settings_file" ]]; then
        existing=$(sed -E 's|^\s*//.*$||' "$settings_file" | jq -c '.' 2>/dev/null) || {
            warn "No se pudo parsear .vscode/settings.json automáticamente — actualiza chat.agentFilesLocations/chat.agentSkillsLocations a mano"
            return 0
        }
    fi

    echo "$existing" | jq --argjson agents "$agents_json" --argjson skills "$skills_json" \
        '. + {"chat.agentFilesLocations": $agents, "chat.agentSkillsLocations": $skills}' > "$settings_file"
}

# Fallback for when `claude plugin install/uninstall --scope project` doesn't actually
# land in the project's own .claude/settings.json (observed writing to the user's global
# ~/.claude/settings.json instead, 2026-08-12). Rebuilds the enabledPlugins block for
# THIS marketplace's plugins from the desired set on every call — entries for other
# marketplaces are preserved untouched, and every other top-level key
# (extraKnownMarketplaces, etc.) is left as-is. bolt-foundation is always forced to true
# (decision #4 — never removable).
set_claude_enabled_plugins() {
    local -a plugin_ids=("$@")
    local claude_dir="$PROJECT_ROOT/.claude"
    local settings_file="$claude_dir/settings.json"
    mkdir -p "$claude_dir"

    if ! command -v jq >/dev/null 2>&1; then
        warn "jq no encontrado — omitiendo actualización de .claude/settings.json (añade enabledPlugins a mano)"
        return 0
    fi

    local existing="{}"
    if [[ -f "$settings_file" ]]; then
        existing=$(sed -E 's|^\s*//.*$||' "$settings_file" | jq -c '.' 2>/dev/null) || {
            warn "No se pudo parsear .claude/settings.json automáticamente — actualiza enabledPlugins a mano"
            return 0
        }
    fi

    local kept
    kept=$(echo "$existing" | jq --arg suffix "@${MARKETPLACE_NAME}" '(.enabledPlugins // {}) | with_entries(select(.key | endswith($suffix) | not))')

    local -a ids=("$MANDATORY_PLUGIN")
    for id in "${plugin_ids[@]}"; do [[ "$id" != "$MANDATORY_PLUGIN" ]] && ids+=("$id"); done
    mapfile -t ids < <(printf '%s\n' "${ids[@]}" | sort -u)

    local enabled="$kept"
    for id in "${ids[@]}"; do
        enabled=$(echo "$enabled" | jq --arg k "${id}@${MARKETPLACE_NAME}" '. + {($k): true}')
    done

    echo "$existing" | jq --argjson enabled "$enabled" '. + {enabledPlugins: $enabled}' > "$settings_file"
}


# ─── Interactive checklist (toggle by number, 'a' apply, 'q' cancel) ─────────
# Reads: TOGGLE_ALL_IDS, PRESELECTED (arrays). Writes: CHECKLIST_RESULT, CHECKLIST_CANCELLED.
read_plugin_checklist() {
    local -a all_ids=("$@")
    local -a selected=("${PRESELECTED[@]}")
    while true; do
        echo ""
        echo -e "${CYAN}  Plugins disponibles ($MANDATORY_PLUGIN siempre instalado; las dependencias se añaden solas):${NC}"
        for i in "${!all_ids[@]}"; do
            local id="${all_ids[$i]}"
            local mark="[ ]"
            for s in "${selected[@]:-}"; do [[ "$s" == "$id" ]] && mark="[x]"; done
            printf "    %2d. %s %s\n" "$((i + 1))" "$mark" "$id"
        done
        echo -e "${GRAY}  Números separados por coma para alternar (ej. 1,3) · 'a' aceptar · 'q' cancelar${NC}"
        read -r -p "  > " raw
        if [[ "$raw" == "q" ]]; then
            CHECKLIST_RESULT=()
            CHECKLIST_CANCELLED=true
            return
        fi
        if [[ "$raw" == "a" || -z "$raw" ]]; then
            CHECKLIST_RESULT=("${selected[@]:-}")
            CHECKLIST_CANCELLED=false
            return
        fi
        IFS=',' read -ra toks <<< "$raw"
        for t in "${toks[@]}"; do
            t="$(echo "$t" | tr -d ' ')"
            [[ "$t" =~ ^[0-9]+$ ]] || continue
            local idx=$((t - 1))
            [[ $idx -ge 0 && $idx -lt ${#all_ids[@]} ]] || continue
            local id="${all_ids[$idx]}"
            local found=false
            local -a new_selected=()
            for s in "${selected[@]:-}"; do
                if [[ "$s" == "$id" ]]; then found=true; else new_selected+=("$s"); fi
            done
            if $found; then selected=("${new_selected[@]:-}"); else selected+=("$id"); fi
        done
    done
}

# ─── Commands ─────────────────────────────────────────────────────────────
# Copilot never natively installs bolt-framework plugins — `copilot plugin list` would
# show nothing useful, so this prints the plugins-state.yaml-derived set instead.
cmd_list() {
    detect_clients
    for c in "${CLIENTS[@]}"; do
        if [[ "$c" == "copilot" ]]; then
            step "copilot (vía start-bolt-copilot.sh)"
            mapfile -t ids < <(get_plugins_state)
            [[ ${#ids[@]} -eq 0 ]] && ids=("$MANDATORY_PLUGIN")
            echo "  Copilot no instala plugins nativamente — se montan vía --plugin-dir en cada"
            echo "  arranque de start-bolt-copilot.sh, a partir de plugins-state.yaml:"
            for id in "${ids[@]}"; do echo "    - $id"; done
            continue
        fi
        step "$c plugin list"
        "$c" plugin list
    done
}

cmd_status() {
    if [[ -f "$STATE_FILE" ]]; then
        step "plugins-state.yaml"
        sed 's/^/  /' "$STATE_FILE"
    else
        warn "No existe $STATE_FILE todavía — ejecuta 'bolt plugin config' primero."
    fi
    cmd_list
}

cmd_config() {
    detect_clients
    mapfile -t marketplace_ids < <(get_marketplace_plugins)
    local -a toggleable=()
    for id in "${marketplace_ids[@]}"; do [[ "$id" != "$MANDATORY_PLUGIN" ]] && toggleable+=("$id"); done

    mapfile -t current < <(get_plugins_state)
    [[ ${#current[@]} -eq 0 ]] && current=("$MANDATORY_PLUGIN")
    PRESELECTED=()
    local -a stale=()
    for id in "${current[@]}"; do
        # Ids no longer published by the marketplace (e.g. the retired bolt-core) can't be synced
        if [[ ! " ${marketplace_ids[*]} " =~ " $id " ]]; then stale+=("$id"); continue; fi
        [[ "$id" != "$MANDATORY_PLUGIN" ]] && PRESELECTED+=("$id")
    done
    if [[ ${#stale[@]} -gt 0 ]]; then
        warn "Ya no existen en el marketplace y se descartan: ${stale[*]}. Revisa la selección (la metodología está repartida en bolt-foundation y los plugins de fase)."
    fi

    step "bolt plugin config"
    echo -e "${GREEN}  ✔ $MANDATORY_PLUGIN (siempre instalado)${NC}"

    read_plugin_checklist "${toggleable[@]}"
    if $CHECKLIST_CANCELLED; then warn "Cancelado."; return; fi

    local -a requested=("$MANDATORY_PLUGIN" "${CHECKLIST_RESULT[@]:-}")
    resolve_plugin_dependencies "${requested[@]}"
    local -a final_set=("${RESOLVED_IDS[@]}")
    print_dependency_notes "${requested[@]}"

    local -a summary_install=() summary_remove=()
    for id in "${final_set[@]}"; do
        [[ ! " ${current[*]} " =~ " $id " ]] && summary_install+=("$id")
    done
    for id in "${current[@]}"; do
        [[ ! " ${final_set[*]} " =~ " $id " ]] && summary_remove+=("$id")
    done

    if ! $YES; then
        read -r -p "  ¿Continuar? [Y/n] > " ans
        [[ "$(echo "$ans" | tr '[:upper:]' '[:lower:]')" == "n" ]] && { warn "Cancelado."; return; }
    fi

    sync_selected_plugins "${final_set[@]}"

    # NOTE: the install/remove diff is computed PER CLIENT against what that
    # client's native CLI actually reports as installed (`plugin list`) — NOT
    # against plugins-state.yaml. The YAML only tracks Bolt's desired/pre-selected
    # set (used above for the checklist defaults) and may already equal final_set
    # even on a brand-new project (Init.ps1/init.sh pre-seed it), which would make
    # a bookkeeping-only diff wrongly conclude "nothing to install".
    for c in "${CLIENTS[@]}"; do
        if [[ "$c" == "copilot" ]]; then
            step "Resumen (copilot)"
            echo "  Copilot no usa instalación nativa para plugins de $MARKETPLACE_NAME."
            echo "  Se montarán dinámicamente vía start-bolt-copilot.sh (--plugin-dir) a partir de plugins-state.yaml."
            continue
        fi

        register_marketplace "$c"
        mapfile -t client_installed < <(get_installed_plugin_ids "$c")
        local -a to_install=() to_remove=()
        for id in "${final_set[@]}"; do
            [[ ! " ${client_installed[*]} " =~ " $id " ]] && to_install+=("$id")
        done
        for id in "${client_installed[@]:-}"; do
            [[ -n "$id" && ! " ${final_set[*]} " =~ " $id " ]] && to_remove+=("$id")
        done
        for id in "${to_install[@]:-}"; do [[ -n "$id" && ! " ${summary_install[*]:-} " =~ " $id " ]] && summary_install+=("$id"); done
        for id in "${to_remove[@]:-}"; do [[ -n "$id" && ! " ${summary_remove[*]:-} " =~ " $id " ]] && summary_remove+=("$id"); done

        step "Resumen ($c)"
        echo "  Instalar: ${to_install[*]:-(ninguno)}"
        echo "  Eliminar: ${to_remove[*]:-(ninguno)}"

        for id in "${to_install[@]:-}"; do [[ -n "$id" ]] && invoke_client "$c" plugin install "$id@$MARKETPLACE_NAME" --scope project; done
        for id in "${to_remove[@]:-}"; do [[ -n "$id" ]] && invoke_client "$c" plugin uninstall "$id@$MARKETPLACE_NAME" --scope project; done
    done

    set_plugins_state "${final_set[@]}"
    set_vscode_agent_discovery "${final_set[@]}"
    [[ " ${CLIENTS[*]} " =~ " claude " ]] && set_claude_enabled_plugins "${final_set[@]}"

    step "Resumen final"
    echo "  Plugins a instalar: ${#summary_install[@]}${summary_install[*]:+ (${summary_install[*]})}"
    echo "  Plugins a eliminar: ${#summary_remove[@]}${summary_remove[*]:+ (${summary_remove[*]})}"
    ok "plugins-state.yaml actualizado (${#final_set[@]} plugin(s))."
}

cmd_add() {
    [[ -z "$PLUGIN_ID" ]] && { err "Uso: bolt-plugin.sh add <id>"; exit 1; }
    detect_clients
    mapfile -t marketplace_ids < <(get_marketplace_plugins)
    if [[ ! " ${marketplace_ids[*]} " =~ " $PLUGIN_ID " ]]; then err "Plugin desconocido: $PLUGIN_ID"; exit 1; fi
    if [[ "$PLUGIN_ID" == "$MANDATORY_PLUGIN" ]]; then warn "$MANDATORY_PLUGIN ya está siempre instalado."; return; fi

    mapfile -t current < <(get_plugins_state)
    [[ ${#current[@]} -eq 0 ]] && current=("$MANDATORY_PLUGIN")
    local -a previous=("${current[@]}")
    local -a requested=("${current[@]}" "$PLUGIN_ID")
    resolve_plugin_dependencies "${requested[@]}"
    current=("${RESOLVED_IDS[@]}")
    print_dependency_notes "${requested[@]}"
    # Dependencies first, so native installs see them before their dependents
    local -a to_install=()
    for (( i=${#current[@]}-1; i>=0; i-- )); do
        local id="${current[$i]}"
        if [[ "$id" == "$PLUGIN_ID" || ! " ${previous[*]} " =~ " $id " ]]; then to_install+=("$id"); fi
    done

    sync_selected_plugins "${current[@]}"

    for c in "${CLIENTS[@]}"; do
        if [[ "$c" == "copilot" ]]; then
            info "Copilot: ${to_install[*]} se montará vía start-bolt-copilot.sh (--plugin-dir), no requiere instalación."
            continue
        fi
        register_marketplace "$c"
        for id in "${to_install[@]}"; do
            invoke_client "$c" plugin install "$id@$MARKETPLACE_NAME" --scope project
        done
    done

    set_plugins_state "${current[@]}"
    set_vscode_agent_discovery "${current[@]}"
    [[ " ${CLIENTS[*]} " =~ " claude " ]] && set_claude_enabled_plugins "${current[@]}"
    ok "$PLUGIN_ID instalado y registrado en plugins-state.yaml."
}

cmd_remove() {
    [[ -z "$PLUGIN_ID" ]] && { err "Uso: bolt-plugin.sh remove <id>"; exit 1; }
    [[ "$PLUGIN_ID" == "$MANDATORY_PLUGIN" ]] && { err "$MANDATORY_PLUGIN no se puede desinstalar (siempre activo)."; exit 1; }
    detect_clients
    mapfile -t current < <(get_plugins_state)
    mapfile -t dependents < <(get_installed_dependents "$PLUGIN_ID" "${current[@]}")
    if [[ ${#dependents[@]} -gt 0 ]]; then
        err "$PLUGIN_ID no se puede eliminar: lo requieren ${dependents[*]}. Elimina esos plugins primero."
        exit 1
    fi
    local -a updated=()
    for id in "${current[@]}"; do [[ "$id" != "$PLUGIN_ID" ]] && updated+=("$id"); done

    sync_selected_plugins "${updated[@]}"

    for c in "${CLIENTS[@]}"; do
        if [[ "$c" == "copilot" ]]; then
            info "Copilot: $PLUGIN_ID dejará de montarse en el próximo lanzamiento de start-bolt-copilot.sh."
            continue
        fi
        invoke_client "$c" plugin uninstall "$PLUGIN_ID@$MARKETPLACE_NAME" --scope project
    done
    set_plugins_state "${updated[@]}"
    set_vscode_agent_discovery "${updated[@]}"
    [[ " ${CLIENTS[*]} " =~ " claude " ]] && set_claude_enabled_plugins "${updated[@]}"
    ok "$PLUGIN_ID eliminado y actualizado en plugins-state.yaml."
}

cmd_update() {
    detect_clients
    mapfile -t installed < <(get_plugins_state)
    [[ ${#installed[@]} -eq 0 ]] && installed=("$MANDATORY_PLUGIN")

    local -a targets=()
    if [[ -n "$PLUGIN_ID" ]]; then targets=("$PLUGIN_ID")
    else targets=("${installed[@]}")
    fi

    # Re-sync content for targets without pruning anything already installed —
    # 'update' refreshes content, it never changes which plugins are selected
    # (new dependencies introduced by an updated plugin.json are pulled in).
    local -a requested=("${installed[@]}" "${targets[@]}")
    resolve_plugin_dependencies "${requested[@]}"
    local -a plugins_to_sync=("${RESOLVED_IDS[@]}")
    print_dependency_notes "${requested[@]}"
    local -a new_deps=()
    for id in "${plugins_to_sync[@]}"; do
        [[ ! " ${installed[*]} " =~ " $id " ]] && new_deps+=("$id")
    done
    sync_selected_plugins "${plugins_to_sync[@]}"

    for c in "${CLIENTS[@]}"; do
        if [[ "$c" == "copilot" ]]; then
            info "Copilot: no requiere 'update' — start-bolt-copilot.sh siempre usa el contenido actual en disco/caché."
            continue
        fi
        if [[ ${#new_deps[@]} -gt 0 ]]; then
            register_marketplace "$c"
            for id in "${new_deps[@]}"; do invoke_client "$c" plugin install "$id@$MARKETPLACE_NAME" --scope project; done
        fi
        if $ALL && [[ -z "$PLUGIN_ID" ]]; then
            invoke_client "$c" plugin update --all --scope project
        else
            for id in "${targets[@]}"; do invoke_client "$c" plugin update "$id@$MARKETPLACE_NAME" --scope project; done
        fi
    done

    if [[ ${#new_deps[@]} -gt 0 ]]; then
        set_plugins_state "${plugins_to_sync[@]}"
        set_vscode_agent_discovery "${plugins_to_sync[@]}"
        [[ " ${CLIENTS[*]} " =~ " claude " ]] && set_claude_enabled_plugins "${plugins_to_sync[@]}"
    fi
    ok "Update completado."
}

case "$COMMAND" in
    list) cmd_list ;;
    config) cmd_config ;;
    add) cmd_add ;;
    remove) cmd_remove ;;
    status) cmd_status ;;
    update) cmd_update ;;
    *) err "Comando desconocido: $COMMAND"; usage; exit 1 ;;
esac
