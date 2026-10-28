# Feature LAB-F006: Rechazar una solicitud de vacaciones

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F006 |
| Issue | [gh#7](https://github.com/jCabreraMartin/vacation-management/issues/7) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: outcome de rechazo de FR-004 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al responsable aprobador registrar el rechazo de una solicitud pendiente como un outcome
independiente de la aprobación.

### Valor de negocio

LAB-HYP: permite practicar el outcome de rechazo del flujo de revisión. No es un valor de negocio
confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Responsable aprobador | Rechaza una solicitud pendiente que tiene asignada. |
| Empleado | Consulta el estado resultante de su solicitud. |

## Alcance

### Incluido

- Rechazar una solicitud pendiente por un responsable autorizado.
- Registrar el outcome como rechazada.
- Permitir al empleado consultar el estado actualizado.

### Excluido

- Aprobar una solicitud, definido por separado en LAB-F005.
- Revertir o reabrir una decisión.
- Definir un motivo de rechazo obligatorio, su contenido o una notificación.

## Requisitos cubiertos

- FR-004 (outcome de rechazo): decidir una solicitud pendiente y registrar el estado resultante.
- SEC-001 (transversal): solo un responsable autorizado puede efectuar la decisión.

Son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. Auditoría, retención, disponibilidad y tiempos de
respuesta no tienen objetivos definidos.

## Historias de usuario

### US-LAB-F006-01: Rechazar solicitud pendiente

**Como** responsable aprobador del escenario hipotético,  
**quiero** rechazar una solicitud pendiente que tengo asignada,  
**para** registrar el outcome de rechazo.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 para la solicitud; LAB-F004 para su consulta; SEC-001 para autorización.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F006-01 | Dada una solicitud pendiente asignada al responsable, cuando este la rechaza, entonces la decisión queda registrada como rechazada. | Funcional | @smoke — Draft |
| AC-LAB-F006-02 | Dada una solicitud rechazada, cuando el empleado consulta sus solicitudes, entonces ve el estado actualizado. | Funcional | No smoke — Draft |

El comentario de rechazo, si existe, no se define en la fuente.

## Dependencias

- LAB-F001 — presentar una solicitud.
- LAB-F004 — consultar solicitudes pendientes asignadas.
- LAB-F003 — consultar el estado propio actualizado.
- SEC-001 — autorización del responsable.

## Preguntas abiertas

- LAB-OQ-003: ¿cómo se mantiene la asignación del responsable?
- LAB-OQ-006: ¿puede revertirse o reabrirse un rechazo?
- LAB-OQ-007: ¿qué información debe incluir el motivo de rechazo y es obligatorio?
- LAB-OQ-008: ¿qué autenticación, auditoría y retención aplican?