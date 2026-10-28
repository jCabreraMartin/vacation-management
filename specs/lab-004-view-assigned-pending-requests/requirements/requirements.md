# Feature LAB-F004: Consultar solicitudes pendientes asignadas

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F004 |
| Issue | [gh#3](https://github.com/jCabreraMartin/vacation-management/issues/3) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: FR-003 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al responsable aprobador consultar las solicitudes pendientes de los empleados que tiene
asignados en el escenario didáctico.

### Valor de negocio

LAB-HYP: proporciona la bandeja de trabajo para el flujo de revisión. No es un valor de negocio
confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Responsable aprobador | Consulta solicitudes pendientes de empleados asignados. |

## Alcance

### Incluido

- Consultar las solicitudes pendientes de empleados asignados al responsable.
- Restringir la consulta a las asignaciones del escenario.

### Excluido

- Crear o modificar la asignación de empleados a responsables.
- Sustituciones, cambios de equipo y resolución de asignaciones ambiguas.
- Consultar solicitudes ya decididas, filtros o búsquedas no definidos por la fuente.

## Requisitos cubiertos

- FR-003: consultar solicitudes pendientes de empleados asignados.
- SEC-001 (transversal): limitar el acceso del responsable a solicitudes de empleados asignados.

Son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. No se han definido tiempos de respuesta,
disponibilidad, capacidad ni accesibilidad.

## Historias de usuario

### US-LAB-F004-01: Consultar pendientes asignadas

**Como** responsable aprobador del escenario hipotético,  
**quiero** consultar solicitudes pendientes de los empleados que tengo asignados,  
**para** revisar las solicitudes que me corresponden.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 para que haya solicitudes; mecanismo de asignación aún por definir; SEC-001.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F004-01 | Dado un responsable con solicitudes pendientes de empleados asignados, cuando abre su consulta, entonces ve esas solicitudes pendientes. | Funcional | @smoke — Draft |
| AC-LAB-F004-02 | Dado que una solicitud pertenece a un empleado no asignado al responsable, cuando este intenta consultarla, entonces el acceso se deniega. | Seguridad/funcional | No smoke — Draft |

La evidencia es propuesta. El proceso que determina y mantiene las asignaciones sigue sin definirse.

## Dependencias

- LAB-F001 — presentar solicitudes.
- SEC-001 — autorización por empleado asignado.
- Asignación empleado-responsable — mecanismo y propietario no definidos.

## Preguntas abiertas

- LAB-OQ-003: ¿quién determina y mantiene la asignación de cada empleado a un responsable?
- LAB-OQ-003: ¿cómo se resuelven sustituciones o cambios de equipo?
- LAB-OQ-008: ¿qué autenticación, roles y reglas de autorización se requieren?
- LAB-OQ-010: ¿qué objetivos verificables de rendimiento y capacidad aplican?