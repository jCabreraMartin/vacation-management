#Requires -Version 7.0
<#
.SYNOPSIS
    bolt plugin — thin wrapper over the native `copilot plugin` / `claude plugin` CLIs.

.DESCRIPTION
    Implements list/config/add/remove/status/update as described in
    docs/bolt-plugin-distribution-proposal.md ("El comando `bolt plugin`"). Bolt does not
    reimplement install/uninstall/update — it only delegates to whichever native CLI(s)
    (copilot, claude) are detected on PATH, and persists Bolt-specific bookkeeping
    (.boltf/memory/plugins-state.yaml) that the native CLIs don't know about.

    Claude Code plugins are installed with --scope project (writes to the project's own
    .claude/settings.json, not the user's global profile) instead of the CLI default
    (user scope) — see "Alcance por proyecto (scope)" in the proposal doc. Copilot CLI has
    no equivalent scope concept for `plugin install`, so this script never calls
    `copilot plugin install/uninstall/update` for bolt-framework plugins — Copilot mounts
    them at runtime via --plugin-dir instead (Start-BoltCopilot.ps1 / start-bolt-copilot.sh),
    which reads plugins-state.yaml on every launch.

    Claude Code's own --scope project flag has been observed (2026-08-12) to still write to
    the user's GLOBAL ~/.claude/settings.json instead of the project's .claude/settings.json
    in some environments. As a belt-and-braces fallback, Set-ClaudeEnabledPlugins writes
    enabledPlugins directly into the project's .claude/settings.json after every
    config/add/remove, independent of what the native CLI actually did — this makes the
    project's own settings.json authoritative regardless of that CLI quirk.

    Plugin CONTENT (the actual plugins/<id>/ folders) is delivered by a plain `git`
    sparse-checkout against the real marketplace repo (Avanade-Region-Spain/bolt-framework-
    marketplace, overridable via $env:BOLT_MARKETPLACE_REMOTE for tests) — see
    Sync-MarketplaceCache / Sync-SelectedPlugins below — NOT via `claude plugin install`.
    Two reasons: (1) Claude Code's managed-marketplace-source allow-list blocks this repo as
    a `claude plugin marketplace add` source on enterprise-policy machines, but does not
    affect plain git operations against the same repo; (2) Copilot CLI (the large majority of
    users) has no install mechanism for bolt-framework plugins at all, so content delivery
    cannot depend on Claude being installed. `claude plugin marketplace add`/`install` still
    run afterwards against the LOCAL `./` directory this sync step populates (unaffected by
    the allow-list, since it's a local path, not a github: source) purely so Claude's own
    native plugin UX picks them up too — they are not the content-delivery mechanism.

.NOTES
    bolt-foundation (the essential Bolt agents: orchestrator, constitution, status, ...) is
    always installed (decision #4 in the proposal doc) — it is never shown in the toggle
    checklist and can't be removed via `remove`.

    Plugin dependencies are declared in each plugin's .claude-plugin/plugin.json
    (`dependencies`). Whenever a plugin is selected, its dependencies (transitively) are
    selected and synced too; a plugin required by another installed plugin can't be removed.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('list', 'config', 'add', 'remove', 'status', 'update')]
    [string]$Command,

    [Parameter(Position = 1)]
    [string]$PluginId,

    [switch]$All,
    [switch]$Yes,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$script:MarketplaceName = "bolt-framework"
$script:MandatoryPlugin = "bolt-foundation"

# ─── Logging ─────────────────────────────────────────────────────────────────
function Write-Info { param([string]$m) Write-Host "ℹ️  $m" -ForegroundColor Cyan }
function Write-Ok   { param([string]$m) Write-Host "✅ $m" -ForegroundColor Green }
function Write-Warn { param([string]$m) Write-Host "⚠️  $m" -ForegroundColor Yellow }
function Write-Err  { param([string]$m) Write-Host "❌ $m" -ForegroundColor Red }
function Write-Step { param([string]$m) Write-Host "`n$m" -ForegroundColor Cyan }

# ─── Usage ───────────────────────────────────────────────────────────────────
function Show-Usage {
    Write-Host @"
bolt plugin — wrapper fino sobre 'copilot plugin' / 'claude plugin'

Uso:
  Invoke-BoltPlugin.ps1 list
      Delega en <cliente> plugin list (por cada CLI detectada).

  Invoke-BoltPlugin.ps1 config [-Yes]
      Menú checklist de plugins -> sincroniza contenido desde el marketplace real (git)
      + instala/desinstala vía CLI nativa + persiste .boltf/memory/plugins-state.yaml.

  Invoke-BoltPlugin.ps1 add <id> [-Yes]
  Invoke-BoltPlugin.ps1 remove <id>
  Invoke-BoltPlugin.ps1 status
  Invoke-BoltPlugin.ps1 update [<id>] [-All] [-Yes]

Flags:
  -All             Con 'update' sin <id>: delega en '<cliente> plugin update --all'.
  -Yes             Auto-confirma sin preguntar (uso en CI / Test-InitFlows).
  -Help            Muestra esta ayuda.

Nota: Claude Code instala con --scope project (.claude/settings.json del proyecto).
Copilot CLI no instala nada -- usa .boltf/scripts/powershell/Start-BoltCopilot.ps1
(o start-bolt-copilot.sh) para lanzarlo con --plugin-dir por cada plugin seleccionado.

Ver: docs/bolt-plugin-distribution-proposal.md
"@
}

# ─── CLI / marketplace discovery ─────────────────────────────────────────────
function Get-BoltClients {
    $clients = @()
    if (Get-Command copilot -ErrorAction SilentlyContinue) { $clients += 'copilot' }
    if (Get-Command claude -ErrorAction SilentlyContinue) { $clients += 'claude' }
    return $clients
}

function Assert-GitAvailable {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Se requiere 'git' en PATH para sincronizar plugins desde el marketplace."
    }
}

function Get-MarketplaceRemote {
    if ($env:BOLT_MARKETPLACE_REMOTE) { return $env:BOLT_MARKETPLACE_REMOTE }
    return "https://github.com/Avanade-Region-Spain/bolt-framework-marketplace.git"
}

function Get-MarketplaceCacheDir {
    param([string]$ProjectRoot)
    return Join-Path $ProjectRoot ".boltf\.cache\bolt-framework-marketplace"
}

# Ensures a sparse-checkout clone of the real marketplace repo exists locally and is fresh,
# with exactly '.claude-plugin' (manifest, for catalog discovery) plus any requested
# plugins/<id> paths checked out. Plain git — no copilot/claude dependency, and not subject
# to Claude Code's managed-marketplace-source allow-list (that only gates
# `claude plugin marketplace add`, a different code path — see Register-Marketplace, still
# pointed at the LOCAL './' directory this function's caller populates).
function Sync-MarketplaceCache {
    param(
        [string]$ProjectRoot,
        [string[]]$SparsePaths = @()
    )

    Assert-GitAvailable
    $remote = Get-MarketplaceRemote
    $cacheDir = Get-MarketplaceCacheDir -ProjectRoot $ProjectRoot
    # @(...) wrapper is load-bearing: a single-element pipeline result collapses to a bare
    # scalar in PowerShell, and splatting a scalar STRING below would iterate its characters.
    $allPaths = @(@('.claude-plugin') + $SparsePaths | Select-Object -Unique)

    if (-not (Test-Path (Join-Path $cacheDir ".git"))) {
        if (Test-Path $cacheDir) { Remove-Item $cacheDir -Recurse -Force }
        $parent = Split-Path $cacheDir -Parent
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        & git clone --filter=blob:none --no-checkout --sparse $remote $cacheDir *> $null
        if ($LASTEXITCODE -ne 0) { throw "No se pudo clonar el marketplace remoto ($remote)" }
    }

    $branch = (& git -C $cacheDir rev-parse --abbrev-ref HEAD 2>$null | Select-Object -First 1)
    if ($branch) {
        # Fetch at most once per process: config/add/update call this several times
        # (catalog, dependency resolution, final sync) and one fetch is enough.
        if (-not $script:MarketplaceFetched) { $script:MarketplaceFetched = @{} }
        if (-not $script:MarketplaceFetched.ContainsKey($cacheDir)) {
            & git -C $cacheDir fetch --depth 1 origin $branch *> $null
            & git -C $cacheDir reset --hard "origin/$branch" *> $null
            $script:MarketplaceFetched[$cacheDir] = $true
        }
    }

    & git -C $cacheDir sparse-checkout set @allPaths *> $null
    # sparse-checkout set alone doesn't materialize files into a working tree that was never
    # checked out (--no-checkout clone leaves it empty) — an explicit checkout does, and is a
    # cheap no-op when the files are already present.
    if ($branch) { & git -C $cacheDir checkout $branch *> $null }
    return $cacheDir
}

# Catalog discovery — replaces the old "read a local project-root marketplace.json" logic.
# Same signature/return shape as before, so every caller (Invoke-ConfigCommand,
# Invoke-AddCommand, ...) is unaffected by this change.
function Get-MarketplacePlugins {
    param([string]$ProjectRoot)
    $cacheDir = Sync-MarketplaceCache -ProjectRoot $ProjectRoot
    $mpPath = Join-Path $cacheDir ".claude-plugin\marketplace.json"
    if (-not (Test-Path $mpPath)) {
        throw "No se encontró .claude-plugin/marketplace.json en el marketplace remoto"
    }
    $mp = Get-Content $mpPath -Raw | ConvertFrom-Json
    return @($mp.plugins | ForEach-Object { $_.name })
}

# Materializes exactly $PluginIds into the project's local plugins/<id>/ (fetched via git
# sparse-checkout from the real marketplace), pruning only plugins/<id> previously recorded in
# plugins-state.yaml that are no longer selected (unmanaged dirs are never touched),
# and regenerates the project's own .claude-plugin/marketplace.json to match — the same
# shape bolt-framework used to hand-maintain, just generated on demand instead of committed.
function Sync-SelectedPlugins {
    param(
        [string]$ProjectRoot,
        [string[]]$PluginIds
    )

    $sparsePaths = @($PluginIds | ForEach-Object { "plugins/$_" })
    $cacheDir = Sync-MarketplaceCache -ProjectRoot $ProjectRoot -SparsePaths $sparsePaths

    $localPluginsRoot = Join-Path $ProjectRoot "plugins"
    if (-not (Test-Path $localPluginsRoot)) { New-Item -ItemType Directory -Path $localPluginsRoot -Force | Out-Null }

    # State is rewritten by callers after this sync, so it still holds the previous selection here.
    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    foreach ($oldId in @(Get-PluginsState -Path $statePath)) {
        if ($oldId -in $PluginIds -or $oldId -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') { continue }
        $oldDir = Join-Path $localPluginsRoot $oldId
        if (Test-Path $oldDir -PathType Container) { Remove-Item $oldDir -Recurse -Force }
    }

    foreach ($id in $PluginIds) {
        $src = Join-Path $cacheDir "plugins\$id"
        $dest = Join-Path $localPluginsRoot $id
        if (-not (Test-Path $src)) {
            Write-Warn "Plugin '$id' no encontrado en el marketplace remoto (se omite)"
            continue
        }
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        Copy-Item -Path $src -Destination $dest -Recurse -Force
    }

    $pluginEntries = @($PluginIds | ForEach-Object {
        $entry = [ordered]@{ name = $_; source = "./plugins/$_" }
        if ($_ -eq $script:MandatoryPlugin) { $entry['defaultEnabled'] = $true }
        $entry
    })
    $manifest = [ordered]@{
        name = $script:MarketplaceName
        owner = @{ name = "Bolt Framework" }
        plugins = $pluginEntries
    }
    $mpDir = Join-Path $ProjectRoot ".claude-plugin"
    if (-not (Test-Path $mpDir)) { New-Item -ItemType Directory -Path $mpDir -Force | Out-Null }
    ($manifest | ConvertTo-Json -Depth 10) | Set-Content -Path (Join-Path $mpDir "marketplace.json") -Encoding UTF8
}

# ─── Plugin dependencies (declared in plugins/<id>/.claude-plugin/plugin.json) ─
# Returns the plugin ids listed in `dependencies` of a plugin folder. Entries may be plain
# strings ("bolt-design", "bolt-design@mp") or objects ({ name = "bolt-design", ... }).
function Get-PluginDependencies {
    param([string]$PluginDir)

    $pj = Join-Path $PluginDir ".claude-plugin\plugin.json"
    if (-not (Test-Path $pj)) { return @() }
    try { $json = Get-Content $pj -Raw | ConvertFrom-Json } catch {
        Write-Warn "plugin.json ilegible en $PluginDir (se ignoran sus dependencias)"
        return @()
    }
    if (-not $json.PSObject.Properties['dependencies'] -or -not $json.dependencies) { return @() }

    $deps = @()
    foreach ($d in @($json.dependencies)) {
        $name = if ($d -is [string]) { $d } else { $d.name }
        if ($name) { $deps += ($name -split '@')[0] }
    }
    return @($deps | Select-Object -Unique)
}

# Expands $PluginIds with all their (transitive) dependencies, read from the marketplace
# cache (sparse-checking out each newly discovered plugin first). Requested ids keep their
# order and come first; dependencies are appended. Returns
# @{ Ids = <closure>; RequiredBy = @{ <dep> = @(<requesters>) } }.
function Resolve-PluginDependencies {
    param([string]$ProjectRoot, [string[]]$PluginIds)

    $selected = [System.Collections.Generic.List[string]]::new()
    foreach ($id in $PluginIds) { if ($id -and -not $selected.Contains($id)) { $selected.Add($id) } }
    $requiredBy = @{}
    $sparse = @($selected | ForEach-Object { "plugins/$_" })
    $cacheDir = Sync-MarketplaceCache -ProjectRoot $ProjectRoot -SparsePaths $sparse

    $i = 0
    while ($i -lt $selected.Count) {
        $id = $selected[$i]; $i++
        $pluginDir = Join-Path $cacheDir "plugins\$id"
        if (-not (Test-Path $pluginDir)) {
            # Newly discovered dependency: materialize it before reading its plugin.json
            $cacheDir = Sync-MarketplaceCache -ProjectRoot $ProjectRoot -SparsePaths $sparse
        }
        foreach ($dep in (Get-PluginDependencies -PluginDir $pluginDir)) {
            if (-not $requiredBy.ContainsKey($dep)) { $requiredBy[$dep] = [System.Collections.Generic.List[string]]::new() }
            $requiredBy[$dep].Add($id)
            if (-not $selected.Contains($dep)) {
                $selected.Add($dep)
                $sparse += "plugins/$dep"
            }
        }
    }
    return [pscustomobject]@{ Ids = @($selected); RequiredBy = $requiredBy }
}

# Prints which plugins were pulled in (or kept) only because another selected plugin needs them.
function Write-DependencyNotes {
    param($Resolution, [string[]]$Requested)
    foreach ($id in $Resolution.Ids) {
        if ($id -eq $script:MandatoryPlugin -or $id -in $Requested) { continue }
        $by = if ($Resolution.RequiredBy.ContainsKey($id)) { @($Resolution.RequiredBy[$id]) -join ', ' } else { '?' }
        Write-Info "$id incluido por dependencia (lo requiere: $by)"
    }
}

# Which of $InstalledIds (excluding $PluginId) depend, directly or transitively, on $PluginId.
# Uses the plugin.json of the local plugins/<id> copies.
function Get-InstalledDependents {
    param([string]$ProjectRoot, [string]$PluginId, [string[]]$InstalledIds)

    $depMap = @{}
    foreach ($id in $InstalledIds) {
        $depMap[$id] = @(Get-PluginDependencies -PluginDir (Join-Path $ProjectRoot "plugins\$id"))
    }
    $dependents = @()
    foreach ($id in $InstalledIds) {
        if ($id -eq $PluginId) { continue }
        $seen = @{}
        $stack = [System.Collections.Generic.Stack[string]]::new()
        $stack.Push($id)
        while ($stack.Count -gt 0) {
            $cur = $stack.Pop()
            if ($seen.ContainsKey($cur)) { continue }
            $seen[$cur] = $true
            foreach ($d in @($depMap[$cur])) { if ($d) { $stack.Push($d) } }
        }
        if ($seen.ContainsKey($PluginId)) { $dependents += $id }
    }
    return @($dependents)
}

function Register-Marketplace {
    param([string]$Client, [string]$ProjectRoot)
    Push-Location $ProjectRoot
    try {
        $scopeArgs = if ($Client -eq 'claude') { @('--scope', 'project') } else { @() }
        & $Client plugin marketplace add './' @scopeArgs *> $null
    } finally {
        Pop-Location
    }
}

function Invoke-ClientCommand {
    param([string]$Client, [string[]]$Arguments)
    Write-Host "    `$ $Client $($Arguments -join ' ')" -ForegroundColor DarkGray
    & $Client @Arguments
}

# Queries the native CLI's OWN installed-plugin state (ground truth) — NOT
# plugins-state.yaml, which only tracks Bolt's desired/pre-selected set and is
# written before any real `plugin install` call happens (see Invoke-ConfigCommand).
#
# claude: `plugin list --json` is GLOBAL — it returns project-scope entries for
# EVERY project on the machine, each tagged with its own `projectPath`. Filtering
# only by scope='project' (without also matching projectPath to $ProjectRoot) makes
# an unrelated project's plugins look "installed here" and its own plugins look
# like they need (re)installing — which then makes `plugin uninstall --scope
# project` fail with "not installed in project scope" because it never was, for
# THIS project. Both scope AND projectPath must match.
function Get-InstalledPluginIds {
    param([string]$Client, [string]$ProjectRoot)
    Push-Location $ProjectRoot
    try {
        if ($Client -eq 'claude') {
            $json = & $Client plugin list --json 2>$null
            $ids = @()
            try { $parsed = @(($json -join "`n") | ConvertFrom-Json) } catch { $parsed = @() }
            $marketplaceSuffix = "@$script:MarketplaceName"
            $normalizedRoot = $ProjectRoot.TrimEnd('\', '/')
            foreach ($entry in $parsed) {
                $entryRoot = if ($entry.projectPath) { $entry.projectPath.TrimEnd('\', '/') } else { $null }
                if ($entry.scope -eq 'project' -and $entry.id -like "*$marketplaceSuffix" -and $entryRoot -eq $normalizedRoot) {
                    $ids += $entry.id.Substring(0, $entry.id.Length - $marketplaceSuffix.Length)
                }
            }
            return $ids
        }
        $output = & $Client plugin list 2>$null
    } finally {
        Pop-Location
    }
    $ids = @()
    $marketplace = [regex]::Escape($script:MarketplaceName)
    foreach ($line in $output) {
        if ($line -match "([\w][\w-]*)@$marketplace\b") { $ids += $Matches[1] }
    }
    return $ids
}

# ─── plugins-state.yaml (Bolt-specific bookkeeping, not a file inventory) ────
function Get-PluginsState {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return @() }
    $installed = @()
    $inBlock = $false
    foreach ($line in Get-Content $Path) {
        if ($line -match '^installed:\s*$') { $inBlock = $true; continue }
        if ($inBlock) {
            if ($line -match '^\s*-\s*(\S+)\s*$') { $installed += $Matches[1] }
            elseif ($line -match '^\S') { $inBlock = $false }
        }
    }
    return $installed
}

function Set-PluginsState {
    param([string]$Path, [string[]]$InstalledIds)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $sorted = @($InstalledIds | Sort-Object -Unique)
    $lines = @(
        "# Bolt Framework — plugin selection state"
        "# Managed by ``bolt plugin`` (Invoke-BoltPlugin.ps1 / bolt-plugin.sh). No editar a mano."
        "version: 1"
        "updated: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"
        "installed:"
    )
    foreach ($id in $sorted) { $lines += "  - $id" }
    Set-Content -Path $Path -Value ($lines -join "`n") -Encoding UTF8
}

# VS Code's built-in Copilot Chat agent picker only auto-discovers
# `.github/agents/*.agent.md`. Bolt ships agents/skills under
# `plugins/<id>/{agents,skills}/` instead, so this must be kept in sync with
# plugins-state.yaml on every config/add/remove — see Init.ps1's
# Set-VSCodeAgentDiscovery (same logic, duplicated here since this script has
# no shared-module dependency on Init.ps1).
function Set-VSCodeAgentDiscovery {
    param([string]$ProjectRoot, [string[]]$PluginIds)

    $vscodeDir = Join-Path $ProjectRoot ".vscode"
    $settingsPath = Join-Path $vscodeDir "settings.json"
    if (-not (Test-Path $vscodeDir)) { New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null }

    $agentLocations = [ordered]@{}
    $skillLocations = [ordered]@{}
    foreach ($id in $PluginIds) {
        if (Test-Path (Join-Path $ProjectRoot "plugins\$id\agents")) { $agentLocations["plugins/$id/agents"] = $true }
        if (Test-Path (Join-Path $ProjectRoot "plugins\$id\skills")) { $skillLocations["plugins/$id/skills"] = $true }
    }

    $existing = $null
    if (Test-Path $settingsPath) {
        try {
            $raw = (Get-Content $settingsPath -Raw) -replace '(?m)^\s*//.*$', ''
            $existing = $raw | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        } catch {
            Write-Warn "No se pudo parsear .vscode/settings.json automáticamente — actualiza chat.agentFilesLocations/chat.agentSkillsLocations a mano"
            return
        }
    }
    if (-not $existing) { $existing = [ordered]@{} }

    $existing['chat.agentFilesLocations'] = $agentLocations
    $existing['chat.agentSkillsLocations'] = $skillLocations

    ($existing | ConvertTo-Json -Depth 10) | Set-Content -Path $settingsPath -Encoding UTF8
}

# Fallback for when `claude plugin install/uninstall --scope project` doesn't actually land
# in the project's own .claude/settings.json (observed writing to the user's global
# ~/.claude/settings.json instead, 2026-08-12). Rebuilds the enabledPlugins block for THIS
# marketplace's plugins from the desired set on every call — entries for other marketplaces
# are preserved untouched, and every other top-level key (extraKnownMarketplaces, etc.) is
# left as-is. bolt-foundation is always forced to true (decision #4 — never removable).
function Set-ClaudeEnabledPlugins {
    param([string]$ProjectRoot, [string[]]$PluginIds)

    $claudeDir = Join-Path $ProjectRoot ".claude"
    $settingsPath = Join-Path $claudeDir "settings.json"
    if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }

    $existing = $null
    if (Test-Path $settingsPath) {
        try {
            $raw = (Get-Content $settingsPath -Raw) -replace '(?m)^\s*//.*$', ''
            $existing = $raw | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        } catch {
            Write-Warn "No se pudo parsear .claude/settings.json automáticamente — actualiza enabledPlugins a mano"
            return
        }
    }
    if (-not $existing) { $existing = [ordered]@{} }

    $enabledPlugins = [ordered]@{}
    if ($existing.Contains('enabledPlugins') -and $existing['enabledPlugins']) {
        foreach ($key in $existing['enabledPlugins'].Keys) {
            if ($key -notlike "*@$script:MarketplaceName") { $enabledPlugins[$key] = $existing['enabledPlugins'][$key] }
        }
    }

    $ids = @($script:MandatoryPlugin) + @($PluginIds | Where-Object { $_ -ne $script:MandatoryPlugin } | Sort-Object -Unique)
    foreach ($id in $ids) { $enabledPlugins["$id@$script:MarketplaceName"] = $true }

    $existing['enabledPlugins'] = $enabledPlugins
    ($existing | ConvertTo-Json -Depth 10) | Set-Content -Path $settingsPath -Encoding UTF8
}

# ─── Interactive checklist (↑↓ navigate, Space toggle, Enter confirm, Esc cancel) ─
# Same interaction model as Init.ps1's Read-MultiChoice, kept self-contained here
# since this script has no shared-module dependency on Init.ps1.
function Read-PluginChecklist {
    param([string[]]$AllIds, [string[]]$PreSelected)

    $currentIndex = 0
    $selectedIndices = [System.Collections.Generic.List[int]]::new()
    for ($i = 0; $i -lt $AllIds.Count; $i++) {
        if ($AllIds[$i] -in $PreSelected) { $selectedIndices.Add($i) }
    }

    # Redraws a single item row in place — only the two rows that change per keypress
    function Draw-PluginRow {
        param([int]$ItemIndex, [bool]$IsActive, [bool]$IsSelected, [int]$StartLine)

        $checkbox = if ($IsSelected) { "[x]" } else { "[ ]" }
        $prefix   = if ($IsActive)   { "  >" } else { "   " }
        $maxLen   = [Math]::Max(1, [Console]::WindowWidth - 1)
        $line     = ("$prefix $checkbox $($AllIds[$ItemIndex])").PadRight($maxLen).Substring(0, $maxLen)

        $savedColor = [Console]::ForegroundColor
        $maxY = [Console]::BufferHeight - 1
        [Console]::SetCursorPosition(0, [Math]::Min($StartLine + $ItemIndex, $maxY))
        if ($IsActive) { [Console]::ForegroundColor = [ConsoleColor]::Yellow }
        [Console]::Write($line)
        [Console]::ForegroundColor = $savedColor
        [Console]::SetCursorPosition(0, [Math]::Min($StartLine + $AllIds.Count, $maxY))
    }

    # Pre-scroll: reserve enough lines so the menu won't push past the buffer while drawing
    $totalMenuLines = $AllIds.Count + 3
    for ($r = 0; $r -lt $totalMenuLines; $r++) { [Console]::WriteLine("") }
    $blockStart = [Math]::Max(0, [Console]::CursorTop - $totalMenuLines)
    [Console]::SetCursorPosition(0, $blockStart)

    $savedColor = [Console]::ForegroundColor
    [Console]::WriteLine("")
    [Console]::ForegroundColor = [ConsoleColor]::Cyan
    [Console]::WriteLine("  Plugins disponibles ($script:MandatoryPlugin siempre instalado; las dependencias se añaden solas)")
    [Console]::ForegroundColor = [ConsoleColor]::DarkGray
    [Console]::WriteLine("  (up/down navigate | Space select | Enter confirm | Esc cancel)")
    [Console]::ForegroundColor = $savedColor

    $itemsStartLine = [Console]::CursorTop
    for ($i = 0; $i -lt $AllIds.Count; $i++) {
        Draw-PluginRow -ItemIndex $i -IsActive ($i -eq $currentIndex) -IsSelected ($selectedIndices.Contains($i)) -StartLine $itemsStartLine
    }
    $maxY = [Console]::BufferHeight - 1
    [Console]::SetCursorPosition(0, [Math]::Min($itemsStartLine + $AllIds.Count, $maxY))

    $cancelled = $false
    $done = $false
    while (-not $done) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        switch ($key.VirtualKeyCode) {
            38 { # Up Arrow
                $oldIndex = $currentIndex
                $currentIndex = if ($currentIndex -gt 0) { $currentIndex - 1 } else { $AllIds.Count - 1 }
                Draw-PluginRow -ItemIndex $oldIndex     -IsActive $false -IsSelected ($selectedIndices.Contains($oldIndex))     -StartLine $itemsStartLine
                Draw-PluginRow -ItemIndex $currentIndex -IsActive $true  -IsSelected ($selectedIndices.Contains($currentIndex)) -StartLine $itemsStartLine
            }
            40 { # Down Arrow
                $oldIndex = $currentIndex
                $currentIndex = if ($currentIndex -lt $AllIds.Count - 1) { $currentIndex + 1 } else { 0 }
                Draw-PluginRow -ItemIndex $oldIndex     -IsActive $false -IsSelected ($selectedIndices.Contains($oldIndex))     -StartLine $itemsStartLine
                Draw-PluginRow -ItemIndex $currentIndex -IsActive $true  -IsSelected ($selectedIndices.Contains($currentIndex)) -StartLine $itemsStartLine
            }
            32 { # Space — toggle selection
                if ($selectedIndices.Contains($currentIndex)) { $selectedIndices.Remove($currentIndex) | Out-Null }
                else { $selectedIndices.Add($currentIndex) }
                Draw-PluginRow -ItemIndex $currentIndex -IsActive $true -IsSelected ($selectedIndices.Contains($currentIndex)) -StartLine $itemsStartLine
            }
            13 { $done = $true } # Enter — confirm
            27 { $done = $true; $cancelled = $true } # Esc — cancel
        }
    }
    Write-Host ""

    if ($cancelled) { return $null }
    $result = @()
    foreach ($idx in $selectedIndices) { $result += $AllIds[$idx] }
    # The leading comma keeps an empty selection from collapsing to $null (which means cancelled)
    return , @($result)
}

# ─── Commands ─────────────────────────────────────────────────────────────
# Copilot never natively installs bolt-framework plugins (see Register-Marketplace /
# Get-InstalledPluginIds notes above) — `copilot plugin list` would show nothing
# useful, so this prints the plugins-state.yaml-derived set plus how to mount them.
function Invoke-ListCommand {
    param([string]$ProjectRoot, [string[]]$Clients)
    foreach ($client in $Clients) {
        if ($client -eq 'copilot') {
            Write-Step "copilot (vía Start-BoltCopilot.ps1)"
            $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
            $ids = @(Get-PluginsState -Path $statePath)
            if ($ids.Count -eq 0) { $ids = @($script:MandatoryPlugin) }
            Write-Host "  Copilot no instala plugins nativamente — se montan vía --plugin-dir en cada"
            Write-Host "  arranque de Start-BoltCopilot.ps1, a partir de plugins-state.yaml:"
            foreach ($id in $ids) { Write-Host "    - $id" }
            continue
        }
        Write-Step "$client plugin list"
        & $client plugin list
    }
}

function Invoke-StatusCommand {
    param([string]$ProjectRoot, [string[]]$Clients)
    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    if (Test-Path $statePath) {
        Write-Step "plugins-state.yaml"
        Get-Content $statePath | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Warn "No existe $statePath todavía — ejecuta 'bolt plugin config' primero."
    }
    Invoke-ListCommand -ProjectRoot $ProjectRoot -Clients $Clients
}

function Invoke-ConfigCommand {
    param([string]$ProjectRoot, [string[]]$Clients, [switch]$Yes)

    $marketplaceIds = Get-MarketplacePlugins -ProjectRoot $ProjectRoot
    $toggleable = @($marketplaceIds | Where-Object { $_ -ne $script:MandatoryPlugin })

    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    $current = @(Get-PluginsState -Path $statePath)
    if ($current.Count -eq 0) { $current = @($script:MandatoryPlugin) }
    # Ids no longer published by the marketplace (e.g. the retired bolt-core) can't be synced
    $stale = @($current | Where-Object { $_ -notin $marketplaceIds })
    if ($stale.Count -gt 0) {
        Write-Warn "Ya no existen en el marketplace y se descartan: $($stale -join ', '). Revisa la selección (la metodología está repartida en bolt-foundation y los plugins de fase)."
        $current = @($current | Where-Object { $_ -in $marketplaceIds })
    }
    $preSelected = @($current | Where-Object { $_ -ne $script:MandatoryPlugin })

    Write-Step "bolt plugin config"
    Write-Host "  ✔ $script:MandatoryPlugin (siempre instalado)" -ForegroundColor Green
    if ($preSelected.Count -gt 0) {
        foreach ($id in $preSelected) { Write-Host "  ✔ $id" -ForegroundColor Green }
    } else {
        Write-Host "  (ningún plugin adicional seleccionado)" -ForegroundColor DarkGray
    }

    # -Yes: accept the pre-selected set as-is (e.g. CI) — no prompts at all.
    if ($Yes) {
        $selected = $preSelected
    } else {
        # Ask before opening the checklist: keep the current selection, or modify it.
        $ans = Read-Host "  ¿Es correcta esta selección? [Y/n]"
        if ($ans.Trim().ToLower() -eq 'n') {
            $selected = Read-PluginChecklist -AllIds $toggleable -PreSelected $preSelected
            if ($null -eq $selected) { Write-Warn "Cancelado."; return }
        } else {
            $selected = $preSelected
        }
    }

    $requested = @($script:MandatoryPlugin) + @($selected)
    $resolution = Resolve-PluginDependencies -ProjectRoot $ProjectRoot -PluginIds $requested
    $finalSet = @($resolution.Ids)
    Write-DependencyNotes -Resolution $resolution -Requested $requested
    $deselected = @($current | Where-Object { $_ -notin $finalSet })
    $summaryInstall = @($finalSet | Where-Object { $_ -notin $current })
    $summaryRemove = @($deselected)

    Sync-SelectedPlugins -ProjectRoot $ProjectRoot -PluginIds $finalSet

    # NOTE: the install/remove diff is computed PER CLIENT against what that
    # client's native CLI actually reports as installed (`plugin list`) — NOT
    # against plugins-state.yaml. The YAML only tracks Bolt's desired/pre-selected
    # set (used above for the checklist defaults) and may already equal $finalSet
    # even on a brand-new project (Init.ps1 pre-seeds it), which would make a
    # bookkeeping-only diff wrongly conclude "nothing to install".
    foreach ($client in $Clients) {
        if ($client -eq 'copilot') {
            Write-Step "Resumen (copilot)"
            Write-Host "  Copilot no usa instalación nativa para plugins de $script:MarketplaceName." -ForegroundColor DarkGray
            Write-Host "  Se montarán dinámicamente vía Start-BoltCopilot.ps1 (--plugin-dir) a partir de plugins-state.yaml." -ForegroundColor DarkGray
            if ($deselected.Count -gt 0) { Write-Host "  Dejarán de montarse: $($deselected -join ', ')" }
            continue
        }

        Register-Marketplace -Client $client -ProjectRoot $ProjectRoot
        $clientInstalled = @(Get-InstalledPluginIds -Client $client -ProjectRoot $ProjectRoot)
        $clientToInstall = @($finalSet | Where-Object { $_ -notin $clientInstalled })
        $clientToRemove = @($clientInstalled | Where-Object { $_ -notin $finalSet })
        $summaryInstall = @($summaryInstall + $clientToInstall | Select-Object -Unique)
        $summaryRemove = @($summaryRemove + $clientToRemove | Select-Object -Unique)

        Write-Step "Resumen ($client)"
        Write-Host "  Instalar: $(if ($clientToInstall) { $clientToInstall -join ', ' } else { '(ninguno)' })"
        Write-Host "  Eliminar: $(if ($clientToRemove) { $clientToRemove -join ', ' } else { '(ninguno)' })"
        $notNative = @($deselected | Where-Object { $_ -notin $clientToRemove })
        if ($notNative.Count -gt 0) {
            Write-Host "  Deseleccionados (sin instalación nativa en este proyecto, solo se quitan de plugins-state.yaml): $($notNative -join ', ')" -ForegroundColor DarkGray
        }

        foreach ($id in $clientToInstall) { Invoke-ClientCommand -Client $client -Arguments @('plugin', 'install', "$id@$script:MarketplaceName", '--scope', 'project') }
        foreach ($id in $clientToRemove) { Invoke-ClientCommand -Client $client -Arguments @('plugin', 'uninstall', "$id@$script:MarketplaceName", '--scope', 'project') }
    }

    Set-PluginsState -Path $statePath -InstalledIds $finalSet
    Set-VSCodeAgentDiscovery -ProjectRoot $ProjectRoot -PluginIds $finalSet
    if ($Clients -contains 'claude') { Set-ClaudeEnabledPlugins -ProjectRoot $ProjectRoot -PluginIds $finalSet }

    Write-Step "Resumen final"
    Write-Host "  Plugins a instalar: $($summaryInstall.Count)$(if ($summaryInstall.Count) { ' (' + ($summaryInstall -join ', ') + ')' })"
    Write-Host "  Plugins a eliminar: $($summaryRemove.Count)$(if ($summaryRemove.Count) { ' (' + ($summaryRemove -join ', ') + ')' })"
    Write-Ok "plugins-state.yaml actualizado ($($finalSet.Count) plugin(s))."
}

function Invoke-AddCommand {
    param([string]$ProjectRoot, [string[]]$Clients, [string]$PluginId)
    if (-not $PluginId) { Write-Err "Uso: bolt plugin add <id>"; return }

    $marketplaceIds = Get-MarketplacePlugins -ProjectRoot $ProjectRoot
    if ($PluginId -notin $marketplaceIds) { Write-Err "Plugin desconocido: $PluginId"; return }
    if ($PluginId -eq $script:MandatoryPlugin) { Write-Warn "$script:MandatoryPlugin ya está siempre instalado."; return }

    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    $current = @(Get-PluginsState -Path $statePath)
    if ($current.Count -eq 0) { $current = @($script:MandatoryPlugin) }
    $previous = @($current)
    $requested = @($current) + @($PluginId) | Select-Object -Unique
    $resolution = Resolve-PluginDependencies -ProjectRoot $ProjectRoot -PluginIds $requested
    $current = @($resolution.Ids)
    Write-DependencyNotes -Resolution $resolution -Requested $requested
    # Dependencies first, so native installs see them before their dependents
    $toInstall = @($current | Where-Object { $_ -notin $previous -or $_ -eq $PluginId })
    [array]::Reverse($toInstall)

    Sync-SelectedPlugins -ProjectRoot $ProjectRoot -PluginIds $current

    foreach ($client in $Clients) {
        if ($client -eq 'copilot') {
            Write-Info "Copilot: $($toInstall -join ', ') se montará vía Start-BoltCopilot.ps1 (--plugin-dir), no requiere instalación."
            continue
        }
        Register-Marketplace -Client $client -ProjectRoot $ProjectRoot
        foreach ($id in $toInstall) {
            Invoke-ClientCommand -Client $client -Arguments @('plugin', 'install', "$id@$script:MarketplaceName", '--scope', 'project')
        }
    }

    Set-PluginsState -Path $statePath -InstalledIds $current
    Set-VSCodeAgentDiscovery -ProjectRoot $ProjectRoot -PluginIds $current
    if ($Clients -contains 'claude') { Set-ClaudeEnabledPlugins -ProjectRoot $ProjectRoot -PluginIds $current }
    Write-Ok "$PluginId instalado y registrado en plugins-state.yaml."
}

function Invoke-RemoveCommand {
    param([string]$ProjectRoot, [string[]]$Clients, [string]$PluginId)
    if (-not $PluginId) { Write-Err "Uso: bolt plugin remove <id>"; return }
    if ($PluginId -eq $script:MandatoryPlugin) { Write-Err "$script:MandatoryPlugin no se puede desinstalar (siempre activo)."; return }

    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    $current = @(Get-PluginsState -Path $statePath)
    $dependents = @(Get-InstalledDependents -ProjectRoot $ProjectRoot -PluginId $PluginId -InstalledIds $current)
    if ($dependents.Count -gt 0) {
        Write-Err "$PluginId no se puede eliminar: lo requieren $($dependents -join ', '). Elimina esos plugins primero."
        return
    }
    $updated = @($current | Where-Object { $_ -ne $PluginId })

    Sync-SelectedPlugins -ProjectRoot $ProjectRoot -PluginIds $updated

    foreach ($client in $Clients) {
        if ($client -eq 'copilot') {
            Write-Info "Copilot: $PluginId dejará de montarse en el próximo lanzamiento de Start-BoltCopilot.ps1."
            continue
        }
        Invoke-ClientCommand -Client $client -Arguments @('plugin', 'uninstall', "$PluginId@$script:MarketplaceName", '--scope', 'project')
    }

    Set-PluginsState -Path $statePath -InstalledIds $updated
    Set-VSCodeAgentDiscovery -ProjectRoot $ProjectRoot -PluginIds $updated
    if ($Clients -contains 'claude') { Set-ClaudeEnabledPlugins -ProjectRoot $ProjectRoot -PluginIds $updated }
    Write-Ok "$PluginId eliminado y actualizado en plugins-state.yaml."
}

function Invoke-UpdateCommand {
    param([string]$ProjectRoot, [string[]]$Clients, [string]$PluginId, [switch]$All)

    $statePath = Join-Path $ProjectRoot ".boltf\memory\plugins-state.yaml"
    $installed = @(Get-PluginsState -Path $statePath)
    if ($installed.Count -eq 0) { $installed = @($script:MandatoryPlugin) }

    $targets = if ($PluginId) { @($PluginId) } else { $installed }
    # Re-sync content for $targets without pruning anything already installed —
    # 'update' refreshes content, it never changes which plugins are selected
    # (new dependencies introduced by an updated plugin.json are pulled in).
    $requested = @($installed + $targets) | Select-Object -Unique
    $resolution = Resolve-PluginDependencies -ProjectRoot $ProjectRoot -PluginIds $requested
    $pluginsToSync = @($resolution.Ids)
    Write-DependencyNotes -Resolution $resolution -Requested $requested
    $newDeps = @($pluginsToSync | Where-Object { $_ -notin $installed })

    Sync-SelectedPlugins -ProjectRoot $ProjectRoot -PluginIds $pluginsToSync

    foreach ($client in $Clients) {
        if ($client -eq 'copilot') {
            Write-Info "Copilot: no requiere 'update' — Start-BoltCopilot.ps1 siempre usa el contenido actual en disco/caché."
            continue
        }
        if ($newDeps.Count -gt 0) {
            Register-Marketplace -Client $client -ProjectRoot $ProjectRoot
            foreach ($id in $newDeps) { Invoke-ClientCommand -Client $client -Arguments @('plugin', 'install', "$id@$script:MarketplaceName", '--scope', 'project') }
        }
        if ($All -and -not $PluginId) {
            Invoke-ClientCommand -Client $client -Arguments @('plugin', 'update', '--all', '--scope', 'project')
        } else {
            foreach ($id in $targets) { Invoke-ClientCommand -Client $client -Arguments @('plugin', 'update', "$id@$script:MarketplaceName", '--scope', 'project') }
        }
    }

    if ($newDeps.Count -gt 0) {
        Set-PluginsState -Path $statePath -InstalledIds $pluginsToSync
        Set-VSCodeAgentDiscovery -ProjectRoot $ProjectRoot -PluginIds $pluginsToSync
        if ($Clients -contains 'claude') { Set-ClaudeEnabledPlugins -ProjectRoot $ProjectRoot -PluginIds $pluginsToSync }
    }
    Write-Ok "Update completado."
}

# ─── Entry point ─────────────────────────────────────────────────────────────
if ($Help -or -not $Command) {
    Show-Usage
    exit 0
}

$ProjectRoot = (Resolve-Path "$PSScriptRoot\..\..\..").Path
$Clients = Get-BoltClients
if ($Clients.Count -eq 0) {
    Write-Err "No se encontró ni 'copilot' ni 'claude' en PATH. Instala al menos una CLI."
    exit 1
}

switch ($Command) {
    'list' { Invoke-ListCommand -ProjectRoot $ProjectRoot -Clients $Clients }
    'config' { Invoke-ConfigCommand -ProjectRoot $ProjectRoot -Clients $Clients -Yes:$Yes }
    'add' { Invoke-AddCommand -ProjectRoot $ProjectRoot -Clients $Clients -PluginId $PluginId }
    'remove' { Invoke-RemoveCommand -ProjectRoot $ProjectRoot -Clients $Clients -PluginId $PluginId }
    'status' { Invoke-StatusCommand -ProjectRoot $ProjectRoot -Clients $Clients }
    'update' { Invoke-UpdateCommand -ProjectRoot $ProjectRoot -Clients $Clients -PluginId $PluginId -All:$All }
}
