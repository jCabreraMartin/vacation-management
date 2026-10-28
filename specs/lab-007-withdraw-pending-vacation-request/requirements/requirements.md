# Feature LAB-F007: Retirar una solicitud de vacaciones pendiente

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F007 |
| Issue | [gh#5](https://github.com/jCabreraMartin/vacation-management/issues/5) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: FR-005 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al empleado retirar una solicitud mientras siga pendiente.

### Valor de negocio

LAB-HYP: practica el flujo alternativo para una solicitud pendiente. No es un valor de negocio
confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Empleado | Retira una solicitud propia que sigue pendiente. |

## Alcance

### Incluido

- Retirar una solicitud propia mientras esté pendiente.
- Reflejar que la solicitud ya no está pendiente para el responsable.
- Permitir al empleado consultar el estado retirado.

### Excluido

- Retirar solicitudes aprobadas.
- Retirar una solicitud cuando su revisión esté en curso.
- Editar una solicitud después de enviarla.
- Definir reglas adicionales de cancelación o notificación.

## Requisitos cubiertos

- FR-005: permitir retirar una solicitud pendiente.
- FR-002 (parcial): mostrar el estado resultante al empleado.
- SEC-001 (transversal): limitar la acción a solicitudes propias.

Son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. No se han definido tiempos de respuesta,
disponibilidad, retención ni objetivos de auditoría.

## Historias de usuario

### US-LAB-F007-01: Retirar solicitud pendiente propia

**Como** empleado del escenario hipotético,  
**quiero** retirar una solicitud propia mientras siga pendiente,  
**para** que deje de estar a la espera de una decisión.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 para presentar la solicitud; LAB-F003 para consultar su estado; SEC-001 para autorización.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F007-01 | Dada una solicitud propia pendiente, cuando el empleado la retira, entonces deja de figurar como pendiente y muestra el estado retirado. | Funcional | @smoke — Draft |
| AC-LAB-F007-02 | Dada una solicitud que no está pendiente, cuando el empleado intenta retirarla, entonces el sistema no la cambia a retirada. | Funcional | No smoke — Draft |

El tratamiento de solicitudes en revisión y la presentación concreta del error o estado quedan por
confirmar.

## Dependencias

- LAB-F001 — presentar una solicitud.
- LAB-F003 — consultar el estado propio.
- SEC-001 — autorización sobre solicitudes propias.

## Preguntas abiertas

- LAB-OQ-006: ¿puede retirarse una solicitud después de enviarla si la revisión ya está en curso?
- LAB-OQ-006: ¿puede retirarse o cancelarse una solicitud ya aprobada?
- LAB-OQ-008: ¿qué autenticación, auditoría y retención aplican?