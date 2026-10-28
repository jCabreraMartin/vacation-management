# Feature LAB-F005: Aprobar una solicitud de vacaciones

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F005 |
| Issue | [gh#4](https://github.com/jCabreraMartin/vacation-management/issues/4) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: outcome de aprobación de FR-004 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al responsable aprobador registrar la aprobación de una solicitud pendiente como un outcome
independiente del rechazo.

### Valor de negocio

LAB-HYP: permite practicar el outcome de aprobación del flujo de revisión. No es un valor de negocio
confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Responsable aprobador | Aprueba una solicitud pendiente que tiene asignada. |
| Empleado | Consulta el estado resultante de su solicitud. |

## Alcance

### Incluido

- Aprobar una solicitud pendiente por un responsable autorizado.
- Registrar el outcome como aprobada.
- Permitir al empleado consultar el estado actualizado.

### Excluido

- Rechazar una solicitud, definido por separado en LAB-F006.
- Revertir o reabrir una decisión.
- Definir si se requiere comentario de aprobación.
- Notificaciones por un canal específico.

## Requisitos cubiertos

- FR-004 (outcome de aprobación): decidir una solicitud pendiente y registrar el estado resultante.
- SEC-001 (transversal): solo un responsable autorizado puede efectuar la decisión.

Son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. Auditoría, retención, disponibilidad y tiempos de
respuesta no tienen objetivos definidos.

## Historias de usuario

### US-LAB-F005-01: Aprobar solicitud pendiente

**Como** responsable aprobador del escenario hipotético,  
**quiero** aprobar una solicitud pendiente que tengo asignada,  
**para** registrar la decisión correspondiente.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 para la solicitud; LAB-F004 para su consulta; SEC-001 para autorización.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F005-01 | Dada una solicitud pendiente asignada al responsable, cuando este la aprueba, entonces la decisión queda registrada como aprobada. | Funcional | @smoke — Draft |
| AC-LAB-F005-02 | Dada una solicitud aprobada, cuando el empleado consulta sus solicitudes, entonces ve el estado actualizado. | Funcional | No smoke — Draft |

No se define comentario obligatorio ni comportamiento de reversión.

## Dependencias

- LAB-F001 — presentar una solicitud.
- LAB-F004 — consultar solicitudes pendientes asignadas.
- LAB-F003 — consultar el estado propio actualizado.
- SEC-001 — autorización del responsable.

## Preguntas abiertas

- LAB-OQ-003: ¿cómo se mantiene la asignación del responsable?
- LAB-OQ-006: ¿puede revertirse o reabrirse una aprobación?
- LAB-OQ-007: ¿se requiere comentario al aprobar o solo al rechazar?
- LAB-OQ-008: ¿qué autenticación, auditoría y retención aplican?