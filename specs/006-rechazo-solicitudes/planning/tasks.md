# Tareas de preparación: F-006 Rechazo de solicitudes

| Propiedad | Estado |
| --- | --- |
| Estado | Feature Draft; preparación del cliente BLOCKED; excepción de laboratorio implementada |
| Escenario | `fullstack`: .NET 8; Vue 3 solo para el laboratorio |
| Plan / research | [plan](plan.md) · [research](research.md) |
| Historia | US-001 Draft; AC `TBD` |
| Tamaño | Pendiente de estimar |

## Preparación histórica · reconciliación del Paso 14

Esta tabla y las secciones de preparación siguientes reflejan el estado anterior al Bolt del
laboratorio. Los bloqueos permanecen para el cliente; el Gherkin y las tareas ejecutables actuales
del laboratorio están en la sección «Bolt 1 de laboratorio».

| Historia/requisito | UC | Modelo | Mockup (referencia Draft) | Gherkin | Tarea/bloqueo |
| --- | --- | --- | --- | --- | --- |
| US-001 / BL-RF-006/014/016/046/048 | UC-008 Draft | [state-model](../requirements/state-model.md): acción citada, sin estados origen/destino | [default](../mockups/solicitud-rechazar-step1-default.html), [loading](../mockups/solicitud-rechazar-step1-loading.html), [error](../mockups/solicitud-rechazar-step1-error.html), [success](../mockups/solicitud-rechazar-step1-success.html) | No hay `.feature` | F006-P01/P02; BLOCKED |

[README](../mockups/README.md)/[CHANGELOG](../mockups/CHANGELOG.md): el mockup omite motivo/estado; success/error son
placeholders. No se incluye `empty`, permisos o read-only. No asumir UX aprobada.

## Gaps y dependencias

PA-06 (valorar/cerrar), PA-14 (estado/efectos) y PA-26 (aceptación) siguen abiertas. BL-RF-014 no
propone alternativas, pero no define motivo o flujo. Relación con F-005 es propuesta, no prerrequisito
resuelto. En la preparación histórica no había Gherkin ni pruebas; la excepción del laboratorio sí
los incorpora, sin resolver esas preguntas ante el cliente.

## Tareas pendientes de preparación

| ID | Estado | Objetivo | Entradas | Afectado | Resultado verificable / cierre | Dependencias |
| --- | --- | --- | --- | --- | --- | --- |
| F006-P01 | [ ] Pendiente | Aclarar rechazo frente a «valorar», «cerrar» y cancelar; definir elegibilidad/resultado. | BL-RF-006/014/016/046/048, PA-06/14 | RFP, baseline, requirements F-006 | Respuesta validada; no inventar motivo, transición, reversión o efecto. | Autoridad PA-26 |
| F006-P02 | [ ] Pendiente | Actualizar UC-008 y state-model según reglas aceptadas. | Respuesta P01 | UC-008, state-model | Actor/condición/resultado trazables y aprobados; estados formales solo si se acuerdan. | P01 |
| F006-P03 | [ ] Pendiente | Definir AC y Gherkin del rechazo. | Historia actualizada y aprobada | Tests F-006 | Escenarios aprobados antes de cualquier implementación. | P01/P02, PA-26 |

## Tareas de implementación y gates

Para el alcance del cliente no se autorizan tareas de implementación. Gate: semántica y autorización aprobadas, Gherkin existente, plan técnico y
Paso 14 reconciliados. Futuro Bolt: lint/build configurados, pruebas pasan, ≥80 % cobertura unitaria y
≥60 % mutación, arquitectura según límites y E2E solo si journey UI aprobado. No se declara comando ni
runner existente. Tareas pendientes; sin responsables/estimación.

## Bolt 1 de laboratorio · Paso 16.2

Excepción confirmada por el usuario (DL-B1-01…09, [#74](https://github.com/jCabreraMartin/vacation-management/issues/74)).
No cierra F006-P01…P03 ante el cliente: siguen abiertas. [Plan del Bolt](plan.md#bolt-1-de-laboratorio--paso-162).

| ID | Estado | Tarea | Trazabilidad | Verificación |
| --- | --- | --- | --- | --- |
| F006-B1-T01 | [x] | Registrar decisiones de laboratorio en requisitos, UC-008, state-model, aclaraciones y arquitectura | DL-B1-01…09 | Revisión documental |
| F006-B1-T02 | [x] | Gherkin del comportamiento | AC-LAB-01…05 | [rechazo-solicitud.feature](../tests/rechazo-solicitud.feature) |
| F006-B1-T03 | [x] | Dominio: solicitud y transición Pendiente → Rechazada (TDD) | AC-LAB-01/02 | Pruebas unitarias |
| F006-B1-T04 | [x] | Aplicación: consultar y rechazar por id; puerto de repositorio (TDD) | AC-LAB-01…03 | Pruebas unitarias |
| F006-B1-T05 | [x] | Infraestructura: repositorio en memoria con semilla ficticia | DL-B1-04/05 | Pruebas unitarias |
| F006-B1-T06 | [x] | API Minimal: GET y POST rechazo, Problem Details 404/409 | AC-LAB-01…03 | Integración WebApplicationFactory |
| F006-B1-T07 | [x] | Pruebas de arquitectura de dependencias entre capas | Arquitectura del laboratorio | NetArchTest |
| F006-B1-T08 | [x] | Frontend: vista de solicitud con carga/error/éxito (TDD) | AC-LAB-04/05 | Vitest |
| F006-B1-T09 | [x] | E2E del flujo de rechazo en la interfaz | Escenarios `@ui` | Playwright |
| F006-B1-T10 | [x] | Gates: build, lint, cobertura ≥80 %, mutación ≥60 % | Constitución | Informes locales |

### Evidencia inicial histórica del Bolt 1 (2026-10-30)

Esta medición precede a la auditoría y sus correcciones A-01…A-05. No representa las métricas actuales
del código corregido; se conserva como registro.

Ejecutada en Windows con .NET SDK 10.0.401 sobre `net8.0` (runtime 8.0.33) y Node 24. No se ejecutó en
GitHub Actions.

| Gate | Backend `src/backend` | Frontend `src/frontend` |
| --- | --- | --- |
| TDD (RED) | CS0234/CS0246 por tipos ausentes (dominio, aplicación, infraestructura); CS5001 sin `Program`; 5/5 de API en rojo sin endpoints | Importación no resuelta en cliente, vista y `App` antes de implementarlos |
| Build | `dotnet build` correcto, 0 avisos con avisos como errores | `vue-tsc --noEmit` y `vite build` correctos |
| Lint/formato | `dotnet format --verify-no-changes` correcto | ESLint (`strictTypeChecked`, Vue `essential`) y Prettier correctos |
| Unitarias | 21/21; cobertura Domain/Application/Infrastructure 100 % líneas y ramas | 24/24 Vitest; cobertura 100 % líneas, ramas, funciones y sentencias |
| Arquitectura | 9/9 NetArchTest, con control positivo | No aplica |
| Integración | 6/6 WebApplicationFactory; Api 96,8 % líneas | No aplica |
| Mutación | Stryker.NET 5.0.0: **81,82 %** (umbral 60); 7 supervivientes equivalentes (`ConfigureAwait`, guardas) y 1 sin cobertura en un brazo `switch` inalcanzable | Stryker JS 10.1.1: **98,75 %**; 1 superviviente equivalente (`catch` vacío) |
| E2E | API real local | Playwright 1.64.1 Chromium: 2/2 escenarios `@ui` |
| Dependencias | Paquetes NuGet fijados | `npm audit` 0 vulnerabilidades; override `qs@6.17.1` (transitiva de Stryker, solo desarrollo) |

El Gherkin se traza con pruebas xUnit, Vitest y Playwright etiquetadas por AC; no se ejecuta con un runner
BDD (Reqnroll no forma parte de DL-B1-07).

### Seguimiento A-01…A-05 del mismo Bolt 1

Correcciones solicitadas tras la auditoría del Paso 16.3, no un Bolt adicional. La evidencia inicial
anterior se conserva como histórica. F-006 sigue Draft y PA-06/14/26 siguen abiertas; las tareas
F006-P01…P03 no se cierran por decisiones del laboratorio.

| Hallazgo | Estado local | Evidencia RED → GREEN |
| --- | --- | --- |
| A-01 | [x] | Dos fallos de comportamiento; snapshots coordinados, guardado condicional y prueba de independencia entre ids. 10/10 tests del repositorio; HTTP concurrente devuelve un 200 y un 409. |
| A-02 | [x] | 10 fallos backend y uno del cliente; 16 tests locales y E2E verdes con loopback, Host, Origin y cabecera de escritura. Sin autenticación corporativa. |
| A-03 | [x] | Siete fallos de lectura/recuperación; respuestas controladas, `finally`, resultado desconocido y GET manual. E2E confirma un POST real escrito con respuesta ilegible, sin reintentos ni éxito falso. |
| A-04 | [x] Preparado e inspeccionado | CI con rutas y gates exigibles, cuatro tests estructurales/documentales, seis casos del gate de cobertura y actionlint. No ejecutado remotamente. |
| A-05 | [x] | Regresión documental en RED antes de separar preparación histórica y excepción; luego GREEN. |

| Gate final del código corregido | Resultado local |
| --- | --- |
| Backend build / formato y analizadores | PASS. |
| Backend tests | 24 unitarios + 9 arquitectura + 23 integración = 56 PASS. |
| Cobertura unitaria backend | Domain/Application 100 %; Infrastructure 93,54 % líneas, 90 % ramas. Gate ≥80 % PASS, sin exclusiones nuevas. |
| Mutación backend | 79,67 % ≥60 %; 98 eliminados, 20 supervivientes, 5 sin cobertura, 2 no compilables. |
| Frontend tipos / lint / formato / build | PASS. |
| Frontend unitarias y cobertura | 30/30; 100 % líneas/ramas/funciones/sentencias. |
| Mutación frontend | 94,95 % ≥60 %; 94 eliminados, 5 supervivientes. |
| E2E Chromium | 5/5 PASS. |
| Workflow | YAML/Actions inspeccionado con actionlint 1.7.12; ejecución remota NO REALIZADA. |

Detalle de cambios, límites y artefactos de evidencia:
[auditoría original y seguimiento](../../../docs/work-management/f006-bolt-1-audit.md#seguimiento-de-correcciones-a-01a-05-2026-10-30).
El cierre de #74 y la aprobación del cliente no forman parte de esta entrega.

## Trazabilidad GitHub · Paso 15

Feature: [#13](https://github.com/jCabreraMartin/vacation-management/issues/13). Project [#1 · Gestión de vacaciones](https://github.com/users/jCabreraMartin/projects/1), `Status=Todo`.

| ID local | Issue de tarea | Padre | Bloqueada por | Estado |
| --- | --- | --- | --- | --- |
| F006-P01 | [#42](https://github.com/jCabreraMartin/vacation-management/issues/42) | #13 | Ninguna | Open · pendiente |
| F006-P02 | [#43](https://github.com/jCabreraMartin/vacation-management/issues/43) | #13 | [#42](https://github.com/jCabreraMartin/vacation-management/issues/42) | Open · pendiente |
| F006-P03 | [#44](https://github.com/jCabreraMartin/vacation-management/issues/44) | #13 | [#42](https://github.com/jCabreraMartin/vacation-management/issues/42), [#43](https://github.com/jCabreraMartin/vacation-management/issues/43) | Open · pendiente |
