# Resumen de aclaraciones — Gestión de vacaciones

**Fecha de revisión:** 2026-10-27  
**Estado:** Revisión de requisitos hipotéticos; no hay features aprobadas para el producto.  
**Alcance:** Siete features LAB-HYP, sus siete historias y sus criterios de aceptación iniciales en `specs/`.

## Límites de esta iteración

El análisis de si se debe mostrar o reservar saldo de días (LAB-OQ-005 en la baseline didáctica) queda
fuera de esta iteración. La pregunta permanece abierta: no se considera resuelta, descartada ni
respondida.

## Cobertura

| Feature | Historia revisada | Criterios revisados | Caso de uso revisado |
| --- | --- | --- | --- |
| [LAB-F001 — Presentar una solicitud](lab-001-submit-vacation-request/requirements/requirements.md) | US-LAB-F001-01 | AC-LAB-F001-01, AC-LAB-F001-02 | [UC-001](lab-001-submit-vacation-request/requirements/use-cases/UC-001.md) |
| [LAB-F002 — Validar el intervalo de fechas](lab-002-validate-vacation-date-range/requirements/requirements.md) | US-LAB-F002-01 | AC-LAB-F002-01, AC-LAB-F002-02 | [UC-002](lab-002-validate-vacation-date-range/requirements/use-cases/UC-002.md) |
| [LAB-F003 — Consultar solicitudes propias](lab-003-view-own-vacation-requests/requirements/requirements.md) | US-LAB-F003-01 | AC-LAB-F003-01, AC-LAB-F003-02 | [UC-003](lab-003-view-own-vacation-requests/requirements/use-cases/UC-003.md) |
| [LAB-F004 — Consultar pendientes asignadas](lab-004-view-assigned-pending-requests/requirements/requirements.md) | US-LAB-F004-01 | AC-LAB-F004-01, AC-LAB-F004-02 | [UC-004](lab-004-view-assigned-pending-requests/requirements/use-cases/UC-004.md) |
| [LAB-F005 — Aprobar una solicitud](lab-005-approve-vacation-request/requirements/requirements.md) | US-LAB-F005-01 | AC-LAB-F005-01, AC-LAB-F005-02 | [UC-005](lab-005-approve-vacation-request/requirements/use-cases/UC-005.md) |
| [LAB-F006 — Rechazar una solicitud](lab-006-reject-vacation-request/requirements/requirements.md) | US-LAB-F006-01 | AC-LAB-F006-01, AC-LAB-F006-02 | [UC-006](lab-006-reject-vacation-request/requirements/use-cases/UC-006.md) |
| [LAB-F007 — Retirar una solicitud pendiente](lab-007-withdraw-pending-vacation-request/requirements/requirements.md) | US-LAB-F007-01 | AC-LAB-F007-01, AC-LAB-F007-02 | [UC-007](lab-007-withdraw-pending-vacation-request/requirements/use-cases/UC-007.md) |

La revisión también incluyó los siete casos de uso asociados a estas features. Las siete features,
historias, catorce criterios de aceptación y casos de uso son `Draft / LAB-HYP`: material ficticio para
el laboratorio, no requisitos aprobados. La [baseline de laboratorio](lab/requirements-baseline.md)
declara que los actores, estados y reglas son hipótesis. No se detectaron afirmaciones directamente
opuestas entre las historias o los casos de uso revisados: aprobación y rechazo son outcomes separados,
y la retirada está limitada a solicitudes pendientes. Sí hay términos, estados y condiciones que no
permiten determinar de forma inequívoca el comportamiento esperado.

## Hallazgos

| Área | Hallazgo | Impacto |
| --- | --- | --- |
| Estado y ciclo de vida | La baseline enumera Pendiente, Aprobada, Rechazada y Retirada. LAB-F007 también excluye una solicitud “en revisión”, pero no define si es un estado, si sigue siendo Pendiente ni qué transición aplica. | Alto: impide cerrar la regla de retirada y las transiciones. |
| Actores | Empleado y Responsable aprobador aparecen como actores hipotéticos. LAB-F002 nombra además al Sistema; no se explicitan de forma uniforme los actores de soporte para validación, autorización, registro y consulta. No hay stakeholders confirmados del producto. | Alto: no se pueden aprobar responsabilidades ni escenarios de aceptación del producto. |
| Asignación y autoridad | LAB-F004 y las decisiones dependen de una asignación empleado-responsable, cuyo responsable de mantenimiento, fuente y tratamiento de sustituciones no están definidos. | Alto: bloquea la bandeja y la autorización de decisión. |
| Términos y reglas | “Intervalo aceptado/válido”, “error comprensible”, “asignado”, “actualizado” y “retirar” no tienen criterios operativos completos. | Alto: diferentes interpretaciones pueden producir conductas incompatibles. |
| Datos | No se identifica propietario ni sistema de registro para empleados, asignaciones, solicitudes y decisiones; tampoco campos mínimos, conservación, auditoría o eliminación. | Alto: no se puede cerrar el modelo funcional ni el ciclo de vida de los datos. |
| Umbrales | No hay objetivos verificables de rendimiento, disponibilidad, capacidad, accesibilidad ni frescura de estado. | Medio/alto: no se pueden definir NFR ni pruebas de servicio. |
| Integraciones | No se documentan integraciones ni se declara formalmente si son inexistentes o están fuera del alcance. | Medio: alcance y contratos externos permanecen indeterminados. |
| Aceptación | Varios criterios dependen de reglas sin resolver o usan resultados cualitativos; faltan resultados observables para errores, consultas vacías, denegaciones, concurrencia y fallos de registro. | Alto: no todos los AC son reproducibles y verificables. |

## Preguntas por stakeholder e impacto

Los stakeholders y responsables concretos están por identificar. El impacto clasifica cuánto bloquea la
respuesta la definición o verificación del alcance hipotético; no es una decisión de prioridad del
negocio.

### Responsable de negocio o producto — por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-001 | Todas | Bloqueante | ¿Estas siete hipótesis representan necesidades del producto real o deben permanecer únicamente como material de laboratorio? |
| Q-002 | LAB-F001 / US-LAB-F001-01; LAB-F002 / US-LAB-F002-01 | Alto | ¿Qué tipos de ausencia, campos obligatorios y reglas de fechas definen una solicitud aceptable, incluidos fechas pasadas, mismo día, festivos, fines de semana y solapamientos? |
| Q-003 | LAB-F001 / US-LAB-F001-01; LAB-F007 / US-LAB-F007-01 | Alto | ¿Cuál es el ciclo de vida aprobado de una solicitud y qué significa “en revisión” respecto de Pendiente? ¿Qué transiciones, ediciones o retiradas se permiten en cada estado? |
| Q-004 | LAB-F005 / US-LAB-F005-01; LAB-F006 / US-LAB-F006-01 | Alto | ¿Qué significa registrar una decisión, cuándo se considera efectiva y puede aprobarse, rechazarse o reabrirse una solicitud más de una vez? |
| Q-005 | LAB-F003 / US-LAB-F003-01; LAB-F004 / US-LAB-F004-01 | Medio | ¿Qué campos deben aparecer en las listas y detalles, qué orden se espera y se requieren búsqueda, filtros, periodos o paginación? |

### Responsable de gestión de personas y asignaciones — por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-006 | LAB-F004 / US-LAB-F004-01; LAB-F005 / US-LAB-F005-01; LAB-F006 / US-LAB-F006-01 | Alto | ¿Quién determina y mantiene la asignación de cada empleado a uno o más responsables y cuál es su fuente de verdad? |
| Q-007 | LAB-F004 / US-LAB-F004-01; LAB-F005 / US-LAB-F005-01; LAB-F006 / US-LAB-F006-01 | Alto | ¿Cómo se resuelven sustituciones, cambios de equipo, varias asignaciones o ausencia del responsable, y quién puede decidir durante esos casos? |
| Q-008 | LAB-F004 / US-LAB-F004-01 | Medio | ¿Qué debe mostrarse cuando el responsable no tiene asignaciones o no tiene solicitudes pendientes? |

### Empleados y responsables aprobadores — validadores por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-009 | LAB-F002 / US-LAB-F002-01; AC-LAB-F002-01, AC-LAB-F002-02 | Alto | ¿Qué resultado observable y qué contenido hacen que el error sea “comprensible” para cada condición inválida? |
| Q-010 | LAB-F001 / US-LAB-F001-01; AC-LAB-F001-01 | Medio | ¿Qué evidencia y canal constituyen la confirmación de una solicitud registrada? |
| Q-011 | LAB-F001 / US-LAB-F001-01; LAB-F005 / US-LAB-F005-01; LAB-F006 / US-LAB-F006-01 | Medio | ¿Qué longitud, obligatoriedad, visibilidad y reglas de modificación aplican al comentario de solicitud y al posible motivo de decisión? |
| Q-012 | LAB-F003 / US-LAB-F003-01; LAB-F004 / US-LAB-F004-01 | Medio | ¿Qué comportamiento se espera ante una lista vacía, un detalle inexistente o una consulta fallida? |

### Responsables de identidad, seguridad, datos y cumplimiento — por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-013 | LAB-F001–LAB-F007; SEC-001 | Alto | ¿Cómo se identifica a cada empleado y responsable, qué roles existen y qué reglas verificables gobiernan el acceso a solicitudes propias o asignadas? |
| Q-014 | LAB-F001–LAB-F007 | Alto | ¿Quién es propietario de los datos de empleado, asignación, solicitud y decisión, y qué sistema es la fuente de verdad para cada conjunto? |
| Q-015 | LAB-F001–LAB-F007 | Alto | ¿Qué datos deben conservarse y durante cuánto tiempo, quién puede corregirlos o eliminarlos, y qué historial de cambios debe auditarse? |
| Q-016 | LAB-F005 / US-LAB-F005-01; LAB-F006 / US-LAB-F006-01; LAB-F007 / US-LAB-F007-01 | Alto | ¿Qué evidencia de quién/cuándo debe quedar asociada a una aprobación, rechazo o retirada, y qué obligaciones de privacidad o cumplimiento aplican? |

### Responsable de integraciones y operación — por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-017 | Todas | Medio | ¿Hay sistemas externos dentro del alcance? Si los hay, ¿qué datos intercambia cada integración, en qué dirección y cuál es el sistema propietario? |
| Q-018 | Todas, si Q-017 confirma integraciones | Medio | Para cada integración confirmada, ¿qué protocolo y autenticación se requieren, y qué comportamiento se espera ante errores, indisponibilidad, duplicados o datos desactualizados? |
| Q-019 | Todas | Medio | ¿Qué objetivos medibles de disponibilidad, tiempo de respuesta, capacidad, accesibilidad y actualización del estado se deben cumplir? |

### Responsable de producto y aceptación / QA — por identificar

| ID | Features / historias | Impacto | Pregunta abierta |
| --- | --- | --- | --- |
| Q-020 | LAB-F001 / AC-LAB-F001-01 | Alto | ¿Qué conjunto de ejemplos y reglas determina que un intervalo sea aceptado, para que el criterio no dependa de “las reglas que se confirmen” sin una referencia verificable? |
| Q-021 | LAB-F003 / AC-LAB-F003-01–02; LAB-F004 / AC-LAB-F004-01–02 | Alto | ¿Qué datos y resultados observables demostrarán que la lista, el detalle y el estado son correctos, y que un acceso ajeno se deniega sin revelar datos? |
| Q-022 | LAB-F005 / AC-LAB-F005-01–02; LAB-F006 / AC-LAB-F006-01–02 | Alto | ¿Qué prueba observable demuestra que una decisión queda registrada y que el empleado ve el estado actualizado, y dentro de qué plazo? |
| Q-023 | LAB-F007 / AC-LAB-F007-01–02 | Alto | ¿Qué resultado exacto debe observarse al intentar retirar una solicitud no pendiente, en revisión o que cambia de estado durante la acción? |
| Q-024 | LAB-F001–LAB-F007; todos los AC | Alto | ¿Qué respuestas se esperan y cómo se verifican ante fallo de persistencia, consulta temporalmente no disponible, reintento o acciones concurrentes? |
| Q-025 | LAB-F001–LAB-F007; todos los AC | Medio | ¿Quién aprobará los criterios de aceptación y qué evidencia convertirá cada criterio Draft en una condición comprobable y aceptada? |

## Correspondencia con la baseline didáctica

La baseline usa IDs `LAB-OQ-*` y este resumen usa IDs `Q-*`. La tabla relaciona las preguntas de
baseline con las aclaraciones de esta revisión; una fila puede corresponder a varias preguntas porque
el resumen desglosa o amplía la pregunta original.

| Pregunta de baseline | Pregunta(s) de aclaración | Correspondencia |
| --- | --- | --- |
| LAB-OQ-001 | Q-001 | Confirma si el escenario hipotético representa el producto real o solo el laboratorio. |
| LAB-OQ-002 | Q-002, Q-011 | Desglosada en tipos de ausencia, campos obligatorios y reglas de comentarios. |
| LAB-OQ-003 | Q-006, Q-007, Q-008 | Desglosada en propiedad de asignaciones, sustituciones y comportamiento sin solicitudes asignadas. |
| LAB-OQ-004 | Q-002, Q-009, Q-020 | Reglas de fechas, errores comprensibles y ejemplos que permitan decidir si un intervalo es aceptable. |
| LAB-OQ-005 | — | Fuera de esta iteración; sigue abierta y no se considera resuelta. |
| LAB-OQ-006 | Q-003, Q-004, Q-023 | Desglosada en ciclo de vida, reversión de decisiones y resultado al retirar solicitudes no pendientes. |
| LAB-OQ-007 | Q-011 | Motivo/comentario de decisión, obligatoriedad y contenido. |
| LAB-OQ-008 | Q-013, Q-015, Q-016 | Desglosada en identidad/autorización, conservación de datos, auditoría y cumplimiento. |
| LAB-OQ-009 | Q-017, Q-018 | Existencia, alcance y comportamiento de integraciones. |
| LAB-OQ-010 | Q-019 | Objetivos medibles de servicio, accesibilidad y actualización. |

Q-005, Q-012, Q-014, Q-021, Q-022, Q-024 y Q-025 añaden preguntas de detalle o aceptación que no
tienen un ID equivalente directo en la baseline. Se conservan como aclaraciones complementarias, no
como nuevas respuestas ni requisitos confirmados.

## Estado de aclaración

- **Aclaraciones resueltas:** ninguna; este documento no propone respuestas ni decisiones.
- **Material revisado:** 7 features LAB-HYP, 7 historias, 14 criterios de aceptación Draft y 7 casos de uso.
- **Features aprobadas del producto:** 0, según el catálogo actual.
- **Siguiente paso:** obtener respuestas de los stakeholders identificados y actualizar cada spec solo después de validarlas; mantener las hipótesis separadas de los requisitos aprobados. LAB-OQ-005 no se aborda en esta iteración.