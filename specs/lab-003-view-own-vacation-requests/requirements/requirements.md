# Feature LAB-F003: Consultar solicitudes propias de vacaciones

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F003 |
| Issue | [gh#2](https://github.com/jCabreraMartin/vacation-management/issues/2) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: FR-002 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al empleado consultar la lista y el detalle de sus solicitudes, incluido el estado actual.

### Valor de negocio

LAB-HYP: facilita que el empleado conozca el estado de sus solicitudes dentro del flujo didáctico. No
es un resultado de negocio confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Empleado | Consulta solicitudes propias. |

## Alcance

### Incluido

- Consultar lista y detalle de solicitudes propias.
- Mostrar el estado actual.
- Impedir que el empleado consulte solicitudes ajenas como si fueran propias.

### Excluido

- Bandeja del responsable aprobador (LAB-F004).
- Filtros, búsquedas, periodos de consulta y exportaciones, no definidos por la fuente.
- Definición de estados adicionales o políticas de retención.

## Requisitos cubiertos

- FR-002: consultar lista, detalle y estado actual de las solicitudes propias.
- SEC-001 (transversal): limitar al empleado el acceso a sus propias solicitudes.

Son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. No se especifican tiempos de respuesta,
disponibilidad, accesibilidad ni retención (LAB-OQ-010, LAB-OQ-009).

## Historias de usuario

### US-LAB-F003-01: Consultar solicitudes propias

**Como** empleado del escenario hipotético,  
**quiero** consultar la lista y el detalle de mis solicitudes y su estado,  
**para** conocer el resultado actual de cada una.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 para que existan solicitudes; SEC-001 para autorización.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F003-01 | Dado que el empleado tiene solicitudes registradas, cuando consulta sus solicitudes, entonces puede ver la lista, abrir el detalle y consultar el estado actual. | Funcional | @smoke — Draft |
| AC-LAB-F003-02 | Dado que una solicitud pertenece a otra persona, cuando el empleado intenta consultarla como propia, entonces el acceso se deniega. | Seguridad/funcional | No smoke — Draft |

No se especifican la presentación visual, el orden ni los filtros de la lista.

## Dependencias

- LAB-F001 — creación de solicitudes.
- SEC-001 — control de acceso a solicitudes propias.

## Preguntas abiertas

- LAB-OQ-008: ¿qué método de autenticación y modelo de autorización aplican?
- LAB-OQ-009: ¿cuánto tiempo se conservan solicitudes y decisiones?
- ¿Qué periodo, orden, búsqueda o filtros necesita la consulta? No se incluyen sin confirmación.
- LAB-OQ-010: ¿qué objetivos verificables de rendimiento y accesibilidad aplican?