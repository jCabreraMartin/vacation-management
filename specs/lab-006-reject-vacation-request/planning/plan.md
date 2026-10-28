# Plan técnico: LAB-F006: Rechazar una solicitud de vacaciones

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal; sin aprobación de negocio ni validación de producción. |
| Escenario | fullstack; ampliación backend y frontend sobre la base compartida. Sin aprovisionamiento cloud. |
| Issue | [#7](https://github.com/jCabreraMartin/vacation-management/issues/7) |
| Rama comprobada antes de planificar | `feature/vacation-management-lab-catalog`, según `.git/HEAD`. No se crean ni cambian ramas. |
| Estimación inicial | Tres Bolts específicos del rechazo, de complejidad relativa media y condicionada a dependencias. Sin fechas ni compromisos. |
| Salida de esta entrega | Este documento y [research.md](research.md). Sin código, tareas, contratos ni modelo de datos. |

## 1. Objetivo y alcance específico

Un Responsable aprobador autorizado rechaza una solicitud existente que continúa `Pendiente` de un
empleado asignado. El sistema registra `Rechazada` y el empleado consulta ese estado mediante F003.
Trazabilidad propia: FR-004, únicamente rechazo; SEC-001; US-LAB-F006-01; AC-LAB-F006-01/02 y UC-006.

Rechazar es simétrico a aprobar en sus condiciones conocidas. F006 no reconstruye las reglas,
autorización, registro ni garantías de concurrencia de F005. El delta es el outcome fijo
`Pendiente → Rechazada`, su acción de UI y la comprobación específica de ese resultado. No se convierte
la simetría en un campo de destino libre elegido por el navegador ni en un CRUD genérico de estados.

Se reutilizan desde F005 la comprobación de existencia, la capacidad de decidir, el ámbito asignado y
la precondición Pendiente. Deben verificarse al ejecutar el rechazo, no solo al abrir el detalle F004.
Si falta autorización/asignación o la solicitud ya no está Pendiente, no se registra el rechazo y se
conserva su estado. Si no existe, no se registra una decisión. Se comprueban por separado `Aprobada`,
`Rechazada` y `Retirada`, sin implementar las otras transiciones para preparar esas pruebas.

El propietario actuando solo como Empleado no puede rechazar su propia solicitud. La consulta propia
de F003 no otorga capacidad de decisión. Este negativo no define una política nueva para identidades
con doble rol, autoasignaciones o delegaciones: esas situaciones siguen abiertas.

### Motivo: gap explícito, no campo por defecto

LAB-OQ-007, Q-011 y UC-006 extensión 2a no determinan si se permite, requiere o persiste un motivo,
su longitud, contenido ni si lo ve el empleado. La ausencia de campo en los mockups no demuestra que
sea opcional, esté prohibido o pueda omitirse en un flujo operativo aceptado. La nueva **T-08** de
[research.md](research.md#2-t-08-motivo-o-comentario-de-rechazo) conserva esa pregunta como puerta.

Puede revisarse la transición aislada y la presentación provisional, pero no cerrar F006 ni aceptar
el flujo operativo sin aclarar T-08 para el alcance. Si la respuesta exige capturar motivo, revisar
el plan y los artefactos afectados antes de construirlo; no se genera aquí campo, catálogo, validación,
esquema, formulario ni texto alternativo por anticipado. La consulta de F003 exigida por AC-02 muestra
el estado Rechazada, no supone visibilidad del motivo.

### Fuera de alcance

No se añaden políticas de reversión/reapertura, notificaciones, edición, historial detallado de
decisiones, evidencia de quién/cuándo, retención, saldo, integraciones o NFR. LAB-OQ-005 permanece
abierta y fuera del alcance. No se modela `En revisión` como estado. No se elige base de datos, ORM,
API/protocolo, IdP, modelo de autorización, CQRS o mecanismo de concurrencia.

FR-001/F001 proporciona la solicitud Pendiente; FR-006/F002 sigue consumida en su presentación, no se
revalida calendario al rechazar. FR-002/F003 y FR-003/F004 son dependencias de consulta, no listados
nuevos. FR-004 aprobación/F005 aporta la regla compartida; FR-005/UC-007 solo informa de una posible
retirada competidora y de compatibilidad de estado. No se implementa retirada ni se reutiliza su
autorización de propietario para decidir como responsable.

## 2. Dependencias y puertas por referencia

Los planes de origen son referencias de trabajo, no evidencia de código ya implementado. Sus
definiciones no se copian ni se resuelven aquí. F006 necesita la regla de F005 existente y revisada;
si falta, su entrega debe realizarse en el Bolt de origen, no duplicarse en F006.

| Referencia única | Uso y momento de dependencia |
| --- | --- |
| [F001: base y registro](../../lab-001-submit-vacation-request/planning/plan.md) | F001-B1 para base/herramientas y F001-B4 para solicitud/pertenencia reales. No otro Bolt de foundation o registro. |
| [T-01–T-05 de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | T-01 para UI; T-02 para operación de rechazo y su resultado; T-03 para actualización/lectura; T-04 para contexto y autorización. T-05 solo para fechas de la proyección acordada, sin validación nueva. |
| [F003: consulta propia](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | F003-B2 para lectura real de Rechazada en F006-B1; F003-B3 para recorrido UI de F006-B3. Preservar propiedad y lectura de los cuatro estados, sin otra pantalla de resultado. |
| [F004: ámbito responsable/asignado/Pendiente](../../lab-004-view-assigned-pending-requests/planning/plan.md#1-objetivo-y-alcance-trazado) | Consumir su regla mediante la autorización de decisión compartida con F005; F004-B2 real para backend, F004-B3 para acción en su detalle. La lectura no sustituye permiso de decidir. |
| [T-06 de F004](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Fuente/semántica de asignación real; pendiente. No cerrar con fixtures ni elegir mantenimiento, cardinalidad o sustituciones. |
| [F005-B1: transición y autorización](../../lab-005-approve-vacation-request/planning/plan.md#f005-b1-transición-y-autorización-backend-aisladas) | Dependencia explícita para la ampliación aislada F006-B1: consumir precondición Pendiente y autorización revisadas. No rehacer esos componentes ni implementar aprobar de nuevo. |
| [F005-B2: registro integrado](../../lab-005-approve-vacation-request/planning/plan.md#f005-b2-registro-autorizado-e-integración-con-las-consultas) | Dependencia del cierre real F006-B1/B3: extender el mecanismo compartido de registro/consultas. No necesita cierre de UI F005-B3 ni aceptación completa F005-B4. |
| [T-07 de F005: concurrencia](../../lab-005-approve-vacation-request/planning/research.md#2-t-07-concurrencia-de-la-aprobación) | Reutilizar la puerta funcional/técnica, también para el rechazo. No se renombra ni abre otra puerta de concurrencia. Cierre real condicionado a que su garantía acordada se demuestre para Rechazada. |
| **T-08: motivo/comentario**, definida en [research.md](research.md#2-t-08-motivo-o-comentario-de-rechazo) | Nueva puerta funcional pendiente, con concreción técnica solo si se acuerda capturarlo. Bloquea aceptación operativa y cierre completo, no revisión aislada de la transición o mockups. |

No se depende de F007 implementada ni de otro flujo de aprobación UI. SEC-001 es transversal, no un
módulo adicional. Reutilizar F005 no significa copiar todos sus Bolts ni crear un nuevo motor de
transiciones: los tres Bolts de esta entrega contienen únicamente ampliaciones de rechazo.

### Comprobación constitucional

Se aplica el [digest](../../../.boltf/memory/constitution.digest.md), decisiones aprobadas, junto con
los [gates compartidos de F005](../../lab-005-approve-vacation-request/planning/plan.md#7-quality-gates-comunes-g).

| Restricción vinculante | Aplicación sin nueva selección |
| --- | --- |
| C#/.NET 8, Angular sin versión fijada, Podman local | Reutilizar base de F001; no adoptar Angular 20/PrimeNG o un estilo arquitectónico por una plantilla. |
| Archivos de configuración y User Secrets local; sin feature flags | Reutilización sin secretos en Git ni bypass provisional de autorización. |
| GitHub Actions, GitHub Flow, GitHub Projects | Reutilizar CI y seguimiento por #7; sin Azure DevOps ni creación de ramas/work items de Bolt. |
| Cobertura unitaria ≥80 %, mutación ≥60 %, build/lint, integración, arquitectura y scans sin críticos | Gates de sección 7; no elevar mutación a 70 % por ejemplos genéricos. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en futuro despliegue. Sin IaC ni plataforma nueva; conflicto `develop`/GitHub Flow pendiente para CD. |
| OpenTelemetry hacia Azure; Resource Health y Activity Logs | Reutilizar observabilidad base, sin confundir telemetría con auditoría detallada. |
| VNet, Private Endpoints, WAF, claves administradas por Azure y PII cifrada | Restricciones de futuro entorno; clasificación/configuración pendientes antes de datos reales. |
| GDPR/HIPAA seleccionados | No declarar aplicabilidad ni cumplimiento conseguido; LAB-OQ-008 y Q-015/Q-016 abiertas. |

Las capas/puertos del diseño siguen siendo propuestas de aprendizaje, no decisiones constitucionales
ni clasificación de agregado DDD. No se detecta una selección nueva incompatible; no equivale a gates
de implementación pasados. El gate Penpot sigue inactivo en la configuración de referencia
(`design-tool: none`); los HTML no son diseño aprobado.

## 3. Trazabilidad: FR/SEC → AC → UC → Gherkin → pruebas

Historia común: US-LAB-F006-01. Se conservan los cuatro escenarios de
[reject-vacation-request.feature](../tests/reject-vacation-request.feature). P-01–P-09 son pruebas
propuestas dentro de F006, no tests ya creados ni duplicación del código de prueba compartido de F005.

| FR/SEC | AC | UC / evidencia | Escenario Gherkin actual | Pruebas propuestas / Bolt |
| --- | --- | --- | --- | --- |
| FR-004 rechazo, SEC-001 | AC-LAB-F006-01 | UC-006 pasos 1–5 | «Rechazar una solicitud pendiente y consultar el estado actualizado» (`@smoke`) | **P-01:** responsable asignado/autorizado, solicitud Pendiente; registrar Rechazada. F006-B1 amplía pruebas de F005 para este outcome; B3 recorrido real desde F004. |
| FR-004 rechazo; FR-002/SEC-001 como dependencia | AC-LAB-F006-02 | UC-006 paso 6 y extensión 6a | Mismo primer escenario, consulta posterior | **P-02:** propietario lee Rechazada por F003; otro empleado no recibe datos. B1 lectura integrada, B3 UI. Sin inferir plazo de propagación ni motivo visible. |
| FR-004 rechazo | Garantía de AC-01, sin AC negativo separado | UC-006 garantía mínima y 3a | «No rechazar una solicitud que ya no está pendiente» | **P-03:** Aprobada/Rechazada/Retirada con fixtures; no registrar rechazo ni alterar estado previo. B1/B3; no decidir respuesta a repetición/idempotencia. |
| SEC-001 | Restricción de AC-01, sin AC negativo separado | UC-006 3b | «Denegar el rechazo por falta de autorización» (`@security`) | **P-04:** responsable no asignado intenta rechazo por entrada directa/manipulada; denegación sin escritura ni datos ajenos. B1/B3, reutilizando fixtures/mecanismo de F005. |
| SEC-001 | Restricción de AC-01; negativo del encargo | Actor responsable y UC-006 3b | Refuerzo del escenario de autorización; no escenario dedicado al empleado | **P-05:** propietario actuando solo como Empleado no rechaza su Pendiente, aunque F003 permita leerla. B1/B3. No inventar política para doble rol. |
| FR-004 rechazo | Precondición de AC-01 | UC-006 3c | «No registrar una decisión para una solicitud inexistente» | **P-06:** solicitud inexistente no genera decisión ni escritura. B1/B3; texto/código/equivalencia con denegación abiertos. |
| FR-004 rechazo | Garantía de AC-01; sin AC concurrente completo | UC-006 3a; Q-004/Q-023/Q-024 | Gap de concurrencia, no quinto escenario | **P-07:** reutilizar comprobación de T-07 con destino de intento Rechazada: si otro cambio ya dejó el registro Aprobada/Rechazada/Retirada entre lectura y registro, el rechazo no lo sobrescribe. B1/B3 condicionados a garantía real de F005. Sin ganador ni otra política de competición. |
| FR-004 rechazo | AC-01/02 parciales | UC-006 4a/6a; Q-022/Q-024 | Solo comentarios Gap | **P-08:** no afirmar éxito sin registro confirmado ni afirmar fallo definitivo con resultado incierto; lectura posterior por F003. UI controlada B2, integración B1/B3 cuando respuestas estén definidas. |
| FR-004 rechazo | Sin AC específico del motivo | UC-006 2a; LAB-OQ-007/Q-011; cuatro HTML | Sin escenario de motivo ni resultado cerrado | **P-09:** revisar cuatro representaciones de UI en B2, sin campo o validación inventados. Pruebas de motivo solo se concretarán tras T-08 y revisión de artefactos; no considerar su ausencia aceptación de «rechazar sin motivo». |

Una prueba de rechazo aislada no demuestra identidad/asignación/concurrencia reales. Los estados de
fixture no exigen entregar F007 o ejecutar F005 para generarlos. Parametrizar los tests comunes cuando
la implementación local lo permita, manteniendo evidencia diferenciada de aprobación y rechazo;
no introducir un framework de pruebas genérico solo para eliminar unas pocas aserciones.

## 4. Componentes y delta backend antes de UI

Las rutas siguientes son propuestas, no archivos creados ni código existente acreditado. Se amplían
los componentes compartidos del diseño, sin nuevo almacén, dispatcher, agregado, entidad de decisión
o máquina de estados genérica.

| Área | Ruta propuesta / referencia | Delta de F006 |
| --- | --- | --- |
| Regla de transición | `src/backend/VacationManagement.Domain/VacationRequests/`, según F005 | Reutilizar precondición Pendiente; añadir únicamente outcome Rechazada, sin salida desde estados finales. |
| Caso de uso de rechazo | `src/backend/VacationManagement.Application/VacationRequests/Reject/` | Operación hermana de Approve, consumiendo misma autorización de decisión y registro. No llamar a aprobar para después cambiar Aprobada por Rechazada. |
| Adaptación/entrada compartida | `src/backend/VacationManagement.Infrastructure/VacationRequests/` y `src/backend/VacationManagement.Api/` | Extender operación de rechazo sobre registro común según T-02/T-03/T-07 acordadas. Sin nuevo proveedor, esquema, URL, verbo, DTO o código elegidos. |
| Acción Angular | `src/frontend/src/app/vacation-requests/assigned-pending/` | Añadir rechazar al detalle F004 usando patrón de acción de F005 donde sea apropiado, sin nueva bandeja ni formulario de motivo anticipado. |
| Frontera frontend | `src/frontend/src/app/vacation-requests/data-access/` | Ampliación específica de rechazo; mismo contexto/mecanismo compartido. El navegador no autoriza ni elige estado libremente. |
| Consulta del empleado | Áreas ReadOwn/own-requests del [plan F003](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | Leer Rechazada del mismo registro, sin nueva consulta, historial ni exposición del motivo. |
| Pruebas compartidas | `tests/VacationManagement.UnitTests/`, `tests/VacationManagement.IntegrationTests/`, `tests/Architecture.Tests/`, `src/frontend/e2e/` | Extender las suites/fixtures de F005 con outcome de rechazo y sus cuatro Gherkin. No crear otra infraestructura de pruebas. |

### Flujo lógico específico

1. Seleccionar una Pendiente asignada mediante F004 y solicitar rechazar. No se añade captura de motivo
   mientras T-08 siga abierta; esto permite revisar el núcleo, no aceptar un flujo operativo sin motivo.
2. Obtener actor autorizado y ámbito según T-04/T-06, reutilizando F005. Verificar de nuevo capacidad
   de decidir, existencia y asignación al ejecutar; la autorización anterior de lectura no basta.
3. Aplicar solo `Pendiente → Rechazada` mediante la regla común y su garantía de registro. La lectura
   inicial Pendiente no demuestra por sí sola que siga Pendiente al guardar; T-07 condiciona la prueba real.
4. Confirmar Rechazada únicamente tras registro confirmado. Un fallo con resultado incierto no se
   transforma por defecto en éxito o en «no se guardó»; recuperación/respuesta abiertas.
5. El propietario consulta estado por F003. En la consulta posterior de F004, Rechazada ya no cumple
   Pendiente; no imponer actualización automática, caché, polling, push o plazo de propagación.

No se elige bloqueo optimista/pesimista, versionado, idempotencia, transacción, reintento, compensación
o ganador concurrente. Se reutiliza T-07 para exigir que una solicitud que ya no está Pendiente no
pase a Rechazada por este intento; no se duplican su definición ni los Bolts para implementarla.

## 5. Mockups y estados sin soporte

Revisados el [README](../mockups/README.md), el [CHANGELOG](../mockups/CHANGELOG.md) y los cuatro HTML.
Son referencias low-fi; la ausencia de motivo no resuelve T-08. Tailwind del wireframe no selecciona
la librería de estilos de Angular. Los datos y `TODO(content)` no son contenido aprobado.

| Mockup | Bolt y responsabilidad | Soporte limitado / pendiente |
| --- | --- | --- |
| [Default](../mockups/reject-request-action-default.html) | F006-B2: acción de rechazo en detalle F004; regla B1 y recorrido B3 | Pendiente asignada/autorizada; datos del detalle provisionales. Sin motivo, lo que no confirma su opcionalidad ni prohibición. |
| [Loading](../mockups/reject-request-action-loading.html) | F006-B2; verificación real B3 | Estado de UI, no nuevo estado de solicitud ni garantía de exclusión de acciones concurrentes. No inferir idempotencia, reintento, duración o bloqueo de negocio del aspecto de un control. |
| [Error](../mockups/reject-request-action-error.html) | F006-B2 para representación; negativos backend B1 y B3 | No Pendiente/no autorizado/inexistente no tienen respuestas/copy diferenciados decididos. No cubre resolución concurrente ni motivo inválido/faltante. «No se ha registrado» no prueba que un fallo incierto no guardara el cambio. |
| [Success](../mockups/reject-request-action-success.html) | F006-B2; registro B1 y consulta integrada B3 | Solo Rechazada confirmada; texto/canal pendiente. No indica visibilidad del motivo al empleado ni demuestra por sí solo AC-02. |

Sin soporte cerrado: solicitud de motivo, reglas/errores del motivo, visibilidad para empleado,
asignación desconocida/ambigua, concurrencia frente a falta de autorización, fallo de registro incierto,
inexistencia frente a denegación y retraso de lectura. No se equiparan estos casos por tener un único
HTML de error. Tampoco se añaden pantallas o confirmación previa para resolverlos. Empty pertenece a
la bandeja de F004, no a esta acción sobre detalle.

## 6. Tres Bolts específicos, sin duplicar F005

Secuencia: F006-B1 → F006-B2 → F006-B3. B1 amplía el backend compartido ya revisado de F005; no
repite sus Bolts de regla, autorización o integración. Si faltan garantías reales o T-08, B1 admite
revisión de su delta aislado y B2 de representación con dobles después del backend. Esto no cierra
el flujo integrado ni habilita una acción operativa ficticia. No se crean tareas, ramas o issues de Bolt.

### F006-B1: ampliar el backend compartido para Rechazada

- **Objetivo:** añadir el outcome específico de rechazo y verificarlo sin reconstruir el mecanismo de decisión de F005.
- **Dependencias:** F005-B1 implementado/revisado para regla y autorización. Para cierre real,
  F005-B2 y sus dependencias F001-B4/F003-B2/F004-B2; T-02/T-03/T-04/T-06/T-07 concretadas.
  T-08 aclarada para aceptar comportamiento operativo; mientras tanto, solo delta aislado revisable.
- **Componentes/rutas propuestas:** regla Domain/VacationRequests compartida, nuevo caso
  Application/VacationRequests/Reject y ampliación mínima de entrada/adaptador comunes de sección 4.
- **Entregables:** intención específica de rechazar, destino fijo Rechazada, reutilización de guard,
  autorización y registro; lectura por F003 y exclusión por el filtro Pendiente de F004, sin nuevas consultas.
- **Pruebas:** P-01–P-07 extendiendo fixtures/suites de F005. Éxito registrado y leído por propietario;
  no asignado/propietario solo Empleado/inexistencia/tres estados finales sin decisión ni cambio.
  P-07 usa la garantía real de T-07 para rechazo; un doble o estado precargado no la demuestra.
  Mantener no regresión de aprobación, propiedad de F003 y filtro de F004. Sin tests de motivo inventados.
- **Documentación:** delta y referencias a componentes comunes, evidencia aislada frente a real,
  estado de T-07/T-08 y contratos lógicos que se acuerden fuera de esta entrega.
- **Criterio de salida:** rechazo específico verificado con las garantías compartidas y lectura real,
  sin estados intermedios artificiales. Sin F005-B1 no reconstruirlo aquí; sin dependencias/T-07/T-08,
  revisión parcial, no cierre operativo. Captura de motivo, si se exige, requiere revisión previa del plan.
- **Quality gates:** G, sección 7: build/lint, unitarias ≥80 %, mutación ≥60 %, integración real,
  arquitectura y scans sin críticos aplicables. Gates bloqueados se reportan, no se pasan con dobles.
- **Estimación orientativa:** complejidad media del delta; alta incertidumbre heredada, sin duración comprometida.

### F006-B2: acción de rechazo y cuatro representaciones de UI

- **Objetivo:** incorporar rechazar al detalle existente de F004, reutilizando el patrón de acción de F005 solo donde exista y encaje.
- **Dependencias:** delta backend B1 comprobado; F001-B1 frontend/T-01, UI F004-B3 y frontera compartida.
  No requiere completar UI F005-B3; si ya existe, reutilizar patrón sin rehacerlo ni forzar una abstracción.
  Conexión operativa depende de cierre real B1 y T-08; presentación aislada con dobles no los sustituye.
- **Componentes/rutas propuestas:** `src/frontend/src/app/vacation-requests/assigned-pending/` y
  `src/frontend/src/app/vacation-requests/data-access/`, sin nueva pantalla de resultado del empleado.
- **Entregables:** [default](../mockups/reject-request-action-default.html),
  [loading](../mockups/reject-request-action-loading.html), [error](../mockups/reject-request-action-error.html)
  y [success](../mockups/reject-request-action-success.html); sin textarea/catálogo de motivo, validaciones,
  confirmación previa, reapertura o notificaciones anticipados.
- **Pruebas:** P-08/P-09 con respuestas controladas, éxito solo confirmado y error sin datos ajenos
  residuales. Revisión móvil/escritorio, teclado/foco y jerarquía, sin inventar nivel WCAG. Control de UI
  no sustituye autorización backend ni demuestra exclusión concurrente.
- **Documentación:** mapping HTML/componente, TODO(content), diferencia entre shell y respuesta
  funcional; T-08 y ausencia de representación para conflicto/fallo incierto/errores de motivo.
- **Criterio de salida:** cuatro referencias revisadas con límites explícitos. Sin T-08 o contenido
  aclarado, solo presentación parcial; no considerar que la falta de campo prueba rechazo sin motivo aceptado.
- **Quality gates:** G frontend: build/lint, unitarias ≥80 %, mutación ≥60 %, componentes/arquitectura
  aplicables y scans sin críticos. E2E real permanece en B3; dobles no acreditan registro ni AC-02.
- **Estimación orientativa:** complejidad media; sujeta a aclaración de T-08 y contenido.

### F006-B3: verificar el rechazo integrado y sus cuatro escenarios

- **Objetivo:** demostrar AC-01/02 y negativos mediante el recorrido F004 → rechazo → consulta F003, reutilizando infraestructura de aceptación de F005 cuando exista.
- **Dependencias:** B1/B2 reales, F003-B3/F004-B3 para UI, puertas heredadas aplicables concretadas y
  T-08 aclarada; T-07 demostrada para rechazo. No requiere cierre completo de F005-B4 o F007 implementada.
- **Componentes/rutas propuestas:** suites de integración/arquitectura y `src/frontend/e2e/` compartidas.
  No crear otro entorno de pruebas ni endpoints funcionales para estados o actores de preparación.
- **Entregables:** cuatro escenarios trazados a tests ejecutables de rechazo, negativos adicionales,
  matriz de resultados y gates, con gaps restantes separados de evidencias aprobadas técnicamente.
- **Pruebas:** P-01–P-07 reales: presentar mediante F001, seleccionar por F004, rechazar y leer
  Rechazada por F003; no asignado, propietario solo Empleado y Aprobada/Rechazada/Retirada sin cambio;
  inexistente sin decisión. No exposición a otro empleado. P-07 reutiliza intercalados definidos por
  T-07, sin elegir ganador. P-08/P-09 y pruebas derivadas de T-08 solo según resultados aclarados.
- **Documentación:** comandos realmente ejecutados, evidencia de registro/consulta, tabla de los
  cuatro Gherkin, gates y revisión personal; sin sign-off de negocio o cumplimiento regulatorio ficticios.
- **Criterio de salida:** ambas AC, cuatro escenarios y negativos verificables pasan con dependencias
  reales y gates satisfechos. T-07/T-08 pendientes o respuestas no definidas impiden declarar UC-006 completo;
  no se oculta cobertura ausente detrás de porcentajes o el happy path.
- **Quality gates:** G íntegro: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración/E2E,
  arquitectura y scans sin críticos; alcance y bloqueos documentados.
- **Estimación orientativa:** complejidad media; condicionada a garantías y aclaraciones, no a una tecnología elegida.

## 7. Gates comunes (G), seguridad y no regresión

Se consumen los [gates de F005](../../lab-005-approve-vacation-request/planning/plan.md#7-quality-gates-comunes-g),
sin crear CI, pipeline de mutación o base de pruebas alternativos. Por Bolt se exige build/lint,
cobertura unitaria ≥80 %, mutación ≥60 %, integración y arquitectura aplicables, y scans de
seguridad/dependencias sin críticos; construcción/escaneo de contenedor sin críticos al existir imagen.
Umbrales sobre el alcance medido de aplicación acordado, sin rebajarlos por ser laboratorio.

- Probar en la entrada real la denegación de responsable no asignado y propietario solo Empleado;
  probar cada estado no Pendiente y la inexistencia verificando registro/estado, no solo botones ocultos.
- No regresión compartida: aprobar sigue teniendo destino Aprobada; rechazar, Rechazada; ninguno
  cambia estados finales. F003 conserva propiedad y lectura de los cuatro estados; F004 solo Pendiente asignadas.
- La comprobación de estado previa o una prueba secuencial no acredita T-07. Evidencia real de la
  garantía común, específica para el destino Rechazada; fixtures de motivo no cierran T-08.
- Reutilizar ejecución Podman/GitHub Actions. Gate no disponible: bloqueo o no aplicabilidad con
  justificación, nunca «pasado». UI con dobles se identifica como tal, no como aceptación integrada.
- Consumir OpenTelemetry hacia Azure sin contenido de solicitudes o posible motivo en telemetría.
  No inventar auditoría, retención, alarmas, objetivos operativos ni declarar cumplimiento GDPR/HIPAA.

Son gates de futura implementación. Esta entrega documental no ejecuta tests de aplicación ni
declara superada la calidad del código o cerradas las puertas.

## 8. Preguntas abiertas y riesgos

| Fuente | Cuestión sin resolver | Tratamiento sin ampliar alcance |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-013/Q-014 | Fuente, mantenimiento, vigencia de asignación y capacidad de decidir | T-04/T-06 heredadas. No elegir modelo de autorización ni administrar asignaciones. |
| LAB-OQ-006; Q-003/Q-004/Q-023/Q-024 | Reversión/reapertura, retirada/en revisión y concurrencia | T-07 de F005; no se registra rechazo desde no Pendiente. No decidir reversibilidad, ganador, versión, bloqueo o idempotencia. |
| LAB-OQ-007; Q-011; UC-006 2a | Existencia, obligatoriedad, longitud, contenido, persistencia y visibilidad del motivo | T-08 pendiente. Mockups sin campo no son respuesta; aclarar antes de aceptar flujo operativo. |
| LAB-OQ-008; Q-013/Q-015/Q-016 | Autenticación, privacidad, evidencia de quién/cuándo, auditoría y retención | Reutilizar mecanismo acordado y no añadir historial/campos de decisión o política legal. |
| Q-004/Q-014/Q-022/Q-024; UC-006 4a/6a | Registro efectivo, resultado incierto y estado actualizado | Garantías compartidas y aclaraciones de aceptación; sin plazo, retry, polling, push, rollback o mensaje elegido. |
| Q-005/Q-011/Q-021/Q-024 | Datos visibles, contenido y errores sin resultado cerrado | Mantener referencias provisionales. No equiparar inexistencia, no autorizado, no Pendiente, conflicto y fallo técnico. |
| Q-019/Q-022/Q-025 | NFR y autoridad/evidencia de aceptación | Sin targets ni aprobación ficticia; laboratorio y Draft se mantienen aunque pasen pruebas. |
| Regla compartida de F005 no implementada/revisada | Duplicar el trabajo para avanzar F006 | Dependencia explícita: entregar regla en F005-B1 y garantías en su B2; no nuevos Bolts equivalentes en F006. |

## 9. Fuentes y comentario de seguimiento

- [Constitución: digest](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md) y [clarificaciones](../../clarification-summary.md).
- [Requisitos F006](../requirements/requirements.md), [UC-006](../requirements/use-cases/UC-006.md), [cuatro Gherkin](../tests/reject-vacation-request.feature), [mockups](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md).
- [Dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md), [modelo de estados](../../lab-005-approve-vacation-request/requirements/state-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).
- [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: consulta](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [F004: ámbito y bandeja](../../lab-004-view-assigned-pending-requests/planning/plan.md) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md).
- [F005: regla y mecanismo de decisión](../../lab-005-approve-vacation-request/planning/plan.md) y [T-07](../../lab-005-approve-vacation-request/planning/research.md).

El comentario solicitado para #7 se prepara en [research.md](research.md#6-comentario-preparado-para-el-issue-7).
No se ha publicado: las herramientas disponibles en esta sesión no incluyen escritura en GitHub. No
se cambia cuerpo ni estado del issue, ni se crea otro work item. Sus enlaces remotos son previstos
hasta publicar los archivos; no se solicita commit/push. No se continúa automáticamente con código,
tasks, OpenAPI, data-model, nuevos Gherkin o Azure DevOps.