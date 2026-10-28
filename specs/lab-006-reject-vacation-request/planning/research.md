# Registro técnico: LAB-F006: Rechazar una solicitud de vacaciones

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal, no aprobado para el producto. |
| Issue | [#7](https://github.com/jCabreraMartin/vacation-management/issues/7) |
| Plan | [plan.md](plan.md) |
| Evidencia de esta entrega | Revisión de fuentes locales; sin investigación externa, experimento de código o elección tecnológica. |

## 1. Reutilización y delta de rechazo

El delta frente a F005 es el destino `Rechazada`, su acción de UI y las pruebas específicas. No se
reimplementan la precondición Pendiente, autorización de decisión, acceso por asignación, registro
común o comprobación de concurrencia. F006 requiere esos componentes implementados/revisados en
sus Bolts de origen; tener su plan no acredita que existan.

| Fuente única | Consumo en F006 |
| --- | --- |
| [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | Base y registro/pertenencia reales; entrada, almacenamiento, identidad y representación comunes. No repetir foundation ni elegir tecnologías. |
| [F003: consulta de estado](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | Mostrar Rechazada al propietario por el mismo registro y las mismas consultas. Mantener aislamiento y cuatro estados; no añadir motivo a su proyección por inferencia. |
| [F004: regla conjunta](../../lab-004-view-assigned-pending-requests/planning/plan.md#1-objetivo-y-alcance-trazado) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Reutilizar ámbito del responsable; capacidad de decidir verificada por F005, no derivada solo de leer la bandeja. Origen/cardinalidad/mantenimiento de asignación siguen pendientes. |
| [F005-B1/B2](../../lab-005-approve-vacation-request/planning/plan.md#6-bolts-revisables-por-separado) | B1 aporta regla y autorización revisadas; B2 el mecanismo común real de registro y lectura. Son dependencias explícitas del delta de F006, no nuevos Bolts duplicados. UI/aceptación completa F005 no son prerrequisitos. |
| [T-07 de F005](../../lab-005-approve-vacation-request/planning/research.md#2-t-07-concurrencia-de-la-aprobación) | Puerta funcional/técnica de concurrencia, pendiente. Aplicar su garantía acordada al destino Rechazada y probar ese caso; no redefinir T-07 ni abrir otra puerta equivalente. |

T-01–T-07 no se renumeran, copian o cierran por esta entrega. Solo se añade T-08, a continuación.
La precondición de estado compartida es compatible con F007, pero su permiso de propietario no se
usa para rechazar. No se entrega retirada ni otra transición para preparar datos de prueba.

## 2. T-08: motivo o comentario de rechazo

**Estado:** pendiente funcional; bloquea aceptación operativa y cierre completo de F006. Solo tras
aclaración se concretará el impacto técnico en el mecanismo compartido. No es una tecnología
seleccionada ni una investigación externa ya ejecutada.

**Evidencia:** LAB-OQ-007 y Q-011; requisitos F006 y UC-006 extensión 2a, que no determinan si se
permite, requiere o persiste un comentario. Visibilidad para el empleado no definida; Q-014/Q-015/Q-016
mantienen abiertas propiedad, conservación y evidencia de decisión. Ninguno de los cuatro mockups
incluye un campo de motivo. Ningún escenario Gherkin define su resultado.

### Aclaración funcional necesaria

¿Se captura motivo/comentario al rechazar? Si se captura, ¿es obligatorio, qué contenido y longitud
admite, se registra, quién puede verlo y debe aparecer para el empleado? ¿Qué evidencia basta para
aceptar ese comportamiento dentro del laboratorio? No se responde aquí ninguna de esas preguntas.

No se elige un catálogo de motivos, texto libre, límites mínimo/máximo, normalización, campo opcional,
validación obligatoria, mensaje, visibilidad o conservación. El comentario opcional de la solicitud
de FR-001 es distinto y no resuelve las reglas del comentario de decisión. AC-LAB-F006-02 exige
consulta del estado, no del motivo.

### Límite del avance mientras siga abierta

Puede comprobarse el delta lógico Pendiente → Rechazada y sus negativos con datos controlados,
reutilizando F005; también revisar las representaciones actuales de UI tras el backend. No añadir
campo por precaución, ni interpretar su ausencia como decisión de permitir rechazo sin motivo.
La evidencia aislada no convierte un flujo sin aclaración en una entrega operativa aceptada.

Si la respuesta exige captura o exposición de motivo, revisar requisitos/UC/Gherkin/mockups y el
plan con trazabilidad antes de implementarlo. Esos cambios no están autorizados en esta entrega de
dos documentos. La respuesta tampoco autoriza automáticamente historial detallado, nuevos datos
personales, retención o política de auditoría.

### Concreción técnica posterior y criterio de desbloqueo

1. Respuesta funcional explícita del autor del ejercicio sobre captura, obligatoriedad y, si aplica,
   contenido/longitud, registro y visibilidad necesaria para este alcance. Mantener las demás preguntas abiertas.
2. Si implica cambios, artefactos afectados revisados y casos observables definidos; no afirmar que
   los cuatro HTML y Gherkin actuales cubren reglas de motivo que todavía no existen.
3. Evaluar solo la ampliación necesaria sobre T-02/T-03/T-04 y las fronteras comunes aceptadas:
   entrada, registro y acceso a los datos que se acuerden. Sin elegir otro almacén, ORM o modelo de autorización.
4. Definir pruebas de aceptación derivadas de la respuesta, sin usar placeholders como contrato.
   Si se decide no incluir captura en este alcance, registrar esa decisión explícita, no deducirla del mockup.

Mientras falte esa evidencia, T-08 sigue pendiente. No se ha realizado experimento, añadido catálogo,
elegido paquete o cerrado la política. No se abren investigaciones técnicas para decidir una regla
que corresponde aclarar al autor del laboratorio.

## 3. Preguntas abiertas heredadas

| Fuente | Cuestión sin resolver | Tratamiento |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-013/Q-014 | Asignación, fuente de verdad y autoridad de decisión | T-04/T-06 compartidas; sin administrar asignaciones, elegir IdP o fijar modelo de autorización. |
| LAB-OQ-006; Q-003/Q-004/Q-023/Q-024 | Reapertura, reversión, en revisión y concurrencia | T-07 de F005. Solo rechazo desde Pendiente; no fijar otras transiciones, ganador o respuesta exacta. |
| LAB-OQ-007; Q-011 | Motivo/comentario, longitud, obligatoriedad y visibilidad | T-08, sin respuesta inventada ni catálogo. |
| LAB-OQ-008; Q-013/Q-015/Q-016 | Identidad, privacidad, evidencia de quién/cuándo, auditoría y retención | Registrar estado no equivale a historial detallado; sin campos nuevos ni cumplimiento declarado. |
| Q-004/Q-014/Q-022/Q-024; UC-006 4a/6a | Registro efectivo, resultado incierto y consulta actualizada | Reutilizar garantías acordadas; no afirmar éxito o fallo definitivo sin evidencia, ni prometer frescura inmediata. |
| Q-005/Q-011/Q-021/Q-024 | Proyección de detalle, contenido de confirmación/error | Provisionales; no equiparar inexistente, no autorizado, no Pendiente, conflicto y fallo técnico por disponer de un único HTML error. |
| Q-019/Q-022/Q-025 | NFR y evidencia/autoridad de aceptación | Sin plazo de propagación, SLO, nivel WCAG ni sign-off ficticios. |

No se investiga saldo LAB-OQ-005, calendario, notificaciones o integraciones no evidenciadas para
completar el rechazo. LAB-OQ permanece abierta donde no haya respuesta; no se cambian fuentes.

## 4. Concurrencia y mockups: aplicar lo compartido, no inferir resultados

La regla conocida exige que una solicitud que ya no esté Pendiente no pase a Rechazada por el
intento de rechazo. Reutilizar T-07 de F005 también significa demostrar esa restricción en la frontera
real de registro, incluso si el estado cambia después de la lectura inicial. No basta un `if` sobre
un valor obsoleto o una prueba secuencial. No se elige bloqueo optimista/pesimista, versión,
idempotencia, transacción, retry, rollback, compensación, mensajes o ganador concurrente.

Los [cuatro mockups](../mockups/README.md), con revisión del [CHANGELOG](../mockups/CHANGELOG.md),
se asignan a F006-B2 en el [plan](plan.md#5-mockups-y-estados-sin-soporte). Default no contiene
decisión sobre motivo; loading no demuestra exclusión concurrente; error no define resolución de
conflicto ni resultado incierto. Su rótulo de no registro no justifica afirmar que no se guardó un
cambio cuando no hay confirmación. Success exige Rechazada confirmada, y no demuestra por sí solo
la lectura del empleado ni visibilidad de motivo.

No hay soporte cerrado para campo/errores de motivo, asignación ambigua, concurrencia frente a
denegación, recuperación del registro incierto o retraso de consulta. No se crean más mockups ni se
convierten TODO(content) en textos aprobados para ocultar estos gaps.

## 5. Avance permitido y gates pendientes

- **F006-B1:** delta backend sobre F005-B1 revisado, no repetición del guard/autorización. La prueba
  aislada es posible; cierre real exige mecanismo F005-B2, registro F001, consultas F003/F004 y
  puertas heredadas pertinentes, además de T-08 aclarada para aceptar el flujo operativo.
- **F006-B2:** cuatro representaciones después del delta backend; presentación aislada con dobles
  no permite declarar cierre real, motivo opcional o respuesta definitiva a errores no especificados.
- **F006-B3:** cuatro escenarios integrados y negativos específicos usando infraestructura común,
  sin otro Bolt para recrearla. No depende de completar toda F005 ni entregar F007, pero sí de sus
  componentes compartidos realmente consumidos y T-07 demostrada para rechazo.
- Negativos mínimos: responsable no asignado; propietario solo Empleado; Aprobada/Rechazada/Retirada;
  inexistencia sin decisión. Verificar estado/registro y no exposición de datos, no solo controles visuales.
- Gates futuros: build/lint, unitarias ≥80 %, mutación ≥60 %, integración, arquitectura y scans sin
  críticos; imagen cuando exista. Se reutilizan gates de F005. Si falta un gate o una garantía, se
  registra bloqueo/no aplicabilidad justificada, nunca se declara pasado con dobles o porcentajes globales.

No se han ejecutado tests de aplicación ni investigación externa en esta entrega documental. No se
crea código, tasks, OpenAPI, data-model, ramas o nuevos work items; no se usa Azure DevOps.

## 6. Comentario preparado para el issue #7

**Estado de publicación:** preparado, no enviado. Las herramientas de la sesión no incluyen escritura
en GitHub. Los enlaces remotos son previstos hasta publicar los archivos; no se solicita commit/push.

> Plan técnico LAB-F006 preparado en Draft / LAB-HYP, sin código ni aprobación de negocio.
>
> Tres Bolts específicos: F006-B1 ampliar el backend compartido para Pendiente → Rechazada;
> F006-B2 acción de rechazo y cuatro representaciones UI; F006-B3 cuatro escenarios Gherkin y
> negativos integrados desde F004 hasta consulta del estado por F003.
>
> Se reutilizan F001-B1/B4, T-01–T-05, consulta F003, ámbito de F004/T-06 y, especialmente,
> regla/autorización F005-B1 y mecanismo real F005-B2. Si esos componentes no existen, son dependencia
> de origen, no nuevos Bolts duplicados en F006. No requiere terminar toda la UI/aceptación de F005.
>
> T-07 de concurrencia sigue definida en F005 y pendiente; demostrar también su garantía para rechazo,
> sin elegir bloqueo, versión, idempotencia, ganador o mensajes. Una solicitud no Pendiente no cambia
> a Rechazada por este intento.
>
> Nueva T-08 pendiente: motivo/comentario de rechazo, LAB-OQ-007/Q-011; captura, obligatoriedad,
> longitud, registro y visibilidad al empleado sin definir. No hay campo en mockups y eso no demuestra
> opcionalidad. Bloquea aceptación operativa; no se añade campo/catálogo/validación ni motivo visible.
>
> Negativos: responsable no asignado, propietario solo Empleado y Aprobada/Rechazada/Retirada;
> inexistente sin decisión. Rechazada se lee por F003 sin nuevo listado ni plazo inventado. Error
> genérico no resuelve conflicto concurrente, falta de autorización o resultado de registro incierto.
>
> Gates previstos: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración, arquitectura
> y scans sin críticos. No se inventan políticas de reversión/reapertura, notificaciones, auditoría o NFR.
>
> [Plan](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-006-reject-vacation-request/planning/plan.md)
> y [registro técnico](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-006-reject-vacation-request/planning/research.md).
> Documentos locales, publicación remota pendiente; sin commit/push solicitado.

## 7. Fuentes

- [Plan F006](plan.md), [requisitos](../requirements/requirements.md), [UC-006](../requirements/use-cases/UC-006.md), [cuatro Gherkin](../tests/reject-vacation-request.feature) y [mockups](../mockups/README.md).
- [F005: regla y mecanismo compartidos](../../lab-005-approve-vacation-request/planning/plan.md), [T-07](../../lab-005-approve-vacation-request/planning/research.md) y [modelo de estados](../../lab-005-approve-vacation-request/requirements/state-model.md).
- [F001: base/registro](../../lab-001-submit-vacation-request/planning/plan.md), [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md), [F003: consulta](../../lab-003-view-own-vacation-requests/planning/plan.md), [F004: ámbito](../../lab-004-view-assigned-pending-requests/planning/plan.md) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md).
- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md), [clarificaciones](../../clarification-summary.md), [dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).