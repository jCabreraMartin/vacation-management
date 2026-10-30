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
