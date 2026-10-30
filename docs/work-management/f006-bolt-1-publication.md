# Propuesta de publicación controlada del Bolt 1 de F-006

**Estado: pendiente de autorización. Sin stage, commit, push ni PR creados.**

Fecha: 2026-10-30. [Issue #74](https://github.com/jCabreraMartin/vacation-management/issues/74).
Las decisiones DL-B1 son del laboratorio; F-006 continúa Draft y PA-06/14/26 siguen abiertas.
Este manifiesto no autoriza cierres, despliegues, Terraform, operaciones Azure ni otro Bolt.

## Situación comprobada

- Repositorio `jCabreraMartin/vacation-management`: **PUBLIC**, rama predeterminada `main`.
- Rama actual: `bolt/rechazo-solicitudes/bolt-1-rechazo`, todavía sin upstream remoto.
- `HEAD` y padre local/remoto `feature/vacation-management-lab-catalog`:
  `d105e6a6f6a90eb7065735a067194e64f227f21c`.
- `main` local/remoto: `d6670f5123d22c35160ccc6302dfa12ce8404c5a`.
- La rama Bolt no tiene commits propios todavía. Los 13 commits desde main ya están publicados en el
  padre de catálogo; incluyen historia LAB-HYP archivada y el reinicio posterior. No se usa esa
  historia como requisito y no se propone reescribirla, fusionarla ni cambiar de base.
- Remoto de destino: `origin`, `https://github.com/jCabreraMartin/vacation-management.git`.
  `bolt-upstream`, `https://github.com/ava-group-iberiademos/bolt-framework.git`, **no es destino**.
- No había archivos en el índice de Git ni PR existentes al inspeccionar. Había 207 archivos sin
  seguimiento y cuatro archivos versionados modificados; este manifiesto añade un archivo local.
- El padre remoto no está protegido. Actions está habilitado y permite las acciones usadas; esto
  no significa que exista una política remota que obligue a superar checks antes del merge.

## Alcance exacto propuesto: 76 archivos

No se debe usar `git add .`, `git add -A` ni añadir directorios enteros por comodidad. La aprobación
debe referirse a esta lista y a las dos versiones parciales posteriores, no a todo el árbol actual.

### Commit 1 · Prerrequisitos y decisiones del laboratorio (17 archivos)

Mensaje propuesto: `docs(#74): publicar los prerrequisitos del Bolt F-006`.

Los documentos de preparación, UC y mockups proceden de pasos anteriores; son prerrequisitos de
trazabilidad y referencias, no otra implementación. Se publican solo los correspondientes a F-006.
Arquitectura y diagramas compartidos siguen Draft. El documento de aclaraciones lleva exclusivamente
la vista previa acotada de este manifiesto; no su versión local global completa.

```text
specs/006-rechazo-solicitudes/mockups/CHANGELOG.md
specs/006-rechazo-solicitudes/mockups/README.md
specs/006-rechazo-solicitudes/mockups/solicitud-rechazar-step1-default.html
specs/006-rechazo-solicitudes/mockups/solicitud-rechazar-step1-error.html
specs/006-rechazo-solicitudes/mockups/solicitud-rechazar-step1-loading.html
specs/006-rechazo-solicitudes/mockups/solicitud-rechazar-step1-success.html
specs/006-rechazo-solicitudes/planning/plan.md
specs/006-rechazo-solicitudes/planning/research.md
specs/006-rechazo-solicitudes/planning/tasks.md
specs/006-rechazo-solicitudes/requirements/requirements.md
specs/006-rechazo-solicitudes/requirements/state-model.md
specs/006-rechazo-solicitudes/requirements/use-cases/UC-008-rechazar-solicitud.md
specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature
docs/design/architecture/architecture-overview.md
docs/diagrams/vacation-management-context.mmd
docs/diagrams/vacation-management-logical-components.mmd
specs/clarification-summary.md
```

### Commit 2 · Aplicación y pruebas (52 archivos)

Mensaje propuesto: `feat(#74): implementar el rechazo local de solicitudes`.

Incluye proyectos, solución, configuración, código, dependencias declaradas/lockfile y pruebas,
incluidas las regresiones de A-01/A-02/A-03. No incluye los paquetes ni los resultados generados.
Las pruebas del backend **son código que debe publicarse**, no informes descartables.

```text
src/backend/.gitignore
src/backend/Directory.Build.props
src/backend/VacationManagement.sln
src/backend/dotnet-tools.json
src/backend/src/VacationManagement.Api/LocalOnlyAccess.cs
src/backend/src/VacationManagement.Api/Program.cs
src/backend/src/VacationManagement.Api/VacationManagement.Api.csproj
src/backend/src/VacationManagement.Api/VacationRequestEndpoints.cs
src/backend/src/VacationManagement.Application/IVacationRequestRepository.cs
src/backend/src/VacationManagement.Application/VacationManagement.Application.csproj
src/backend/src/VacationManagement.Application/VacationRequestDto.cs
src/backend/src/VacationManagement.Application/VacationRequestResult.cs
src/backend/src/VacationManagement.Application/VacationRequestService.cs
src/backend/src/VacationManagement.Domain/VacationManagement.Domain.csproj
src/backend/src/VacationManagement.Domain/VacationRequest.cs
src/backend/src/VacationManagement.Domain/VacationRequestNotPendingException.cs
src/backend/src/VacationManagement.Domain/VacationRequestStatus.cs
src/backend/src/VacationManagement.Infrastructure/InMemoryVacationRequestRepository.cs
src/backend/src/VacationManagement.Infrastructure/LaboratorySeedData.cs
src/backend/src/VacationManagement.Infrastructure/VacationManagement.Infrastructure.csproj
src/backend/stryker-config.json
src/backend/tests/Directory.Build.props
src/backend/tests/VacationManagement.ArchitectureTests/LayerDependencyTests.cs
src/backend/tests/VacationManagement.ArchitectureTests/VacationManagement.ArchitectureTests.csproj
src/backend/tests/VacationManagement.IntegrationTests/LocalOnlyApiTests.cs
src/backend/tests/VacationManagement.IntegrationTests/UnexpectedErrorTests.cs
src/backend/tests/VacationManagement.IntegrationTests/VacationManagement.IntegrationTests.csproj
src/backend/tests/VacationManagement.IntegrationTests/VacationRequestEndpointsTests.cs
src/backend/tests/VacationManagement.UnitTests/Application/VacationRequestServiceTests.cs
src/backend/tests/VacationManagement.UnitTests/Domain/VacationRequestTests.cs
src/backend/tests/VacationManagement.UnitTests/Infrastructure/InMemoryVacationRequestRepositoryTests.cs
src/backend/tests/VacationManagement.UnitTests/VacationManagement.UnitTests.csproj
src/frontend/.gitignore
src/frontend/.prettierignore
src/frontend/.prettierrc.json
src/frontend/e2e/rechazo-solicitud.spec.ts
src/frontend/eslint.config.js
src/frontend/index.html
src/frontend/package-lock.json
src/frontend/package.json
src/frontend/playwright.config.ts
src/frontend/src/App.spec.ts
src/frontend/src/App.vue
src/frontend/src/api/vacationRequests.spec.ts
src/frontend/src/api/vacationRequests.ts
src/frontend/src/components/VacationRequestReview.spec.ts
src/frontend/src/components/VacationRequestReview.vue
src/frontend/src/env.d.ts
src/frontend/src/main.ts
src/frontend/stryker.config.json
src/frontend/tsconfig.json
src/frontend/vite.config.ts
```

### Commit 3 · CI de aplicación (4 archivos)

Mensaje propuesto: `chore(#74): exigir los gates de aplicación y E2E`.

```text
.github/workflows/ci.yml
.github/scripts/Assert-BackendCoverage.ps1
.github/scripts/Test-BackendCoverage.ps1
.github/scripts/application-ci.test.cjs
```

### Commit 4 · Evidencia e índice acotado (3 archivos)

Mensaje propuesto: `docs(#74): registrar auditoría y preparar validación remota`.

```text
docs/work-management/f006-bolt-1-audit.md
docs/work-management/f006-bolt-1-publication.md
specs/README.md
```

Se conserva el informe completo con auditoría y seguimiento. El índice lleva la vista previa
acotada de este manifiesto, no todo el catálogo local de pasos y Features sin publicar.

La convención del repositorio pide `Closes #74` en el cuerpo de los commits. Publicar commits en la
rama Bolt, sin fusionarlos a la rama predeterminada, no cierra por ello la Issue. Cualquier futuro
merge a main deberá esperar la revisión final y comprobar expresamente ese efecto de autocierre.
No se propone ningún merge ni cierre en esta autorización de publicación/CI.

## Vistas previas exactas de los dos documentos compartidos

Publicar los 75 archivos existentes con las versiones completas actuales de estos dos documentos
dejaría 50 destinos locales fuera del lote, incluidos Terraform, roadmap y otras Features. No se
propone resolverlo añadiendo material ajeno al Bolt ni publicando enlaces rotos.

Solo tras autorización se prepararía en el índice de Git el contenido siguiente. Las copias completas
de trabajo de ambos documentos se conservarían; no se sobrescriben ni se revierten los pasos previos.
El resto del lote usa sus archivos actuales. Antes de commit se compararía el diff preparado con este
manifiesto y se validarían las pruebas documentales sobre el contenido preparado, no solo el árbol
de trabajo. Si cambia un archivo desde esta inspección, habrá que revisar de nuevo su diff.

### Vista previa para specs/README.md

<!-- PUBLICATION_PREVIEW: specs/README.md -->
```markdown
# Especificaciones — Gestión de vacaciones

## Alcance publicado

Esta publicación incorpora exclusivamente el Bolt 1 de laboratorio de F-006 y sus prerrequisitos.
El resto del catálogo y los pasos previos que aún se preparan localmente no forman parte de este PR.
El material histórico `lab-hyp-v1` no es evidencia funcional del incremento.

| Paso | Artefacto | Estado |
| --- | --- | --- |
| 2. RFP | [RFP](../origin/RFP-Vacation-Management.md) | Draft; sin aprobación del cliente. |
| 3. Baseline | [Baseline](../origin/Requirements-Baseline-Vacation-Management.md) | Draft; preguntas pendientes. |
| 4. F-006 | [Requisitos](006-rechazo-solicitudes/requirements/requirements.md) | Feature Draft; [#13](https://github.com/jCabreraMartin/vacation-management/issues/13) abierta. |
| 5. Aclaraciones | [Alcance de laboratorio](clarification-summary.md) | PA-06/14/26 abiertas ante el cliente. |
| 9. Gherkin | [Escenarios F-006](006-rechazo-solicitudes/tests/rechazo-solicitud.feature) | AC-LAB-01…05; no aprobación del cliente ni runner BDD directo. |
| 10. Arquitectura | [Contexto y excepción local](../docs/design/architecture/architecture-overview.md) | Draft; DL-B1 solo para el laboratorio. |
| 13. Plan | [Plan](006-rechazo-solicitudes/planning/plan.md) · [research](006-rechazo-solicitudes/planning/research.md) | Preparación histórica separada de la excepción DL-B1. |
| 14. Tareas | [Tasks](006-rechazo-solicitudes/planning/tasks.md) | #42–#44 abiertas ante el cliente; tareas del Bolt registradas aparte. |
| 16.2. Bolt 1 | [Código y evidencia](006-rechazo-solicitudes/planning/tasks.md) | Consulta de solicitud ficticia y rechazo solo si está Pendiente; persistencia en memoria, uso loopback y sin autenticación corporativa. |
| 16.3. Auditoría | [Informe y seguimiento](../docs/work-management/f006-bolt-1-audit.md) | A-01…A-05 corregidos y validados localmente; CI remota pendiente. |

## Seguimiento

[Issue #74](https://github.com/jCabreraMartin/vacation-management/issues/74) permanece abierta.
La [propuesta de publicación](../docs/work-management/f006-bolt-1-publication.md) delimita archivos,
exclusiones y recorrido de PR. Publicar o ejecutar CI no autoriza despliegue, cierre de las preguntas
al cliente ni implementación de otras Features.
```

### Vista previa para specs/clarification-summary.md

<!-- PUBLICATION_PREVIEW: specs/clarification-summary.md -->
```markdown
# Aclaraciones publicadas para F-006 · Bolt 1

Esta vista acotada registra únicamente las decisiones necesarias para el laboratorio F-006.
El documento global de trabajo y sus restantes preguntas se conservan localmente. Las 27 preguntas
del cliente siguen abiertas: no se registra aquí una respuesta autorizada del cliente.

## Preparación histórica

La [RFP](../origin/RFP-Vacation-Management.md) y la
[baseline](../origin/Requirements-Baseline-Vacation-Management.md) son las fuentes originales.
F-006, UC-008 y la aceptación del cliente continúan Draft. #42–#44 no se cierran por las decisiones
del laboratorio; [#13](https://github.com/jCabreraMartin/vacation-management/issues/13) sigue abierta.

## Excepción del laboratorio

El usuario confirmó DL-B1 para avanzar el Bolt 1, [#74](https://github.com/jCabreraMartin/vacation-management/issues/74).
No constituye aprobación del cliente.

| Pregunta | Decisión limitada al laboratorio | Estado ante el cliente |
| --- | --- | --- |
| PA-06 | «Valorar» y «cerrar» quedan fuera; solo rechazo. | Abierta. |
| PA-14 | Pendiente → Rechazada, terminal; sin motivo ni reversión. No se decide cancelación. | Abierta. |
| PA-16 | Semilla ficticia: id, persona ficticia, fechas y estado; no define campos de alta. | Abierta. |
| PA-24 | Minimal API .NET 8, memoria tras repositorio y sin autenticación corporativa; no selecciona BD o identidad reales. | Abierta. |
| PA-26 | No se identifica una autoridad de aceptación del cliente. | Abierta. |
| PA-27 | Vue 3 + TypeScript + Vite para el laboratorio. | Versión del cliente pendiente. |

Detalle de las decisiones: [requisitos F-006](006-rechazo-solicitudes/requirements/requirements.md).
Los controles locales, la concurrencia y la recuperación de respuestas inciertas se precisan en
[UC-008](006-rechazo-solicitudes/requirements/use-cases/UC-008-rechazar-solicitud.md) y en el
[seguimiento de auditoría](../docs/work-management/f006-bolt-1-audit.md). No se añaden otras Features,
integraciones, persistencia real ni despliegues.
```

## Prerrequisitos ya publicados: sin cambios nuevos

La constitución resumida y canónica, la estrategia de ramas y los ADR-0001 a ADR-0004 ya están en
HEAD y en el padre remoto. También están las fuentes `origin/`, incluida RFP y baseline; no se
duplican ni se modifican. Que ya sean públicas no constituye una aprobación funcional ni elimina
la necesidad de revisar qué se vuelve a enlazar o reproducir en esta publicación.

## Exclusiones expresas

- `.github/workflows/infra-validation.yml` y `.gitignore` de raíz: cambios previos del Paso 16.1,
  no necesarios para la aplicación; los `.gitignore` de backend/frontend protegen sus generados.
- Todo `terraform/`, cachés Terraform y estados/planes: no forman parte de esta publicación.
- `.boltf/memory/constitution.backup-20261026.md` y cualquier otra copia de seguridad.
- `specs/001-*` a `specs/005-*` y `specs/007-*` a `specs/012-*`: ninguna de sus implementaciones,
  planes, tareas, modelos o mockups se añade al lote.
- `notes.md`, `task_plan.md`, `docs/roadmap/implementation-roadmap.md` y
  `docs/work-management/github-sync-report.md`: planificación/sincronización global de pasos previos.
- `node_modules`, `bin`, `obj`, `dist`, `coverage`, `TestResults`, `StrykerOutput`, `reports`,
  `.stryker-tmp`, `test-results`, `playwright-report`, temporales, navegadores descargados y logs.
  El lockfile npm y los manifiestos de herramientas sí se publican: no son dependencias binarias.
- No se añade ni modifica ningún workflow salvo `ci.yml`; en particular no se alteran CD, Release,
  validación de infraestructura, Contract Tests ni gobernanza documental sin autorización adicional.

La lista blanca permite excluir generados aunque no exista una regla de ignore de raíz. Se
comprobó que los paquetes npm, DLL, obj y los informes de mutación del incremento están ignorados.
La inspección encontró 16.913 archivos generados/dependencias ignorados bajo `src`; ninguno se añade
a la propuesta.

## Contenido visible y cautelas de publicación pública

Se harían públicos el código y los fallos corregidos, el contrato de laboratorio, datos de prueba
ficticios, configuración CI, decisiones DL-B1, preguntas pendientes, mockups y arquitectura Draft.
El informe contiene métricas, referencias a rutas locales de código y nombres de carpetas temporales
de evidencia; no se publican los archivos de esas carpetas. Revisar esta exposición antes de aprobar.

Las fuentes originales del cliente y los 13 commits anteriores ya existen en el padre público.
Esta operación no purga ni modifica la historia, no cambia visibilidad y no retira fuentes públicas.
No incluir credenciales, IDs privados, archivos `.env`, User Secrets, claves ni resultados de tests.
Un barrido de patrones no sustituye una revisión humana de confidencialidad.

## Recorrido propuesto, todavía no ejecutado

1. Tras autorización del lote y de las vistas parciales, preparar exclusivamente esos contenidos en
   el índice; conservar los demás cambios locales. Verificar lista, diff preparado y ausencia de
   generados/secretos. No cambiar base, hacer rebase, cherry-pick, reset o merge.
2. Crear los cuatro commits coherentes anteriores en la rama Bolt actual. La división no pretende
   reconstruir falsamente el RED histórico: la evidencia real permanece en el informe y en #74.
3. Publicar únicamente la rama Bolt en `origin`, sin tags ni force-push. No publicar el padre ni main.
4. Verificar `CI Pipeline` del SHA corregido: `Backend gates`, `Frontend gates`, `Local fullstack E2E`
   y `CI Summary`. No basta que exista un run: todos deben concluir en éxito, sin omisiones.
5. Si la CI de aplicación falla, corregir solo lo relacionado con el incremento autorizado y volver
   a validarlo. Cualquier cambio fuera de esta lista requiere revisar el alcance antes de publicarlo.
6. Crear un PR **Draft** desde `bolt/rechazo-solicitudes/bolt-1-rechazo` hacia el padre existente
   `feature/vacation-management-lab-catalog`, título sugerido:
   `feat(#74): publicar Bolt 1 de rechazo local de solicitudes`. Revalidar los checks del SHA/merge
   ref correspondiente. No marcar Ready, fusionar ni borrar ramas sin otra autorización.
7. Registrar en #74 los SHA y URL de ejecución, distinguiendo local, inspección de workflow y remoto.
   Mantener #74, #13 y #42–#44 abiertas. La posterior integración del padre en main es otra revisión:
   incluye sus 13 commits previos y no está autorizada por este lote.

## Workflows activables y riesgos heredados

- `CI Pipeline` se activaría por push a `bolt/**` con estas rutas y por el PR. Ejecuta las pruebas
  locales del laboratorio en el runner; no despliega servicios de aplicación.
- `Contract Tests` también se activaría al cambiar `src/**`. Su versión heredada ejecuta `npm ci`
  desde una raíz sin manifiesto/lockfile, por lo que puede fallar antes de probar contratos. No se
  confunde ese fallo con el resultado del job `CI Summary` de aplicación ni se crea un contrato nuevo
  o un package raíz ficticio para esconderlo.
- En el PR, `DevOps Documentation Governance` ejecutaría el chequeo de gobernanza heredado que
  espera scripts npm de raíz ausentes. Su job que escribe commits/PR se omite para eventos PR.
  Puede requerir un ajuste separado antes de un futuro merge; no se modifica en este lote.
- CD solo responde a main, tags de release o ejecución manual; Release a tags o manual. No se
  publican tags ni se invocan esos workflows. No hay merge a main propuesto ahora.
- No se añaden rutas IaC ni cambios de su workflow; no se programa ejecución de Terraform.
- La rama padre no tiene protección remota: mantener el PR en Draft y revisar manualmente el SHA y
  los cuatro resultados de CI. Configurar reglas de protección sería un cambio separado.

**La CI remota del código corregido sigue pendiente.** No se ha hecho commit, push, dispatch ni PR.
La autorización debe aceptar expresamente la publicación pública de este lote, las dos versiones
parciales y el recorrido indicado, o solicitar cambios antes de ejecutar cualquiera de esas acciones.