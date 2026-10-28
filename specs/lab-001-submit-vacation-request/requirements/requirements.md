# Feature LAB-F001: Presentar una solicitud de vacaciones

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F001 |
| Issue | [gh#1](https://github.com/jCabreraMartin/vacation-management/issues/1) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: BR-001, FR-001 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Permitir al empleado presentar una solicitud hipotética de vacaciones con un intervalo de fechas y,
opcionalmente, un comentario.

### Valor de negocio

LAB-HYP: practicar la entrada al flujo centralizado de solicitudes descrito por BR-001. Este valor no
está confirmado para el producto real.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Empleado | Presenta la solicitud. Actor definido solo para el escenario didáctico. |

## Alcance

### Incluido

- Capturar fecha inicial y fecha final.
- Permitir añadir un comentario.
- Registrar inicialmente la solicitud como pendiente y confirmar el registro.

### Excluido

- Definir tipos de ausencia, políticas de acumulación, festivos o solapamientos.
- Mostrar o reservar saldo de días queda fuera de esta iteración (LAB-OQ-005); la pregunta sigue sin
  resolverse.
- Definir formato, zona horaria o validaciones completas de fechas; se tratan en LAB-F002 o siguen
  abiertos.
- Notificaciones por canal específico, integraciones y decisiones técnicas.

## Requisitos cubiertos

- BR-001 (parcial): flujo centralizado para presentar solicitudes y registrar su decisión.
- FR-001: presentar una solicitud con fecha inicial, fecha final y comentario opcional.
- SEC-001 (transversal): el empleado accede a sus propias solicitudes.

Todos los requisitos anteriores son hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. Rendimiento, disponibilidad, accesibilidad,
retención y otros umbrales permanecen sin definir (LAB-OQ-010).

## Historias de usuario

### US-LAB-F001-01: Presentar solicitud

**Como** empleado del escenario hipotético,  
**quiero** enviar un intervalo de fechas y, si lo deseo, un comentario,  
**para** registrar una solicitud en el flujo centralizado de práctica.

**Estado:** Draft / LAB-HYP  
**Dependencias:** ninguna dependencia de feature previa. SEC-001 es una regla transversal de acceso.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F001-01 | Dado un intervalo aceptado según las reglas que se confirmen, cuando el empleado envía la solicitud, entonces queda registrada inicialmente como pendiente y el empleado recibe confirmación. | Funcional | @smoke — Draft |
| AC-LAB-F001-02 | Dado que el empleado añade un comentario, cuando envía la solicitud, entonces el comentario queda asociado a esa solicitud. | Funcional | No smoke — Draft |

La evidencia de aceptación es propuesta y no está aprobada. El formato de fecha y el medio de
confirmación quedan abiertos.

## Dependencias

No hay una dependencia de feature previa. LAB-F002 es una capacidad de validación utilizada durante
el flujo de presentación; no es un prerrequisito independiente para iniciar LAB-F001. SEC-001 es una
regla transversal aplicable, no una dependencia de secuenciación.

## Preguntas abiertas

- LAB-OQ-002: ¿qué tipos de ausencia y datos obligatorios aplican además de las fechas y el comentario opcional?
- LAB-OQ-004: ¿se permiten fechas pasadas, intervalos solapados, festivos o fines de semana?
- LAB-OQ-008: ¿qué autenticación, privacidad, auditoría y retención se requieren?
- LAB-OQ-010: ¿qué objetivos medibles no funcionales aplican?

LAB-OQ-005 permanece pendiente, pero su análisis queda fuera de esta iteración.