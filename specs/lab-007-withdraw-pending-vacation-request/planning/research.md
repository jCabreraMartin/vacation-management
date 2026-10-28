# Registro técnico: LAB-F007: Retirar una solicitud pendiente propia

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal; no aprobado para el producto. |
| Issue | [#5](https://github.com/jCabreraMartin/vacation-management/issues/5) |
| Plan | [plan.md](plan.md) |
| Evidencia de esta entrega | Revisión de fuentes locales; sin investigación externa, experimento de código o elección tecnológica. |

## 1. Reutilización y dependencias sin duplicación

F007 añade el destino fijo `Retirada` y una acción en el detalle propio. Reutiliza el registro y las
consultas comunes; no requiere otro motor de transiciones ni una plataforma de retirada.

| Fuente única | Consumo en F007 |
| --- | --- |
| [F001: base/registro](../../lab-001-submit-vacation-request/planning/plan.md) y [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | F001-B1/B4 para base y solicitudes/pertenencia reales; puertas comunes para herramientas, entrada, datos y contexto. T-05 solo para datos ya expuestos, no reglas temporales nuevas. |
| [F003: propiedad y consulta propia](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | Reutilizar pertenencia como permiso de retirar y consulta posterior del estado Retirada. Volver a comprobar propiedad al ejecutar; una pantalla previa no concede autorización. |
| [F005: precondición y registro comunes](../../lab-005-approve-vacation-request/planning/plan.md#4-componentes-propuestos-y-reutilización-de-la-transición) | Dependencia de la regla Pendiente revisada en F005-B1 y de la parte común del mecanismo de F005-B2. Separar estado de permiso: **no** reutilizar autorización responsable/asignado para retirar. |
| [T-07 de F005](../../lab-005-approve-vacation-request/planning/research.md#2-t-07-concurrencia-de-la-aprobación) | Misma puerta funcional/técnica pendiente que consume F006; demostrar su garantía para Retirada y mantener revisión en curso como aclaración necesaria. Sin otra definición o mecanismo. |
| [F004: consulta Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md#4-componentes-y-flujo-propuesto-backend-primero) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Solo dependencia de integración del efecto exigido en AC-01/UC-007. Retirar propia no depende de asignación a responsable; acreditar exclusión en consulta real F004 sí necesita su contexto/asignación reales. |
| [F006: delta y reutilización](../../lab-006-reject-vacation-request/planning/plan.md) | Referencia de ampliación sobre mecanismo común; su T-08 de motivo de rechazo no aplica a retirada. No requiere UI o flujo completo de rechazo. |

Las dependencias funcionales declaradas son F001, F003 y SEC-001. No se convierten F004 ni asignación
en una condición nueva para permitir retirada, ni se exige la UI del responsable para verificar el
efecto. F005 aporta componente de estado/registro, no una decisión de aprobación ejecutada antes de retirar.
Si faltan componentes compartidos, deben entregarse desde el Bolt de origen, sin duplicarlos en F007.

## 2. Aplicación de T-07 a retirada y revisión en curso

**Estado:** T-07 permanece definida únicamente en F005; no se añade ni renumera otra puerta. Su
aplicación a F007 está pendiente de aclaración funcional y demostración técnica del mismo mecanismo.

### Concurrencia retirar frente a decidir

LAB-OQ-006, Q-003/Q-004/Q-023/Q-024 y UC-007 dejan abierta la respuesta si el estado cambia durante
la acción o el responsable decide a la vez. Solo se exige que una solicitud que ya no esté Pendiente
no pase a Retirada por el intento de retirada. No se elige ganador, orden, mensaje, código, bloqueo
optimista/pesimista, versión, idempotencia, transacción, retry, rollback o compensación.

Consumir T-07 implica demostrar la restricción en la frontera real que registra, no solo mediante
un `if` sobre una lectura anterior. La prueba propuesta reutiliza los intercalados comunes con
destino Retirada: leer Pendiente, establecer desde infraestructura de pruebas un cambio a
Aprobada/Rechazada/Retirada antes de aplicar retirada y comprobar que no se sobrescribe. No exige
implementar decisiones para generar fixtures ni especifica el resultado exacto de competidores simultáneos.

### Cuarto Gherkin: resultado conocido, condición sin definición reproducible

«No marcar como retirada una solicitud cuya revisión está en curso» expresa no retirada; UC-007 3d
y el alcance conservan esa exclusión. Las fuentes no definen qué hace que una revisión esté en curso
ni si la solicitud continúa Pendiente. El [modelo de estados](../../lab-005-approve-vacation-request/requirements/state-model.md)
no incluye En revisión como estado.

Por ello, la regla Pendiente es necesaria pero no cierra ese caso. No se añade un estado, flag,
marca temporal, sesión, bloqueo o supuesto «responsable abrió detalle». Tampoco se traduce revisión
en Aprobada/Rechazada para pasar el escenario. Se registra como **bloqueado** hasta aclarar
LAB-OQ-006/Q-003/Q-023 dentro de la parte funcional de T-07, sin editar su fuente en F005.

Un test con condición abstracta simulada solo serviría para discutir el resultado citado, no para
demostrar una detección real. No se declara cubierto el cuarto escenario por tener pruebas de
estados finales ni se elimina o reescribe el Gherkin en esta entrega.

### Criterio de desbloqueo para F007

1. Aclaración explícita de qué significa revisión en curso, relación con Pendiente y condición
   observable/preparación reproducible del cuarto escenario; sin resolver por tecnología la pregunta funcional.
2. Aclaración de resultado/efectividad y evidencia necesaria ante retirada y decisión competidoras,
   según el alcance que vaya a aceptarse; no fijar precedencia por inferencia.
3. Mecanismo común acordado conforme a T-02/T-03/T-04 y T-07, con evidencia real de no cambio desde
   estados no Pendiente también para Retirada. No basta prueba aislada o snapshot previo a guardar.
4. Registro confirmado y consultas posteriores verificables: F003 muestra Retirada al propietario y
   F004 excluye la solicitud al releer Pendiente. Q-022/Q-024 siguen abiertas donde no definan frescura/fallos;
   no se inventa un plazo para hacer pasar la prueba.

Sin esas condiciones, no se cierra UC-007 ni el Bolt de verificación completa. Puede revisarse la
ampliación de estado y propiedad aislada y, después, la UI con dobles. No se ha realizado experimento
ni investigación externa ni creado otro issue de concurrencia en esta entrega.

## 3. Propiedad y comprobación del efecto en F004

El permiso para retirar deriva de ser Empleado propietario, reutilizando el criterio de F003.
El responsable no propietario no puede retirar aunque tenga asignado al empleado y pueda consultar
o decidir la Pendiente. Ese negativo aplica SEC-001 por operación, no una prohibición nueva sobre
personas que puedan actuar también como empleados en sus solicitudes propias. Roles definitivos y
modelo de autorización siguen pendientes en T-04/Q-013.

La integración de efecto usa el mismo registro: una Pendiente propia aparece inicialmente para un
responsable asignado en F004; el propietario retira; una nueva consulta F004 ya no la devuelve,
mientras otra Pendiente autorizada de control sigue visible. F003 conserva la solicitud y devuelve
Retirada a su propietario. No borrar la solicitud ni vaciar la bandeja como sustituto del filtro.

F004-B2/T-06 reales son necesarios para acreditar ese efecto, no para autorizar la retirada. Si
faltan, se puede demostrar el núcleo aislado, pero el efecto de AC-01 permanece pendiente; una lista
fake no lo cierra. No se requiere modificar alcance/UI/contrato de F004, implementar notificación,
polling, push, job, caché o prometer actualización inmediata de una pantalla ya abierta.

## 4. Otras preguntas abiertas y límites visuales

| Fuente | Pregunta abierta | Tratamiento |
| --- | --- | --- |
| LAB-OQ-006; Q-003/Q-023 | Revisión, cancelación de Aprobadas y ciclo de vida | No inventar estados o cancelación; resultado del cuarto Gherkin pendiente de condición reproducible. |
| UC-007 preguntas abiertas | Confirmación explícita previa | Sin diálogo añadido. Confirmación posterior del resultado no demuestra necesidad ni ausencia definitiva de confirmación previa. |
| LAB-OQ-008; Q-013/Q-014/Q-015/Q-016 | Identidad, propiedad, privacidad, auditoría y retención | T-04 y mecanismo común; sin historial detallado, actor/fecha de retirada o política de conservación inventados. |
| Q-022/Q-024; UC-007 4a | Resultado incierto, recuperación y disponibilidad del estado | No afirmar éxito ni fallo definitivo sin evidencia; sin retry, rollback, plazo o frescura prometidos. |
| Q-005/Q-012/Q-021/Q-024 | Campos, denegación y errores de consulta/acción | Mantener límites de F003/F004; no añadir datos/mensajes o equivalencias de causas no definidas. |
| Q-019/Q-025 | NFR y autoridad/evidencia de aceptación | Sin targets, nivel WCAG, SLO o sign-off de negocio ficticios. |

Los [cuatro mockups](../mockups/README.md), con revisión del [CHANGELOG](../mockups/CHANGELOG.md),
se asignan a F007-B2 en el [plan](plan.md#5-cuatro-mockups-y-soporte-incompleto). Default no contiene
diálogo previo; loading no es un estado persistido ni garantía concurrente. Error no diferencia
ajena/no Pendiente ni define revisión/conflicto/registro incierto. Su rótulo de no completado no
demuestra ausencia de escritura ante resultado desconocido. Success exige registro confirmado de
Retirada; no acredita por sí solo lectura F003 o exclusión F004.

No se crean estados visuales o textos para cerrar esas preguntas. No se añade motivo de retirada,
ventana temporal, reversión, notificación al responsable ni cancelación de Aprobadas. T-08 de F006 no
se hereda para inventar motivo en F007; saldo LAB-OQ-005 sigue abierto y fuera del alcance.

## 5. Avance permitido y gates pendientes

- **F007-B1:** delta backend con precondición Pendiente de F005 y pertenencia de F003 revisadas.
  Núcleo aislado posible; cierre real exige registro/contexto/garantías comunes y consultas reales.
  El efecto F004 y revisión en curso deben constar pendientes si faltan sus prerrequisitos.
- **F007-B2:** cuatro representaciones desde detalle propio después del backend, no nueva pantalla
  del responsable. Dobles permiten revisión parcial, no cierre de confirmación/concurrencia/revisión.
- **F007-B3:** cuatro escenarios con evidencia diferenciada y negativos de responsable/estados finales.
  No requiere UI F004 ni toda F005/F006; sí componentes compartidos consumidos y semántica de revisión
  aclarada para declarar el cuarto escenario y UC-007 completos.
- Negativos: solicitud de otro empleado; responsable no propietario, incluso asignado; Aprobada,
  Rechazada y ya Retirada. Verificar no cambio y no exposición en backend/payload/DOM, no solo controles.
- Gates futuros: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración, arquitectura y
  scans sin críticos; imagen cuando exista. Se reutilizan gates comunes. Si falta gate/garantía,
  registrar bloqueo o no aplicabilidad justificada, nunca marcarlo pasado con dobles o porcentajes globales.

Esta entrega no ejecuta tests de aplicación ni elige tecnología o políticas. No crea código, tasks,
OpenAPI, data-model, nuevos Gherkin, ramas o work items, y no utiliza Azure DevOps.

## 6. Comentario preparado para el issue #5

**Estado de publicación:** preparado, no enviado. Las herramientas de esta sesión no incluyen escritura
en GitHub. Los enlaces a la rama son previstos hasta publicar los archivos; no se solicita commit/push.

> Plan técnico LAB-F007 preparado en Draft / LAB-HYP; sin implementación ni aprobación de negocio.
>
> Tres Bolts: F007-B1 retirada backend propia y efecto en consultas; F007-B2 acción sobre detalle F003
> y cuatro representaciones UI; F007-B3 cuatro escenarios, negativos y verificación integrada.
>
> Reutilización: F001-B1/B4 y T-01–T-05; pertenencia/consulta de F003; precondición Pendiente y parte
> común de registro F005-B1/B2. No se copia autorización de responsable de F004/F005/F006 para retirar.
> F004-B2/T-06 solo condicionan la prueba del efecto sobre pendientes, no el permiso del propietario.
>
> Se mantiene T-07 de F005 como única puerta funcional/técnica de concurrencia compartida con F006:
> no Pendiente no pasa a Retirada, sin elegir mecanismo, ganador o mensaje. El cuarto Gherkin,
> revisión en curso, tiene resultado citado pero precondición no definida; queda bloqueado por
> LAB-OQ-006/Q-003/Q-023 hasta aclaración, sin estado En revisión ni flags inventados.
>
> Efecto integrado: tras retirar y releer, F003 muestra Retirada al propietario y F004 excluye esa
> solicitud por su filtro Pendiente, manteniendo otra Pendiente de control. Sin modificar alcance/UI
> F004 ni añadir notificaciones, polling o plazo de propagación.
>
> Negativos: solicitud ajena; responsable no propietario aunque asignado; Aprobada/Rechazada/Retirada.
> Confirmación previa, fallo incierto y contenido siguen abiertos. Sin motivo de retirada, cancelación
> de Aprobadas, reapertura, plazos o notificaciones al responsable; T-08 del rechazo no aplica.
>
> Gates previstos: build/lint, unitarias ≥80 %, mutación ≥60 %, integración, arquitectura y scans
> sin críticos. Un cuarto escenario bloqueado o T-07 pendiente impiden declarar UC-007 completo.
>
> [Plan](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-007-withdraw-pending-vacation-request/planning/plan.md)
> y [registro técnico](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-007-withdraw-pending-vacation-request/planning/research.md).
> Documentos locales, publicación remota pendiente; sin commit/push solicitado.

## 7. Fuentes

- [Plan F007](plan.md), [requisitos](../requirements/requirements.md), [UC-007](../requirements/use-cases/UC-007.md), [cuatro Gherkin](../tests/withdraw-pending-vacation-request.feature) y [mockups](../mockups/README.md).
- [F001: base/registro](../../lab-001-submit-vacation-request/planning/plan.md), [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md), [F003: pertenencia/consulta](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico F003](../../lab-003-view-own-vacation-requests/planning/research.md).
- [F004: filtro Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md), [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md), [F005: regla/registro](../../lab-005-approve-vacation-request/planning/plan.md), [T-07](../../lab-005-approve-vacation-request/planning/research.md) y [modelo de estados](../../lab-005-approve-vacation-request/requirements/state-model.md).
- [F006: reutilización](../../lab-006-reject-vacation-request/planning/plan.md) y [registro técnico](../../lab-006-reject-vacation-request/planning/research.md).
- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md), [clarificaciones](../../clarification-summary.md), [dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).