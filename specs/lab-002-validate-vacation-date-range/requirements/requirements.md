# Feature LAB-F002: Validar el intervalo de fechas de una solicitud

## Metadata

| Propiedad | Valor |
| --- | --- |
| ID de feature | LAB-F002 |
| Issue | [gh#6](https://github.com/jCabreraMartin/vacation-management/issues/6) |
| Estado | Draft — LAB-HYP, hipótesis ficticia del laboratorio |
| Escenario | fullstack (detección de constitución) |
| Fuente | `specs/lab/requirements-baseline.md`: FR-006 |
| Prioridad / esfuerzo | No definidos en la fuente |

Esta feature no está aprobada para el producto ni debe implementarse sin validación del negocio.

## Contexto de negocio

### Objetivo

Evitar que una solicitud con fechas ausentes o con fecha final anterior a la inicial se registre como
pendiente.

### Valor de negocio

LAB-HYP: hace verificable la validación básica de entrada del flujo didáctico. No es un valor de
negocio confirmado.

### Actores

| Actor | Participación hipotética |
| --- | --- |
| Empleado | Envía una solicitud y recibe el error de validación. Actor afectado por el flujo FR-001. |
| Sistema | Rechaza la entrada inválida y evita crear la solicitud pendiente. |

## Alcance

### Incluido

- Rechazar la solicitud si falta la fecha inicial o final.
- Rechazarla si la fecha final es anterior a la inicial.
- Comunicar un error comprensible sin crear una solicitud pendiente.

### Excluido

- Reglas para fechas pasadas, mismo día, festivos, fines de semana o solapamientos.
- Zona horaria, formato de entrada, calendario laboral o política de saldo.
- Implementación, canal de error o decisiones técnicas concretas.

## Requisitos cubiertos

- FR-006: rechazar fechas ausentes o un intervalo invertido, sin registrar la solicitud.

El requisito es una hipótesis `LAB-HYP`, estado Draft.

## Requisitos no funcionales

No se identifica ningún NFR aplicable en la baseline. La comprensibilidad del error figura en FR-006,
pero no se especifican criterios de contenido, idioma o accesibilidad; quedan pendientes de validación.

## Historias de usuario

### US-LAB-F002-01: Rechazar intervalos de fecha inválidos

**Como** empleado del escenario hipotético,  
**quiero** recibir un error comprensible cuando las fechas no forman un intervalo aceptable,  
**para** poder corregir la entrada sin crear una solicitud inválida.

**Estado:** Draft / LAB-HYP  
**Dependencias:** LAB-F001 — captura de la solicitud.

#### Criterios de aceptación iniciales

| ID | Criterio | Tipo | Clasificación |
| --- | --- | --- | --- |
| AC-LAB-F002-01 | Dado que falta una de las fechas, cuando se intenta enviar la solicitud, entonces el sistema muestra un error comprensible y no crea una solicitud pendiente. | Funcional | No smoke — validación/error, Draft |
| AC-LAB-F002-02 | Dado que la fecha final es anterior a la inicial, cuando se intenta enviar la solicitud, entonces el sistema muestra un error comprensible y no crea una solicitud pendiente. | Funcional | No smoke — validación/error, Draft |

Los criterios son propuestas de aceptación, no pruebas aprobadas. “Error comprensible” necesita
validación con negocio y pruebas.

## Dependencias

- LAB-F001 — formulario y envío de la solicitud.

## Preguntas abiertas

- LAB-OQ-002: ¿qué formato, zona horaria y campos obligatorios se aplican?
- LAB-OQ-004: ¿se permiten fechas pasadas, solicitudes de un día, solapamientos, festivos y fines de semana?
- ¿Qué contenido o comportamiento hace que el mensaje de error sea comprensible y verificable?