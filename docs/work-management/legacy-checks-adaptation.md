# Adecuación de checks heredados del PR #75

| Propiedad | Estado |
| --- | --- |
| Fecha | 2026-10-30 |
| Trazabilidad | [Bolt #74](https://github.com/jCabreraMartin/vacation-management/issues/74), [PR #75](https://github.com/jCabreraMartin/vacation-management/pull/75) |
| Autorización de alcance | El usuario confirmó retirar las plantillas no configuradas y convertir la gobernanza en validación de solo lectura. |
| Publicación | Pendiente de una segunda autorización de archivos y commits; no se ha hecho commit/push de esta adaptación. |
| Funcionalidad | No cambia F-006, DL-B1 ni los gates de aplicación. F-006 sigue Draft; PA-06/14/26 abiertas ante el cliente. |

## Diagnóstico del estado anterior

[Contract Tests](../../.github/workflows/contract-tests.yml) intentaba instalar npm desde una raíz sin
manifiesto ni lockfile y comentar en el PR sin permiso de escritura. OpenAPI, AsyncAPI, GraphQL,
Pact y Cucumber eran plantillas sin configuración real; contar `.feature` no demostraba su
ejecución ni validaba sintaxis. El supuesto detector de rupturas contenía pasos ilustrativos.

[DevOps Documentation Governance](../../.github/workflows/devops-doc-sync.yml) invocaba scripts
`docs:devops:*` no provisionados. Su sincronización programada/manual concedía permisos de escritura
y creaba commits/PR. Los propietarios, cadencias y documentos del framework heredado no se adoptan
como reglas del proyecto por el hecho de estar presentes en la copia de las herramientas.

La CI de aplicación en `ee772e3` pasó remotamente antes de esta adaptación. Eso no significaba que
todos los checks del PR estuvieran verdes; los fallos heredados se registraron aparte en #74.

## Controles conservados y adaptados

| Control | Implementación aplicable | Límite explícito |
| --- | --- | --- |
| Comportamiento API | La suite .NET existente `VacationRequestEndpointsTests` verifica lectura, rechazo, 404/409 y concurrencia. | No introduce un contrato formal ni un runner nuevo. |
| Trazabilidad | Compara los AC-LAB declarados con etiquetas de escenarios; comprueba rutas en arquitectura/API y la presencia de la regresión de conflicto. | Análisis estático de etiquetas/rutas, no parser Gherkin ni ejecución BDD. |
| Contratos formales | Ausencia declarada como `not-configured`, no como validación superada de OpenAPI. | Si aparece un esquema en `contracts/` o `specs/*/contracts/`, el control falla exigiendo configurar un validador explícito. No crea contratos para conseguir verde. |
| Cambios de contrato/especificación | Lista diferencias de superficies relevantes respecto al SHA base del PR. | Resumen informativo; no afirma compatibilidad ni detección semántica de rupturas. Sin PR base, no supone una rama de comparación. |
| Gobernanza documental | Exige los 12 artefactos publicados de F-006 y su seguimiento, contenido no vacío y destinos locales de enlaces inline existentes. Comprueba Draft, preguntas abiertas y separación histórica/laboratorio. | No verifica enlaces externos, anclajes históricos de línea, propiedad/cadencias del framework ni aprobación del cliente. |

El validador [legacy-checks.cjs](../../.github/scripts/legacy-checks.cjs) usa exclusivamente módulos
estándar de Node 24, ya usado en CI. Lee los archivos del árbol Git inspeccionado, no las carpetas
locales sin seguimiento. Por defecto usa HEAD; `CHECK_REF` permite validar un árbol candidato inmutable
durante la preparación. Así no se publican ni se usan para esconder enlaces rotos las versiones
completas locales del catálogo o las otras Features pendientes.

## Controles retirados y permisos

Se retiran los jobs Pact y Cucumber no elegidos, los comandos opcionales que ocultaban ausencia de
configuración, los validadores ilustrativos de esquemas y los comentarios automáticos del PR.
Reqnroll no se introduce. El análisis de diferencias pasa a un resumen real y acotado, no a una
promesa de detección de rupturas.

Se retiran el job de sincronización con escritura y su agenda heredada. Se mantiene la validación
documental en PR y manual, con `contents: read`. No hay secretos, `issues: write`,
`pull-requests: write`, commits, push, creación de PR ni cambios automáticos del catálogo. La única
escritura durante los checks es el resumen de ejecución y los informes de prueba del runner.

## Validación prevista y realizada

Las pruebas [legacy-checks.test.cjs](../../.github/scripts/legacy-checks.test.cjs) incluyen configuración
de workflows, criterios ausentes/desconocidos, evidencia vacía/ausente, enlaces rotos o fuera del
repositorio, estado del cliente no Draft y aparición de contratos sin validador.

La primera regresión sobre los workflows heredados falló antes de adaptarlos. Otra prueba negativa
detectó que una PA cerrada podía pasar con una mención genérica a preguntas abiertas; ahora se exige
el estado Abierta en cada fila publicada de PA-06/14/26. La suite API se reutiliza sin cambiar sus
pruebas ni el código de aplicación.

| Comprobación local | Resultado |
| --- | --- |
| Tests Node de controles positivos/negativos | 10/10 PASS. |
| Suite API existente | 6/6 PASS, incluidos 404/409 y rechazo concurrente. |
| Regresiones existentes de CI de aplicación | 4/4 PASS; sus archivos/gates no se modificaron. |
| Árbol candidato publicable | Cinco AC trazados; 12 documentos y 95 enlaces publicados comprobados. |
| YAML y semántica Actions | actionlint 1.7.12 PASS para ambos workflows. |
| Dependencias o runners nuevos | Ninguno. |
| CI remota de esta adaptación | No ejecutada; pendiente de autorización de publicación. |

```powershell
node --test .github/scripts/legacy-checks.test.cjs
node .github/scripts/legacy-checks.cjs contracts
node .github/scripts/legacy-checks.cjs documentation
dotnet test src/backend/tests/VacationManagement.IntegrationTests --filter FullyQualifiedName~VacationRequestEndpointsTests
```

Los dos comandos de inspección leen HEAD: antes de publicar, la prueba del árbol candidato usa
`CHECK_REF` apuntando a ese árbol Git. No basta validar el árbol de trabajo completo, porque contiene
material local ajeno al PR.

## Publicación y dictamen pendiente

Solo se proponen estos cinco archivos:

```text
.github/workflows/contract-tests.yml
.github/workflows/devops-doc-sync.yml
.github/scripts/legacy-checks.cjs
.github/scripts/legacy-checks.test.cjs
docs/work-management/legacy-checks-adaptation.md
```

Commits propuestos, todavía no ejecutados:

1. `chore(#74): adecuar checks heredados a controles de solo lectura` (los dos workflows y scripts).
2. `docs(#74): documentar controles aplicables y validación de checks` (este documento).

Se publicaría únicamente la rama Bolt actual en origin y se conservaría el PR #75 Draft con la
misma base, sin force-push, tags o merge. No hay autorización de commit/push todavía. No se
modifican CI Pipeline de aplicación, umbrales, exclusiones, funcionalidad ni archivos locales ajenos.
No se ejecutan Terraform, despliegues u operaciones Azure. No se marca Ready, no se hace merge y no
se cierran #74, #13 ni #42–#44.

El nuevo SHA y todos sus checks remotos deberán verificarse después de autorizar commit/push. Hasta
entonces, **preparado para validación local; validación remota de la adaptación pendiente**. El cierre
de Definition of Done del laboratorio requiere revisión final y no se presume en este cambio.