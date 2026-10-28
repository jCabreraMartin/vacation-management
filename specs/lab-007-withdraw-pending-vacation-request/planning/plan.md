# Plan técnico: LAB-F007: Retirar una solicitud pendiente propia

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal; sin aprobación de negocio ni validación de producción. |
| Escenario | fullstack; ampliación backend y frontend sobre componentes compartidos. Sin aprovisionamiento cloud. |
| Issue | [#5](https://github.com/jCabreraMartin/vacation-management/issues/5) |
| Rama comprobada antes de planificar | `feature/vacation-management-lab-catalog`, según `.git/HEAD`. No se crean ni cambian ramas. |
| Estimación inicial | Tres Bolts propios; complejidad relativa media y condicionada a dependencias/aclaraciones. Sin fechas ni compromisos. |
| Salida de esta entrega | Este documento y [research.md](research.md). Sin código, tareas, contratos ni modelo de datos. |

## 1. Objetivo y alcance

El Empleado retira una solicitud propia mientras siga `Pendiente`. Tras registrar `Retirada`, el
empleado consulta ese estado por F003 y la solicitud deja de aparecer en la consulta de pendientes
del responsable por F004. Trazabilidad: FR-005, FR-002 parcialmente para lectura del resultado,
SEC-001, US-LAB-F007-01, AC-LAB-F007-01/02 y UC-007.

Se amplía el ciclo de estado compartido con el destino fijo `Retirada`. No se recrean foundation,
registro o consultas de F001/F003/F004 ni la precondición Pendiente de F005. La autorización sí es
distinta de aprobar/rechazar: se reutiliza **pertenencia de F003**, no asignación o capacidad de decidir
del responsable de F004/F005/F006. Todos los componentes referenciados son planes o propuestas hasta
que se acredite su implementación; no se presupone código existente por disponer de esos documentos.

### Condiciones backend y negativos

1. La solicitud seleccionada pertenece al empleado que ejecuta la retirada, con contexto obtenido
   por el mecanismo común T-04, no por un propietario editable enviado por el navegador.
2. Continúa exactamente Pendiente en la frontera que registra el cambio. Haberla visto Pendiente
   en la lista o detalle no acredita esa condición al ejecutar la acción.
3. La condición «revisión en curso» requiere aclaración antes de cerrar el flujo completo: véase la
   sección siguiente. Pendiente es condición necesaria, no respuesta a la semántica pendiente de revisión.

Si es ajena o ya no está Pendiente, no se registra la retirada ni cambia su estado. Las pruebas
incluyen cada estado `Aprobada`, `Rechazada` y `Retirada` por separado. Un responsable que intenta
retirar la solicitud de un empleado asignado no obtiene permiso de retirada por tener permiso de
consulta o decisión. El negativo usa un responsable **no propietario** actuando en esa capacidad;
no prohíbe por defecto que una persona con otros roles actúe como Empleado sobre una solicitud
propia, ni decide una política de doble rol que las fuentes no definen.

La referencia de solicitud, una URL manipulada o un botón visible no autorizan la retirada. No se
borra la solicitud para hacerla desaparecer de F004: se registra Retirada y F003 sigue consultándola
como propia. La exclusión de F004 resulta de su filtro existente Pendiente, no de otro estado de
bandeja, notificación o proceso de eliminación.

### Revisión en curso: resultado citado, precondición no operativa

El cuarto Gherkin y UC-007 3d dicen que no se marca Retirada cuando la revisión está en curso, pero
no definen qué significa, cómo detectarla ni su relación con Pendiente. El modelo solo nombra
Pendiente, Aprobada, Rechazada y Retirada. No se añade estado `En revisión`, indicador persistido,
fecha de apertura del detalle, bloqueo o regla «abrir equivale a revisar».

Se conserva el resultado del escenario, pero su preparación y aceptación reproducible quedan
bloqueadas por LAB-OQ-006, Q-003/Q-023 y la parte funcional de **T-07 ya existente en F005**. No se
redefine esa puerta ni se crea otra de concurrencia. Una simulación abstracta de revisión no
demuestra semántica real; tampoco se da por satisfecho el escenario al probar solo estados finales.

### Límites

No se inventan cancelación de Aprobadas, motivo de retirada, ventana/plazo, confirmación previa,
reversión/reapertura, notificaciones al responsable, edición, historial detallado, auditoría de
quién/cuándo, retención, saldo, integraciones o NFR. La confirmación posterior de resultado de UC-007
no implica un diálogo previo. No se implementan aprobaciones/rechazos ni se elige base de datos,
ORM, API/protocolo, IdP, modelo de autorización o mecanismo concurrente.

FR-001/F001 aporta solicitud y pertenencia; FR-006/F002 permanece en presentación, sin revalidar
calendario al retirar. FR-003/F004 se consume solo para comprobar el efecto de filtro existente.
F005/F006 son referencia de regla y garantías compartidas, no permiso de responsable para retirar.
La puerta T-08 del motivo de rechazo de F006 **no aplica** a F007 y no justifica un campo de motivo.

## 2. Dependencias y puertas por referencia

| Fuente única | Aplicación y momento de dependencia |
| --- | --- |
| [F001: base y registro](../../lab-001-submit-vacation-request/planning/plan.md) | F001-B1 para base/herramientas; F001-B4 para solicitud y pertenencia reales. Sin otro Bolt de foundation o registro inicial. |
| [T-01–T-05 de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | T-01 para UI; T-02 para operación/resultado reales de retirar; T-03 para actualización/lectura; T-04 para contexto y propiedad. T-05 solo para fechas de proyección acordada, no para reglas nuevas. |
| [F003: pertenencia y consulta](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | F003-B1 como regla/frontera de pertenencia revisada; F003-B2 para lectura real de Retirada; F003-B3 para acción sobre detalle propio y recorrido UI. No crear consulta de resultado alternativa. |
| [F005-B1: precondición de estado](../../lab-005-approve-vacation-request/planning/plan.md#4-componentes-propuestos-y-reutilización-de-la-transición) | Reutilizar la comprobación Pendiente separada de autorización. Dependencia explícita para el delta backend F007-B1; no copiar la autorización responsable/asignado ni volver a implementar la regla base. |
| [F005-B2: mecanismo de registro compartido](../../lab-005-approve-vacation-request/planning/plan.md#f005-b2-registro-autorizado-e-integración-con-las-consultas) | Consumir su parte común revisada de actualización/confirmación y garantías, separable del permiso de decidir. No llamar a aprobar y luego cambiar Aprobada por Retirada, ni exigir la UI/aceptación completa de F005. |
| [T-07 de F005: concurrencia](../../lab-005-approve-vacation-request/planning/research.md#2-t-07-concurrencia-de-la-aprobación) | Única puerta funcional/técnica compartida con F006. Demostrar su restricción para destino Retirada; aclarar revisión y efecto de acciones competidoras antes de declarar cobertura completa. |
| [F006: reutilización del mecanismo](../../lab-006-reject-vacation-request/planning/plan.md#4-componentes-y-delta-backend-antes-de-ui) | Referencia para mantener outcomes separados y ampliar pruebas comunes sin otro motor. Su flujo UI y T-08 del motivo no son dependencias de retirada. |
| [F004: consulta Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md#4-componentes-y-flujo-propuesto-backend-primero) | F004-B2 es dependencia de la prueba de integración del efecto, no una regla adicional para autorizar retirada. Se reutiliza su filtro sin modificar alcance, campos, estado o UI. |
| [T-06 de F004: dato de asignación](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Solo condiciona acreditar la consulta real del responsable en esa integración. La retirada propia no depende de que el empleado tenga un responsable asignado ni de gestionar asignaciones. |

Dependencias funcionales de la feature: LAB-F001, LAB-F003 y SEC-001. Las referencias a F005 son
reutilización técnica de estado/registro; F004 es dependencia de verificación del efecto. No se exige
cierre de F004-B3/B4 ni navegación de su UI, ni implementación de F006. Si falta un componente común,
entregarlo desde el Bolt de origen; no reconstruirlo dentro de F007.

No se añaden ni renumeran puertas T-xx. Los mensajes y la confirmación previa son aclaraciones de
UC-007; no se inventa una tecnología para responderlas. T-07/T-04 pendientes impiden cerrar garantías
reales; T-06 pendiente impide acreditar el efecto real de F004, no la prueba aislada de pertenencia.

### Comprobación constitucional

Fuente: decisiones aprobadas del [digest](../../../.boltf/memory/constitution.digest.md); ejemplos y
alternativas de plantilla no eligen tecnologías. Se consumen los
[gates comunes de F005](../../lab-005-approve-vacation-request/planning/plan.md#7-quality-gates-comunes-g).

| Restricción vinculante | Aplicación prevista |
| --- | --- |
| C#/.NET 8, Angular sin versión, Podman local | Reutilizar F001-B1/T-01; no seleccionar Angular 20, PrimeNG o arquitectura por una skill. |
| Archivos de configuración y User Secrets local; sin feature flags | Reutilizar configuración, sin secretos en Git ni bypass provisional de propiedad. |
| GitHub Actions, GitHub Flow, GitHub Projects | Reutilizar CI y seguimiento por #5; sin Azure DevOps ni creación de ramas/work items de Bolt. |
| Cobertura unitaria ≥80 %, mutación ≥60 %, build/lint, integración, arquitectura y scans sin críticos | Gates de sección 7. El 70 % de ejemplos genéricos no aplica como umbral aprobado. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en futuro despliegue; sin IaC/hosting elegidos. Trigger `develop` frente a GitHub Flow pendiente para CD. |
| OpenTelemetry hacia Azure, Resource Health y Activity Logs | Reutilizar observabilidad base sin confundir telemetría con auditoría detallada. |
| VNet, Private Endpoints, WAF, claves administradas por Azure y PII cifrada | Restricciones de futuro entorno; clasificación/configuración pendientes antes de datos reales. |
| GDPR/HIPAA seleccionados | No declarar aplicabilidad ni cumplimiento conseguido; LAB-OQ-008 y Q-015/Q-016 abiertas. |

No se detecta una nueva elección contraria a la constitución; no equivale a gates de implementación
superados. Las capas/puertos son propuestas de aprendizaje, no agregado DDD o arquitectura ratificados.
El gate Penpot sigue inactivo en la configuración de referencia (`design-tool: none`); los HTML no
son diseño aprobado.

## 3. Trazabilidad: FR/SEC → AC → UC → Gherkin → pruebas

Historia común: US-LAB-F007-01. Los cuatro escenarios de
[withdraw-pending-vacation-request.feature](../tests/withdraw-pending-vacation-request.feature) no se
modifican. P-01–P-09 son pruebas propuestas locales a F007, no tests creados ni tareas ejecutables.

| FR/SEC | AC | UC / evidencia | Escenario Gherkin actual | Pruebas propuestas / Bolt |
| --- | --- | --- | --- | --- |
| FR-005, SEC-001 | AC-LAB-F007-01 | UC-007 pasos 1–5 | «Retirar una solicitud propia pendiente» (`@smoke`) | **P-01:** propietario retira su Pendiente; registrar Retirada mediante mecanismo común. B1 aislado/real; B3 recorrido desde detalle propio. No introducir confirmación previa. |
| FR-002 parcial, SEC-001 | AC-LAB-F007-01 | UC-007 paso 7 | Parte de consulta del primer escenario | **P-02:** releer lista/detalle por F003 como propietario y ver Retirada; otro empleado no recibe datos. B1 integración y B3 UI; no nueva consulta ni plazo de propagación. |
| FR-005; FR-003 solo efecto de dependencia | AC-LAB-F007-01 | UC-007 paso 6 | Parte de exclusión de pendientes del primer escenario | **P-03:** antes, la Pendiente aparece en consulta F004 del responsable asignado; registrar retirada por propietario y consultar de nuevo: ya no aparece. Otra Pendiente autorizada de control sigue visible. B1/B3 integración del mismo registro, sin cambiar F004. |
| FR-005 | AC-LAB-F007-02 | UC-007 3b/3c y garantía mínima | «No retirar una solicitud aprobada» | **P-04:** Aprobada no pasa a Retirada. Extender según AC-02 a Rechazada y ya Retirada mediante fixtures; sin escritura de retirada ni cambio del estado previo. B1/B3; no decidir idempotencia. |
| SEC-001 | Restricción de AC-01, sin AC negativo separado | UC-007 3a | «Denegar la retirada de una solicitud ajena» (`@security`) | **P-05:** empleado A intenta retirar de B por selección directa/manipulada; denegado sin cambio ni datos ajenos. Variante explícita del encargo: responsable no propietario, aunque tenga asignado al empleado y pueda decidir, tampoco retira. B1/B3. |
| FR-005 | AC-02 relacionada con ciclo de vida, sin resolver revisión | UC-007 3d; LAB-OQ-006/Q-003/Q-023 | «No marcar como retirada una solicitud cuya revisión está en curso» | **P-06:** conservar resultado esperado de no retirada; precondición reproducible bloqueada hasta aclaración funcional de T-07. No sustituir por estado inventado o por Aprobada. B1/B3 solo podrán acreditar este escenario tras aclaración. |
| FR-005 | Garantía de AC-02, sin AC concurrente completo | Cambio de estado durante acción; Q-023/Q-024 | Gap de concurrencia; el cuarto escenario no define intercalados ni ganador | **P-07:** tras leer Pendiente, intercalar en el registro de pruebas un cambio ya establecido a Aprobada/Rechazada/Retirada; el intento no lo sobrescribe con retirada. Aplicar prueba común T-07 al destino Retirada en B1/B3. Sin elegir precedencia de acciones simultáneas. |
| FR-005/FR-002 parcial | AC-01 parcial | UC-007 4a y confirmación; Q-022/Q-024 | Gap de fallo/actualización, sin escenario de resultado cerrado | **P-08:** no afirmar éxito sin registro confirmado ni afirmar que nada se guardó con resultado incierto; observar registro y consultas por separado. B2 controlado, B1/B3 reales cuando se definan resultados. |
| FR-005 | AC-01; sin AC visual adicional | UC-007 y cuatro HTML | Representación del primer escenario, no escenarios adicionales | **P-09:** default/loading/error/success en B2 y recorrido real B3; sin modal previo, motivo o notificación añadidos. Contenido pendiente no es criterio aceptado. |

Los tres primeros escenarios y negativos de estados tienen condiciones conocidas. El cuarto tiene
resultado expresado pero precondición no operativa: debe figurar **bloqueado**, no pasado, omitido o
equivalente a un test de no Pendiente. Si se usa una condición abstracta en pruebas preliminares, no
acredita significado de revisión ni cobertura integrada. No se declara UC-007 completo con ese gap.

## 4. Componentes propuestos: transición y propiedad antes de UI

Rutas propuestas, no código ni archivos generados. No se impone repositorio, dispatcher, agregado,
Unit of Work o una máquina de estados genérica. Se amplían las áreas compartidas acordadas.

| Área | Ruta propuesta / referencia | Responsabilidad específica |
| --- | --- | --- |
| Regla de estado | `src/backend/VacationManagement.Domain/VacationRequests/`, según F005 | Reutilizar precondición Pendiente y añadir destino fijo Retirada. No implementar aprobación/rechazo de nuevo ni salidas desde estados finales. |
| Caso de uso de retirada | `src/backend/VacationManagement.Application/VacationRequests/Withdraw/` | Consumir contexto y pertenencia de F003, regla de estado y registro común. No usar ámbito del responsable como autorización de retirada. |
| Registro/entrada comunes | `src/backend/VacationManagement.Infrastructure/VacationRequests/` y `src/backend/VacationManagement.Api/` | Ampliación de operación lógica de retirar sobre el mismo registro, según T-02/T-03/T-04/T-07 acordadas. Sin motor, ORM, endpoint, verbo, DTO o código elegidos. |
| Acción en detalle propio Angular | `src/frontend/src/app/vacation-requests/own-requests/` | Añadir retirar al detalle F003, sin nueva lista ni acción en bandeja del responsable. Reutilizar patrón de acción de F005/F006 si existe y encaja, no sus permisos. |
| Frontera frontend | `src/frontend/src/app/vacation-requests/data-access/` | Ampliar operación específica de retirada; no actor/propietario arbitrario como prueba de permiso, ni estado de destino editable. |
| Consultas existentes | ReadOwn de F003 y ReadAssignedPending de F004 | Releer Retirada como propia y excluirla de Pendiente; sin nuevos endpoints de resultado, filtros configurables o modificaciones funcionales de F004. |
| Pruebas compartidas | `tests/VacationManagement.UnitTests/`, `tests/VacationManagement.IntegrationTests/`, `tests/Architecture.Tests/`, `src/frontend/e2e/` | Reutilizar suites/fixtures de actor/estado/registro. Integración de consultas real; no otro entorno o endpoint para preparar estados. |

### Flujo lógico

1. El empleado selecciona su solicitud mediante F003 y solicita retirar; no se añade diálogo previo
   mientras UC-007 no concrete esa pregunta.
2. Backend obtiene contexto T-04 y verifica pertenencia de nuevo. La propiedad previa en pantalla y
   permisos de responsable no sustituyen esa comprobación por operación.
3. La regla común admite cambio solo desde Pendiente en la frontera que registra, bajo la garantía
   que concrete T-07. La detección de revisión en curso no se codifica sin aclarar su significado.
4. Registrar Retirada sin borrar la solicitud. Confirmar al empleado solo con registro confirmado;
   ante resultado incierto, no dar por hecho éxito ni ausencia de escritura.
5. Releer por F003 el estado Retirada. En consulta posterior de F004, el filtro existente Pendiente
   la excluye naturalmente. No añadir mensajes al responsable o mecanismos de sincronización.

No se elige bloqueo optimista/pesimista, versionado, idempotencia, transacción, reintento, rollback,
compensación o ganador entre retirar y decidir. La garantía mínima conocida no permite que una
solicitud no Pendiente pase a Retirada; su prueba real se reutiliza desde T-07 para este outcome.

## 5. Cuatro mockups y soporte incompleto

Revisados el [README](../mockups/README.md), el [CHANGELOG](../mockups/CHANGELOG.md) y los cuatro HTML.
Son referencias low-fi, no diseño aprobado. El CDN Tailwind no selecciona estilos para Angular;
campos ilustrativos y `TODO(content)` no son contrato funcional ni textos finales.

| Mockup | Bolt y responsabilidad | Límite / estado sin soporte |
| --- | --- | --- |
| [Default](../mockups/withdraw-request-action-default.html) | F007-B2: acción sobre detalle propio F003; regla B1 y recorrido B3 | Solicitud propia Pendiente, fechas/comentario ilustrativos. Sin diálogo previo; su ausencia no responde a la pregunta de confirmación de UC-007. |
| [Loading](../mockups/withdraw-request-action-loading.html) | F007-B2; verificación real B3 | Estado de UI, no «retirada en curso» como estado persistido ni prueba de bloqueo/reintento o exclusión de decisiones competidoras. Texto/comportamiento sin cerrar. |
| [Error](../mockups/withdraw-request-action-error.html) | F007-B2 para representación; negativos B1/B3 | Ajena/no Pendiente no tienen diferenciación visible definida. No cubre revisión, conflicto o registro incierto. «No se ha completado» no prueba que no se guardó un cambio sin confirmación. |
| [Success](../mockups/withdraw-request-action-success.html) | F007-B2; registro/consultas B1 y B3 | Retirada solo tras registro confirmado. Texto/canal pendiente; no acredita por sí solo consulta F003 ni exclusión F004. |

Sin soporte cerrado: confirmación previa, revisión en curso, conflicto retirar/decidir, respuesta al
responsable no propietario, fallo con resultado incierto y recuperación, y frescura de consultas.
No se colapsan esas situaciones por tener un único error. No se crean pantallas, motivo, opciones
de recuperación, temporizadores o notificaciones para resolverlas. Empty corresponde a las listas
de F003/F004, no a esta acción sobre detalle.

## 6. Tres Bolts revisables

Secuencia principal F007-B1 → F007-B2 → F007-B3. Backend reutilizado y probado antes de UI. B1 puede
revisar su delta aislado con componentes comunes ya revisados; B2 puede revisar representaciones
con dobles después de ese backend, sin declarar integración terminada. Los bloqueos de T-07/revisión
impiden cierre completo, no se sortean con flags, actores fake o pruebas de estados finales.

### F007-B1: retirada backend propia y efecto en consultas

- **Objetivo:** ampliar el estado compartido a Retirada, autorizando únicamente por pertenencia de F003,
  y comprobar persistencia/lectura/exclusión sin nuevas consultas ni reglas de F004.
- **Dependencias:** base F001-B1, regla de pertenencia F003-B1 y guard de estado F005-B1 revisados.
  Para cierre real: F001-B4, F003-B2, mecanismo común de registro de F005-B2 y T-02/T-03/T-04/T-07
  concretadas. Para P-03: F004-B2/T-06 reales, exclusivamente como dependencia de prueba del efecto.
  Revisión en curso aclarada para cubrir todo UC-007; no se exige UI F004 ni autorización por asignación para retirar.
- **Componentes/rutas propuestas:** Domain/VacationRequests compartido, Application/VacationRequests/Withdraw,
  entrada y adaptación comunes de sección 4. ReadOwn y ReadAssignedPending se consumen sin ampliar alcance.
- **Entregables:** operación lógica propia Pendiente → Retirada, no escritura si ajena/no Pendiente,
  y prueba integrada del mismo registro en F003/F004. No borrado, notificación o nueva gestión de asignaciones.
- **Pruebas:** P-01–P-05 y P-07, primero aisladas y luego reales. Negativos por propiedad, responsable
  no propietario y cada estado final. P-03 consulta F004 antes/después, conservando una Pendiente de
  control; P-02 propietario ve Retirada. P-06 solo tras definición de revisión, no estado inventado.
- **Documentación:** delta y referencias compartidas, evidencia aislada/real, separación entre permiso
  de retirar y de decidir; estado de T-07 y bloqueo del cuarto Gherkin, sin modificar fuentes.
- **Criterio de salida:** retirada autorizada y consultas reales verificadas, no sobrescritura de
  estados finales. Si falta propiedad/registro/T-07 o aclaración de revisión, solo revisión parcial;
  si falta F004/T-06, su efecto permanece pendiente y no se declara AC-01 completa.
- **Quality gates:** G, sección 7: build/lint, unitarias ≥80 %, mutación ≥60 %, integración real,
  arquitectura y scans sin críticos aplicables. Gates bloqueados no se pasan con dobles.
- **Estimación orientativa:** complejidad media del delta; incertidumbre alta en aclaraciones, sin duración comprometida.

### F007-B2: acción de retirar desde el detalle propio

- **Objetivo:** añadir retirar a la UI propia de F003, reutilizando componentes/patrones adecuados,
  sin copiar permiso de responsable ni generar una pantalla independiente de solicitudes.
- **Dependencias:** delta backend B1 probado, F001-B1 frontend/T-01 y UI/frontera F003-B3 reutilizables.
  Conexión operativa requiere B1 real y aclaraciones aplicables; con dobles solo revisión de presentación.
  No depende de completar UI F005/F006/F004.
- **Componentes/rutas propuestas:** `src/frontend/src/app/vacation-requests/own-requests/` y
  `src/frontend/src/app/vacation-requests/data-access/`, sin acción de retirada en la bandeja del responsable.
- **Entregables:** [default](../mockups/withdraw-request-action-default.html),
  [loading](../mockups/withdraw-request-action-loading.html), [error](../mockups/withdraw-request-action-error.html)
  y [success](../mockups/withdraw-request-action-success.html); sin confirmación previa, motivo, plazo,
  reversión, cancelación de Aprobadas o notificación añadidos por inferencia.
- **Pruebas:** P-08/P-09 con respuestas controladas, éxito solo confirmado y denegación sin datos ajenos
  residuales. Layout móvil/escritorio, teclado/foco y jerarquía sin nivel WCAG inventado. Ocultar un
  control no prueba SEC-001 ni previene concurrencia; verificar negativos en backend.
- **Documentación:** mapping HTML/componente y TODO(content), gaps de revisión/conflicto/confirmación
  previa, diferencia entre resultado confirmado e incierto. No convertir placeholders en copy aceptado.
- **Criterio de salida:** cuatro referencias revisadas con límites visibles; success expresa registro
  confirmado, no una suposición. Sin contenido/reglas aclarados o B1 real, salida parcial de UI, no
  aceptación integrada ni cierre de la pregunta de confirmación previa.
- **Quality gates:** G frontend: build/lint, unitarias ≥80 %, mutación ≥60 %, componentes/arquitectura
  aplicables y scans sin críticos. E2E con dobles no sustituye B3.
- **Estimación orientativa:** complejidad media, condicionada a contenido y aclaraciones.

### F007-B3: cuatro escenarios y efectos integrados

- **Objetivo:** demostrar retirada propia, denegaciones y efectos F003/F004 con trazabilidad de los
  cuatro Gherkin, distinguiendo escenarios ejecutados de bloqueados por falta de definición.
- **Dependencias:** B1/B2 reales, F003-B3 para recorrido UI; F004-B2/T-06 para consulta de integración,
  no F004-B3/B4 como prerrequisito. T-04/T-07 y puertas heredadas aplicables concretadas, revisión
  en curso aclarada para cerrar el cuarto escenario. No implementar F005/F006 solo para fixtures.
- **Componentes/rutas propuestas:** suites comunes de integración/arquitectura y `src/frontend/e2e/`.
  Sin nuevo entorno, modelo de asignación, UI del responsable o endpoints para preparar estados.
- **Entregables:** cuatro escenarios trazados a evidencia, matriz de resultados y gates, negativos
  adicionales de responsable/Rechazada/Retirada y prueba de efecto F004 sin cambio de su alcance.
- **Pruebas:** P-01–P-05 reales: presentar por F001, seleccionar propia y retirar, releer Retirada por
  F003; consultar backend F004 antes/después del mismo registro. Intento ajeno, responsable no
  propietario y tres estados finales no cambian datos. P-07 con intercalados definidos por la garantía
  común. P-06 se mantiene bloqueado hasta aclarar revisión; P-08/P-09 no pasan por placeholders.
- **Documentación:** comandos realmente ejecutados, resultados por AC/escenario, evidencia de
  consultas y gaps. Revisión personal, sin sign-off de negocio o cumplimiento regulatorio ficticios.
- **Criterio de salida:** AC-01/02, los cuatro escenarios y negativos verificables pasan con datos
  reales y gates satisfechos. Si revisión/T-07 o respuestas necesarias siguen abiertas, no declarar
  UC-007 completo ni sustituir el cuarto escenario por otro de estado no Pendiente.
- **Quality gates:** G íntegro: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración/E2E,
  arquitectura y scans sin críticos; alcance y bloqueos documentados.
- **Estimación orientativa:** complejidad media/alta por dependencias y aclaración, no por una tecnología elegida.

## 7. Quality gates comunes (G)

Se reutilizan los [gates de F005](../../lab-005-approve-vacation-request/planning/plan.md#7-quality-gates-comunes-g),
sin duplicar CI, configuración de herramientas o pipelines. Por Bolt: build/lint, cobertura unitaria
≥80 %, mutación ≥60 %, integración y arquitectura aplicables, scans de seguridad/dependencias sin
críticos y construcción/escaneo de contenedor sin críticos al existir imagen. Medir alcance de
aplicación acordado, sin rebajar umbrales por ser laboratorio.

- Negativos mínimos en la entrada real: solicitud ajena, responsable no propietario aunque asignado,
  Aprobada, Rechazada y ya Retirada. Verificar estado/registro y no exposición de datos, no solo botones.
- No regresión: F003 mantiene lectura propia de los cuatro estados; F004 mantiene solo Pendiente
  asignadas; decisiones de F005/F006 no adquieren permiso de retirada ni cambian sus outcomes.
- Integración P-03 sobre el mismo registro antes/después: retirarla excluye solo esa solicitud de
  Pendiente, no vacía la bandeja ni borra la solicitud. Sin plazo/polling/notificación inventados.
- T-07 necesita evidencia real para el destino Retirada; pruebas secuenciales o condición simulada
  de revisión no cierran concurrencia ni el cuarto Gherkin.
- Reutilizar ejecución Podman/GitHub Actions. Gate no disponible: bloqueo o no aplicabilidad
  justificada, nunca «pasado». Revisión de UI con dobles se identifica como aislada.
- Consumir OpenTelemetry hacia Azure sin contenido personal en telemetría. No añadir historial
  detallado, retención, alarmas, objetivos operativos o declaración de cumplimiento GDPR/HIPAA.

Son gates de futura implementación; generar estos documentos no ejecuta tests de aplicación ni
acredita calidad de código, cierre de puertas o aceptación de negocio.

## 8. Preguntas abiertas y riesgos

| Fuente | Cuestión sin resolver | Tratamiento sin ampliar alcance |
| --- | --- | --- |
| LAB-OQ-006; Q-003/Q-023; UC-007 3d | Significado y detección de revisión en curso respecto a Pendiente | Aclaración funcional en T-07 heredada. Cuarto escenario bloqueado; sin estado/flag/fecha/bloqueo inventado ni descarte del resultado citado. |
| LAB-OQ-006; Q-004/Q-023/Q-024 | Retirada durante decisión, efectividad y acciones competidoras | T-07 compartida. Solo restricción no Pendiente → no Retirada; sin precedencia, ganador, versión, bloqueo, idempotencia o mensaje elegidos. |
| LAB-OQ-006; UC-007 preguntas abiertas | Confirmación previa, cancelación de Aprobadas y reversión | No añadir diálogo, cancelación, reapertura o deshacer. El mockup y la confirmación posterior no responden a la pregunta previa. |
| LAB-OQ-008; Q-013/Q-014/Q-015/Q-016 | Contexto/propiedad, privacidad, evidencia de quién/cuándo, auditoría y retención | T-04 y datos comunes; no copiar autorización por asignación ni añadir historial/campos de retirada. |
| Q-022/Q-024; UC-007 4a | Registro incierto y disponibilidad de estado/exclusión posterior | No afirmar éxito o fallo definitivo sin evidencia, ni prometer frescura inmediata, retry o compensación. |
| Q-005/Q-012/Q-021/Q-024 | Proyección de detalle y respuestas de consulta/denegación/error | Reutilizar límites de F003/F004, sin nuevos campos o mensajes ni equivalencia implícita de causas. |
| Q-019/Q-025 | NFR y evidencia/autoridad de aceptación | Sin targets, plazos o sign-off ficticio; Draft se conserva aunque pasen pruebas técnicas. |
| F004/T-06 real no disponible | Efecto de exclusión no acreditable con responsable/asignación reales | Prueba del núcleo de retirada no exige asignación; el efecto requerido de AC-01 queda pendiente, no se da por probado con una lista fake. |
| Confundir reutilización con permiso | Retirada por responsable o por ámbito asignado | Consumir guard de F005, propiedad de F003 y pruebas negativas por operación. No llamar a casos de decisión para autorizar retirada. |

## 9. Fuentes y comentario de seguimiento

- [Constitución: digest](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md) y [clarificaciones](../../clarification-summary.md).
- [Requisitos F007](../requirements/requirements.md), [UC-007](../requirements/use-cases/UC-007.md), [cuatro Gherkin](../tests/withdraw-pending-vacation-request.feature), [mockups](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md).
- [Dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md), [modelo de estados](../../lab-005-approve-vacation-request/requirements/state-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).
- [F001: base y registro](../../lab-001-submit-vacation-request/planning/plan.md) y [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: pertenencia/consulta](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [F004: filtro Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md).
- [F005: regla/registro](../../lab-005-approve-vacation-request/planning/plan.md), [T-07](../../lab-005-approve-vacation-request/planning/research.md), [F006: simetría y reutilización](../../lab-006-reject-vacation-request/planning/plan.md) y [registro técnico F006](../../lab-006-reject-vacation-request/planning/research.md).

El comentario solicitado para #5 figura preparado en [research.md](research.md#6-comentario-preparado-para-el-issue-5),
no publicado: las herramientas disponibles en esta sesión no incluyen escritura en GitHub. No se
modifica cuerpo/estado del issue ni se crea otro work item. Sus enlaces remotos son previstos hasta
publicar archivos; no se solicita commit/push. No se continúa automáticamente con código, tasks,
OpenAPI, data-model, nuevos Gherkin o Azure DevOps.