# Línea base didáctica de requisitos — Gestión de vacaciones

> **Uso:** laboratorio; escenario hipotético para practicar el flujo de Bolt Framework.
>
> **Estado:** borrador ficticio, pendiente de validación. No representa requisitos aprobados del
> proyecto ni se deriva de las fuentes disponibles en `origin/`.

## 1. Propósito y límites

Esta línea base proporciona material de práctica para continuar con features, historias de usuario,
casos de uso y aclaraciones. Como no hay transcripciones ni documentos de Gestión de vacaciones, los
requisitos siguientes son hipótesis didácticas creadas para el laboratorio.

No deben tratarse como decisiones reales ni implementarse sin validación. El RFP de la calculadora
disponible en `origin/RFP-Calculator.md` no se usa como fuente para este escenario.

### Escenario hipotético

Una organización quiere que sus empleados puedan solicitar vacaciones y consultar el estado de sus
solicitudes. Una persona responsable revisa las solicitudes de los empleados que tiene asignados y
puede aprobarlas o rechazarlas.

El escenario no define cómo se calculan los días disponibles ni qué políticas de vacaciones aplica la
organización.

## 2. Actores hipotéticos

| Actor | Responsabilidad en el escenario |
| --- | --- |
| Empleado | Crea solicitudes y consulta el estado de sus propias solicitudes. |
| Responsable aprobador | Consulta y decide solicitudes de los empleados que tiene asignados. |

La asignación de empleados a responsables se presupone únicamente para hacer practicable el
laboratorio; el mecanismo para gestionarla queda sin definir.

## 3. Requisitos

Todos los requisitos de esta tabla tienen estado **Draft**. `LAB-HYP` identifica una hipótesis creada
para el ejercicio, no una fuente externa o una decisión aprobada.

| Identificador | Tipo | Enunciado | Fuente | Justificación | Evidencia de aceptación propuesta | Dependencias | Ambigüedades | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BR-001 | BR | La organización necesita un flujo centralizado para presentar solicitudes de vacaciones y registrar su decisión. | LAB-HYP-001 | Permite practicar el flujo de solicitud y aprobación de extremo a extremo. | En una prueba funcional se puede presentar una solicitud y consultar su decisión en el mismo sistema. | FR-001, FR-002, FR-003, FR-004 | No hay evidencia de que esta necesidad pertenezca al proyecto real. | Draft |
| FR-001 | FR | El empleado puede presentar una solicitud indicando fecha inicial y fecha final; puede añadir un comentario. La solicitud se registra inicialmente como pendiente. | LAB-HYP-001 | Define la entrada mínima necesaria para recorrer el flujo del laboratorio. | Al enviar fechas válidas, la solicitud queda registrada como pendiente y el empleado recibe confirmación. | SEC-001 | No están definidos los tipos de ausencia, campos obligatorios adicionales, zona horaria ni formato de fecha. | Draft |
| FR-002 | FR | El empleado puede consultar la lista y el detalle de sus propias solicitudes, incluido su estado actual. | LAB-HYP-001 | Permite al empleado conocer el resultado del flujo. | El empleado puede ver sus solicitudes y sus estados; no puede consultar las de otra persona como empleado. | FR-001, SEC-001 | No se define el periodo de consulta ni si se permiten búsquedas o filtros. | Draft |
| FR-003 | FR | El responsable aprobador puede consultar las solicitudes pendientes de los empleados que tiene asignados. | LAB-HYP-001 | Proporciona la bandeja de trabajo para tomar decisiones. | Una prueba con dos responsables verifica que cada uno solo ve las solicitudes pendientes de sus empleados asignados. | FR-001, SEC-001 | No se define quién asigna responsables ni cómo se resuelven sustituciones o cambios de equipo. | Draft |
| FR-004 | FR | El responsable aprobador puede aprobar o rechazar una solicitud pendiente. El sistema registra la decisión y permite al empleado consultar el estado resultante. | LAB-HYP-001 | Completa el flujo de revisión. | Una solicitud pendiente pasa a aprobada o rechazada tras una decisión autorizada; el empleado ve el estado actualizado. | FR-001, FR-002, FR-003, SEC-001 | No se sabe si el comentario de decisión es obligatorio ni si una decisión puede revertirse. | Draft |
| FR-005 | FR | El empleado puede retirar una solicitud mientras siga pendiente. | LAB-HYP-001 | Añade un flujo alternativo sencillo para el ejercicio. | Una solicitud pendiente retirada deja de aparecer como pendiente para el aprobador y muestra el estado retirado al empleado. | FR-001, FR-002, SEC-001 | No se define si se pueden cancelar solicitudes aprobadas ni qué ocurre si la revisión está en curso. | Draft |
| FR-006 | FR | El sistema rechaza una solicitud si falta una de las fechas o la fecha final es anterior a la fecha inicial. | LAB-HYP-001 | Hace verificable la validación básica de entrada sin definir políticas de negocio adicionales. | Enviar una solicitud sin fechas o con un intervalo invertido produce un error comprensible y no crea una solicitud pendiente. | FR-001 | No se define si se permiten solicitudes para el mismo día, fines de semana, festivos o periodos solapados. | Draft |
| SEC-001 | SEC | El sistema limita las acciones y los datos visibles según el actor: un empleado accede a sus propias solicitudes y un responsable a las solicitudes de sus empleados asignados. | LAB-HYP-001 | Evita que el escenario didáctico exponga solicitudes a actores no autorizados. | Pruebas de autorización confirman acceso permitido a los recursos propios/asignados y denegado a los demás. | FR-001, FR-002, FR-003, FR-004, FR-005 | El método de autenticación, los roles definitivos y las obligaciones de privacidad requieren definición real. | Draft |

## 4. Ciclo de vida hipotético

Para el laboratorio, se propone este ciclo mínimo:

```text
Pendiente → Aprobada
Pendiente → Rechazada
Pendiente → Retirada
```

Los estados y transiciones son hipótesis. No se propone reabrir, editar ni revertir una solicitud
después de una decisión.

## 5. Fuera de alcance de esta baseline

- Cálculo de saldo o días disponibles.
- Tipos de ausencia distintos de vacaciones.
- Calendarios laborales, fines de semana y festivos.
- Reglas de acumulación, antigüedad, límites o periodos restringidos.
- Integración con nómina, calendario corporativo, identidad u otros sistemas.
- Notificaciones por correo, chat o notificaciones push.
- Requisitos cuantificados de rendimiento, disponibilidad, retención o recuperación.
- Tecnología, arquitectura, base de datos y despliegue.

Estos elementos no se consideran descartados para el producto real; quedan pendientes de evidencia y
decisión.

## 6. Preguntas abiertas para validación

| ID | Pregunta | Impacto si no se resuelve |
| --- | --- | --- |
| LAB-OQ-001 | ¿El flujo de solicitud y aprobación representa una necesidad real del proyecto? | No se puede aprobar el alcance funcional. |
| LAB-OQ-002 | ¿Qué tipos de ausencia se pueden solicitar y qué datos son obligatorios? | No se pueden cerrar el formulario ni sus validaciones. |
| LAB-OQ-003 | ¿Cómo se determina el responsable de cada empleado y quién mantiene esa asignación? | No se puede cerrar la autorización ni la bandeja de aprobación. |
| LAB-OQ-004 | ¿Se permiten fechas pasadas, solicitudes solapadas o solicitudes que incluyan festivos y fines de semana? | No se pueden definir las reglas de validación de fechas. |
| LAB-OQ-005 | ¿Se necesita mostrar o reservar un saldo de días? ¿Qué política y fuente de datos lo determinan? | El saldo queda correctamente fuera de alcance; no debe inferirse. |
| LAB-OQ-006 | ¿Puede un empleado editar o retirar una solicitud después de enviarla o de que haya sido aprobada? | No se pueden definir todos los estados y transiciones. |
| LAB-OQ-007 | ¿Qué información debe incluir el motivo de rechazo y puede ser obligatorio? | No se puede completar el flujo de comunicación de la decisión. |
| LAB-OQ-008 | ¿Qué autenticación, privacidad, auditoría y retención exige la organización? | No se puede aprobar la política de seguridad y cumplimiento. |
| LAB-OQ-009 | ¿Qué sistemas externos deben integrarse, si los hay? | No se pueden definir contratos ni requisitos de integración. |
| LAB-OQ-010 | ¿Qué objetivos medibles de disponibilidad, rendimiento y accesibilidad se requieren? | No se pueden establecer NFR verificables. |

## 7. Próximo paso del laboratorio

1. Tratar estas hipótesis como material de práctica y revisar las preguntas abiertas.
2. Elegir una feature acotada, por ejemplo, el flujo de aprobación.
3. Generar historias y casos de uso vinculados a los requisitos pertinentes.
4. Usar Bolt Clarify para registrar las dudas; no inventar respuestas.
5. Si el ejercicio simula respuestas de cliente, etiquetarlas como respuestas ficticias del laboratorio
   y actualizar el estado de los requisitos solo dentro de ese escenario.

La línea base respaldada por fuentes reales sigue sin requisitos confirmados hasta que se aporten y
validen fuentes de Gestión de vacaciones.
