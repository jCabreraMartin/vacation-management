# Registro técnico: LAB-F005: Aprobar una solicitud de vacaciones

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal; no aprobado para el producto. |
| Issue | [#4](https://github.com/jCabreraMartin/vacation-management/issues/4) |
| Plan | [plan.md](plan.md) |
| Evidencia de esta entrega | Revisión de fuentes locales; sin investigación externa, experimento de código o elección tecnológica. |

## 1. Base, consultas y puertas compartidas

- Reutilizar [F001-B1](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo)
  y [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar)
  por referencia; su definición no se duplica ni se cierra. F001-B4 aporta registro y pertenencia reales,
  no acreditados por un plan o un doble. T-02/T-03 cubren la exposición y registro de aprobar cuando se acuerden.
- Reutilizar [F003: consulta de estado propio](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas)
  para AC-F005-02; no crear consulta o pantalla del empleado nueva. Mantener propiedad, cuatro estados
  y carácter de solo lectura. El [registro de F003](../../lab-003-view-own-vacation-requests/planning/research.md)
  no añadió puertas ni objetivos de frescura.
- Reutilizar [F004: responsable/asignado/Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md#1-objetivo-y-alcance-trazado)
  y [T-06: dato de asignación](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación).
  T-04 y T-06 siguen separadas: capacidad/identidad frente a ámbito asignado. Comprobar permiso de
  decidir al aprobar; el permiso de leer una fila en F004 no basta.

Solo se añade T-07, a continuación. Los campos, comentarios y mensajes pendientes siguen siendo
aclaraciones funcionales; no se abren elecciones técnicas paralelas para resolverlos. F006/F007 son
contexto de reutilización/compatibilidad, no dependencias de implementación para probar F005.

## 2. T-07: concurrencia de la aprobación

**Estado:** pendiente funcional y técnica; bloqueante para el cierre integrado de F005-B2/B4. No es una
solución seleccionada ni una investigación ya ejecutada.

### Evidencia y correspondencia de preguntas

UC-005 3a pide no aprobar si ya no está Pendiente y deja sin definir respuesta visible/concurrencia;
4a deja abierto el fallo al registrar y 6a la disponibilidad del estado actualizado. El Gherkin declara
el gap sin escenario concurrente completo. El modelo de estados y la arquitectura no fijan precedencia.

Referencias: LAB-OQ-006, Q-003/Q-004/Q-023/Q-024 y Q-022 para efectividad/lectura. Este encargo pide
registrar concurrencia en el contexto de LAB-OQ-006/007. Se conserva esa relación sin cambiar las
fuentes: LAB-OQ-007 es comentario/motivo en baseline, y F005 lo refiere al comentario de aprobación
(Q-011); no contiene por sí mismo una regla de resolución concurrente.

### Parte funcional pendiente

¿Qué resultado observable corresponde si, entre abrir una Pendiente e intentar aprobarla, otra acción
la retira o decide? ¿Cuándo se considera efectiva una decisión, cómo se conoce un registro confirmado
y qué se espera ante resultado incierto, reintento o decisiones simultáneas? ¿Qué evidencia demuestra
la actualización consultable por el empleado? El autor del laboratorio debe aclararlo; una tecnología
no responde estas preguntas ni aprueba la política real.

Lo único exigible ahora es que **una solicitud que ya no está Pendiente no cambie a Aprobada por el
intento de aprobar**. No se fija qué actor gana si ambos actúan sobre Pendiente, ni orden, mensaje,
código, política de duplicados o reversión. Que no se implemente reapertura no convierte LAB-OQ-006
en una pregunta respondida. La obligatoriedad de comentario LAB-OQ-007/Q-011 permanece separada.

### Parte técnica pendiente

La regla debe sostenerse en la frontera real que registra, incluyendo el caso en que el estado cambia
después de una lectura inicial. Un filtro UI, una comprobación previa sobre datos obsoletos o un doble
que acepta solo casos ya filtrados no demuestran esa garantía.

Tras aclarar la semántica, investigar únicamente qué garantías ofrece el mecanismo común aceptado
por T-02/T-03 y cómo verificarlas con el registro y contexto T-04/T-06 reales. No se elige bloqueo
optimista/pesimista, versión, idempotencia, transacción, rollback, reintento, compensación, broker,
almacenamiento o ORM. Tampoco se define límite de agregado/transacción DDD como atajo para decidirlo.

### Comprobación futura y criterio de desbloqueo

1. Aclaración explícita de efectividad/confirmación y del resultado observable de las situaciones
   concurrentes necesarias para el alcance; las preguntas ajenas al alcance siguen abiertas.
2. Garantía técnica acordada y evidenciada en el registro común, sin selección implícita por plantilla.
3. Prueba reproducible que lea Pendiente, intercale un cambio ya establecido a Aprobada/Rechazada/Retirada
   y compruebe que el intento de aprobación no lo sobrescribe. Aislar el intercalado con infraestructura
   de pruebas; no implementar rechazo o retirada ni crear endpoints funcionales de preparación.
4. Separar esa prueba de las acciones realmente simultáneas: su resultado exacto solo se verificará
   cuando se defina, sin inferir ganador ni garantía de idempotencia.
5. Evidencia de registro confirmado y consulta posterior vía F003, conforme al criterio acordado de
   Q-022; sin inventar un plazo para hacerlo verificable.

Mientras falte aclaración o demostración real, T-07 permanece pendiente y B2/B4 no se cierran. Es
posible revisar B1 con estado/registro controlados y B3 con dobles después del backend aislado. Un
prototipo secuencial o un fixture no cierra la puerta de concurrencia. No se ha ejecutado investigación
externa ni experimento ni se han creado issues adicionales en esta entrega.

## 3. Otras aclaraciones que no puede responder la tecnología

| Fuente | Pregunta abierta | Límite para la ejecución |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-014 | Fuente, responsable de mantenimiento, cardinalidad y cambios de asignación | T-06 heredada; no elegir fichero/seed/servicio de RR. HH. ni gestionar sustituciones. |
| LAB-OQ-008; Q-013 | Identidad, capacidad para decidir y ámbito | T-04 heredada; ni actor del navegador ni propiedad por F003 otorgan permiso de aprobación. Sin IdP/RBAC/ABAC/claims/policies elegidos. |
| LAB-OQ-006; Q-003/Q-004/Q-023 | Reapertura, reversión, retirada/en revisión y decisiones múltiples | No implementar otras transiciones. F007 solo compartiría precondición de estado, no autorización del responsable. |
| LAB-OQ-007; Q-011 | Comentario de aprobación/motivo y obligatoriedad | No añadir comentario de decisión como capacidad obligatoria ni opcional no definida. Distinguir del comentario de solicitud FR-001, que sí es opcional. |
| LAB-OQ-008; Q-015/Q-016 | Evidencia de quién/cuándo, auditoría, privacidad y retención | Registrar estado no equivale a historial detallado ni exige nuevos campos de decisión sin aclaración. Sin cumplimiento regulatorio declarado. |
| Q-004/Q-014/Q-022/Q-024 | Registro efectivo, resultado incierto y consulta actualizada | T-07 y puertas compartidas; no afirmar éxito, fallo definitivo, frescura inmediata o recuperación sin evidencia. |
| Q-005/Q-011/Q-021/Q-024 | Datos, mensajes, canal/confirmación, denegación frente a inexistencia/no Pendiente | Mockups provisionales; no elegir equivalencias, texto, código ni confirmación previa. |
| Q-019/Q-022/Q-025 | Objetivos de servicio y autoridad/evidencia de aceptación | Sin NFR inventados ni aprobación de negocio ficticia. |

LAB-OQ-005 permanece expresamente fuera: no mostrar, reservar, consumir o recalcular saldo al aprobar.
No se investigan calendarios, notificaciones ni integraciones de negocio no evidenciadas para completar
el flujo. Los ejemplos de skills no eligen Angular/PrimeNG, ORM, arquitectura o política de seguridad.

## 4. Referencias visuales y soporte incompleto

Los cuatro [mockups de F005](../mockups/README.md), con revisión del [CHANGELOG](../mockups/CHANGELOG.md),
se asignan a F005-B3 en el [plan](plan.md#5-cuatro-mockups-y-estados-sin-soporte); B1/B2 aportan reglas
y B4 su comprobación real. Default no decide campos definitivos de detalle ni comentario de decisión.
Loading no modela un nuevo estado de solicitud, bloqueo o idempotencia.

El único HTML error representa no Pendiente/no autorizado/inexistente, pero no define respuestas
distintas o comunes ni la situación concurrente. Su rótulo de no registro no debe aplicarse a un fallo
técnico con resultado incierto sin aclarar qué se sabe del registro. Success muestra Aprobada, pero
solo un resultado confirmado habilita esa afirmación, y no demuestra por sí solo consulta de F003.
No hay pantalla definida para conflicto concurrente, asignación ambigua o retraso de lectura; no se
crean ni se da por resuelto el gap mediante placeholders.

## 5. Avance permitido y evidencia de calidad pendiente

- F005-B1: reglas backend con actores/asignaciones/registros de prueba, tras consumir base y fronteras
  compartidas. Regla Pendiente reutilizable, solo destino Aprobada implementable en este alcance.
- F005-B3: revisión aislada de los cuatro HTML después de B1 y la UI base F004; sin fingir registro
  real, cerrar puertas o habilitar aprobación operativa mientras falte B2.
- F005-B2/B4: necesitan F001/F003/F004 reales y T-02/T-03/T-04/T-06/T-07 concretadas donde se
  consuman; T-01/T-05 para la representación frontend aplicable. Ninguna puerta se cierra por leer planes.
- Negativos obligatorios: responsable no asignado; propietario solo Empleado; cada uno de los tres
  estados no Pendiente; inexistencia. No bastan botones ocultos; verificar registro y no exposición.
- Gates futuros: build/lint, unitarias ≥80 %, mutación ≥60 %, integración, arquitectura y scans sin
  críticos; imagen cuando exista. No se han ejecutado tests de aplicación ni se declaran gates de
  implementación pasados al generar documentación. Gate inaccesible se registra pendiente, no omitido.

## 6. Comentario preparado para el issue #4

**Estado de publicación:** preparado, no enviado. Las herramientas de esta sesión no incluyen escritura
en GitHub. Este texto permite completar el seguimiento sin simular publicación ni modificar el issue.
Los enlaces a la rama son previstos hasta publicar los archivos; no se solicita commit/push.

> Plan técnico de LAB-F005 preparado en Draft / LAB-HYP; sin implementación ni aprobación de negocio.
>
> Cuatro Bolts: F005-B1 regla backend Pendiente → Aprobada y autorización aisladas; F005-B2 registro
> e integración real con consultas F003/F004; F005-B3 acción de aprobación y cuatro estados de UI;
> F005-B4 cuatro escenarios Gherkin, negativos y verificación integrada.
>
> Se reutilizan F001-B1/B4, T-01–T-05, consulta de estado propio F003, regla de asignación F004 y T-06.
> No se duplican foundation, registro ni consulta del empleado. La precondición Pendiente se diseña
> para reutilización futura en F006 y compatibilidad con F007, sin implementar rechazo/retirada.
>
> Nueva T-07 funcional y técnica pendiente: concurrencia/efectividad del registro, UC-005,
> LAB-OQ-006/007 y Q-004/Q-022/Q-023/Q-024. LAB-OQ-007 conserva su pregunta de comentario (Q-011).
> B2/B4 no se cierran sin aclaración y evidencia real. Solo se exige que no se apruebe una solicitud
> que ya no esté Pendiente; no se eligen bloqueo, versionado, idempotencia, ganador ni mensajes.
>
> Negativos: responsable no asignado, propietario solo Empleado, Aprobada/Rechazada/Retirada e
> inexistencia. Lectura por F003 debe mostrar Aprobada tras registro confirmado, sin inventar plazo
> de propagación. El error genérico del mockup no resuelve concurrencia ni registro incierto.
>
> Gates previstos: build/lint, unitarias ≥80 %, mutación ≥60 %, integración, arquitectura y scans
> sin críticos. Asignación, comentario, reversión, auditoría y respuestas pendientes no se resuelven;
> saldo, notificaciones y transiciones F006/F007 quedan fuera. Sin código, tasks, OpenAPI o data-model.
>
> [Plan](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-005-approve-vacation-request/planning/plan.md)
> y [registro técnico](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-005-approve-vacation-request/planning/research.md).
> Documentos locales, publicación remota pendiente; no se ha solicitado commit/push.

## 7. Fuentes

- [Plan F005](plan.md), [requisitos](../requirements/requirements.md), [UC-005](../requirements/use-cases/UC-005.md), [Gherkin](../tests/approve-vacation-request.feature) y [modelo de estados](../requirements/state-model.md).
- [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [puertas compartidas](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: plan](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [F004: plan](../../lab-004-view-assigned-pending-requests/planning/plan.md) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md).
- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md), [clarificaciones](../../clarification-summary.md), [dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura](../../../docs/design/architecture/architecture-overview.md).