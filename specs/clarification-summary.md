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
