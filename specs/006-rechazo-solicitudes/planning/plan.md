# Plan de preparación: F-006 Rechazo de solicitudes

| Propiedad | Estado |
| --- | --- |
| Estado | Draft · preparación bloqueada para implementación |
| Escenario | `fullstack`: C#/.NET 8, Vue.js sin versión fijada |
| Historia | US-001, candidata Draft; aceptación `TBD` |
| Resultado | Aclarar acción, elegibilidad y efectos sin introducir estados/motivos |

## Evaluación y trazabilidad

BL-RF-006/014/016 nombran rechazo y no proponer alternativas; BL-RF-046 «valorar» y BL-RF-048
«cerrar» mantienen semántica pendiente. UC-008 y el [modelo de estados](../requirements/state-model.md)
no definen origen/destino formal. PA-06/14/26 abiertas; no hay Gherkin aprobado. **No hay evidencia para
un plan técnico/Bolts ejecutables.**

- **[E · Draft]** US-001 cita responsable y acción de rechazar.
- **[O]** Rol autorizado, solicitud elegible, significado de cerrar/valorar, resultado, estado y efectos.
- **[C]** .NET 8/Vue.js; identidad, autorización, API y persistencia sin decidir.
- **[P]** Pantalla genérica de rechazo es conversación, no comportamiento aprobado.

## Preparación propuesta

- Aclarar relación rechazar/cerrar/cancelar y condiciones elegibles (PA-06/14).
- Validar qué ve el actor y qué resultado debe ser observable (PA-26); no inventar campo de motivo, reversión o notificación.
- Actualizar requisitos, UC-008 y state-model solo con evidencia aceptada.
- Tras AC aprobados, derivar Gherkin y estrategia de pruebas; hoy no se crean casos.

**Superficies candidatas:** intención de rechazo y comunicación del resultado; no se decide modal, motivo,
estado, permisos o componente. **Mockups:** [default](../mockups/solicitud-rechazar-step1-default.html),
[loading](../mockups/solicitud-rechazar-step1-loading.html), [error](../mockups/solicitud-rechazar-step1-error.html),
[success](../mockups/solicitud-rechazar-step1-success.html), [README](../mockups/README.md), [CHANGELOG](../mockups/CHANGELOG.md).
`success` deja resultado por confirmar; no se interpreta como transición `Rechazada`. No se maquetan vacío,
permisos o read-only; esos estados siguen sin definición.

## Dependencias, pruebas, documentación y gates

- **Dependencias:** PA-06/14/26; posible relación con F-005 es propuesta y no se asume como prerequisito cerrado.
- **Pruebas:** ninguna implementación/test ahora; después cubrir acción/resultado/errores definidos mediante criterios aprobados.
- **Documentación:** requirements, UC-008 y state-model; contratos solo si decisiones posteriores los requieren.
- **Quality gates:** aprobación de semántica y AC, Gherkin aceptado, Paso 14 reconciliado antes de construcción. En código: 80 % unitarias, 60 % mutación y gates de arquitectura/seguridad aplicables.
- **Estado:** **BLOCKED**. Responsables, prioridad, duración y recursos por identificar.

## Bolts

No se proponen Bolts de implementación mientras no haya reglas verificables de rechazo.

### Bolt 1 de laboratorio · Paso 16.2

> Excepción del laboratorio: el usuario confirmó el 2026-10-30 las decisiones DL-B1-01…09
> ([requisitos](../requirements/requirements.md#decisiones-del-laboratorio--paso-162-bolt-1),
> [#74](https://github.com/jCabreraMartin/vacation-management/issues/74)). Las reglas verificables son
> del laboratorio, no del cliente; la preparación anterior sigue pendiente ante el cliente.

| Elemento | Bolt 1 |
| --- | --- |
| Objetivo | Consultar una solicitud ficticia por id y rechazarla si está «Pendiente». |
| Rama | `bolt/rechazo-solicitudes/bolt-1-rechazo` |
| Criterios | AC-LAB-01…05; [Gherkin](../tests/rechazo-solicitud.feature) |
| Backend | `src/backend`: Domain, Application, Infrastructure (memoria), Api (Minimal API, .NET 8) |
| Frontend | `src/frontend`: Vue 3 + TypeScript + Vite; vista de una solicitud |
| Pruebas | Unitarias (xUnit, Vitest), arquitectura (NetArchTest), integración API (WebApplicationFactory), E2E (Playwright) |
| Gates | Build y lint sin errores; cobertura unitaria ≥80 %; mutación ≥60 % (Stryker.NET y Stryker JS); arquitectura, integración y E2E en verde |
| Fuera | Autenticación/autorización, motivo, reversión, valorar/cerrar, notificaciones, efecto en F-005/F-011, listado, alta, base de datos, despliegue |
| Riesgos | Sin autenticación: solo uso local. Estado en memoria. Reglas sujetas a cambio cuando el cliente responda PA-06/14/26. |
