# Plan técnico: LAB-F005: Aprobar una solicitud de vacaciones

| Propiedad | Valor |
| --- | --- |
| Estado | Draft / LAB-HYP. Laboratorio personal; sin aprobación de negocio ni validación de producción. |
| Escenario | fullstack; backend y frontend, con entorno local compartido. Sin aprovisionamiento cloud. |
| Issue | [#4](https://github.com/jCabreraMartin/vacation-management/issues/4) |
| Rama comprobada antes de planificar | `feature/vacation-management-lab-catalog`, según `.git/HEAD`. No se crean ni cambian ramas. |
| Estimación inicial | Cuatro Bolts revisables; complejidad relativa media/alta. Sin fechas ni compromisos. |
| Salida de esta entrega | Este plan y [research.md](research.md). Sin código, tareas, contratos ni modelo de datos. |

## 1. Objetivo y alcance

Un Responsable aprobador autorizado aprueba una solicitud existente que continúa `Pendiente` de un
empleado asignado. El sistema registra el estado `Aprobada` y el empleado consulta ese estado mediante
LAB-F003. Trazabilidad propia: FR-004, únicamente aprobación; SEC-001; US-LAB-F005-01;
AC-LAB-F005-01/02 y UC-005. La consulta del resultado reutiliza F003, no crea otra pantalla del empleado.

Las reglas siguen siendo hipótesis Draft. Las capas y fronteras descritas son descomposición propuesta
de la arquitectura del laboratorio, no una arquitectura constitucional ratificada ni un agregado DDD
confirmado. Tener planes validados de F001/F003/F004 no demuestra implementación de sus dependencias.

### Regla de aprobación, antes de la UI

Se comprueban en backend, para la operación de aprobar, las condiciones conjuntas siguientes:

1. La solicitud existe y el actor tiene capacidad autorizada de Responsable aprobador para decidirla.
2. Su empleado propietario pertenece al ámbito asignado acreditado a ese responsable, reutilizando F004.
3. La solicitud continúa exactamente `Pendiente` al registrar la aprobación, no solo al abrir el detalle.

Si se cumplen, se registra `Pendiente → Aprobada`. Si no existe, no se registra una decisión; si falta
autorización/asignación o ya no está Pendiente, no se registra una aprobación ni se altera su estado.
Se prueban por separado `Aprobada`, `Rechazada` y `Retirada`, conservando el estado previo.

La referencia de solicitud y la presencia de un botón o de un detalle previamente autorizado no conceden
permiso de escritura. La autorización de lectura de F004 es reutilizable como condición de ámbito,
pero no sustituye la comprobación de capacidad de **decidir** al ejecutar F005. La propiedad del empleado
permite consultar por F003, no aprobar. El negativo «propio empleado» usa un actor que solo actúa como
Empleado, sin capacidad de responsable: no establece una política nueva para identidades con ambos
roles o autoasignaciones, que las fuentes no definen.

### Referencias de contexto que no amplían la entrega

| Referencia citada en las fuentes | Para qué se utiliza en F005 | Límite |
| --- | --- | --- |
| FR-001 / LAB-F001 | Proporciona la solicitud registrada inicialmente Pendiente y su pertenencia. | No volver a implementar presentación. El comentario opcional de solicitud no es un comentario de decisión. |
| FR-006 / LAB-F002 | Explica qué entradas no crean una solicitud Pendiente en el origen del ciclo. | Se consume la capacidad de F001; no añadir validaciones de fechas al aprobar ni políticas de calendario. |
| FR-002 / LAB-F003 | Consulta propia para observar el estado resultante, exigida por AC-F005-02. | Reutilizar lectura y UI de F003; no convertir F003 en un flujo de escritura. |
| FR-003 / LAB-F004 | Bandeja/detalle de origen y regla responsable/asignado/Pendiente. | Reutilizar ámbito y selección, sin administrar asignaciones. |
| UC-006 / LAB-F006 / parte de rechazo de FR-004 | Evidencia de condiciones de estado y autorización comunes a decisiones. | Diseñar su reutilización futura; no implementar rechazo, motivo ni sus controles. |
| FR-005, UC-007, AC-LAB-F007-02 / LAB-F007 | Evidencia de retirada solo desde Pendiente y posible cambio de estado concurrente. | Compatibilidad del guard de estado; no implementar retirada, ni adoptar su autorización de propietario para aprobar. |

No se incluyen reversión/reapertura, edición, comentario de decisión obligatorio u opcional como nueva
capacidad, notificaciones, historial detallado de decisiones, actor/fecha de auditoría, saldo
(LAB-OQ-005), integraciones ni NFR. No se crea el estado `En revisión`. No se decide motor de datos,
ORM, API/protocolo, IdP, modelo de autorización, CQRS, broker o mecanismo de concurrencia.

## 2. Reutilización y puertas de entrada

Las definiciones compartidas permanecen en sus documentos de origen; esta tabla solo establece dónde
se consumen. No se copia ni se resuelve su selección técnica.

| Referencia única | Uso en F005 / dependencia |
| --- | --- |
| [F001: base y Bolts](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo) | F001-B1 para base .NET/Angular/pruebas. F001-B4 para solicitud, pertenencia y registro reales en F005-B2/B4. Sin otra foundation. |
| [T-01–T-05 de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | T-01 para UI; T-02 para entrada/resultado reales de aprobar; T-03 para lectura y actualización del registro; T-04 para actor y autorización de decisión. T-05 solo para fechas ya expuestas por la proyección acordada, no para revalidar calendario. |
| [F003: consulta y acceso](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | Reutilizar F003-B1 como frontera revisada; F003-B2 para comprobar lectura real del resultado en F005-B2 y su UI B3 para el recorrido de F005-B4. No alterar propiedad ni limitar consulta propia a Pendiente. |
| [F004: regla conjunta y consulta](../../lab-004-view-assigned-pending-requests/planning/plan.md#1-objetivo-y-alcance-trazado) | Reutilizar F004-B1 en F005-B1; F004-B2 real en F005-B2; bandeja/detalle F004-B3 en F005-B3/B4. Repetir la verificación al decidir, no confiar en la selección anterior. |
| [T-06 de F004: dato de asignación](../../lab-004-view-assigned-pending-requests/planning/research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Prerrequisito real B2/B4. Consumir su fuente y semántica cuando se acuerden; no duplicar asignaciones, elegir cardinalidad o declarar resuelta la puerta mediante fixtures. |
| **T-07: concurrencia de la aprobación**, definida en [research.md](research.md#2-t-07-concurrencia-de-la-aprobación) | Nueva puerta funcional y técnica pendiente. Bloquea cierre de B2/B4 hasta aclarar resultado/efectividad y demostrar la garantía de estado en el registro real. B1 y B3 aislados pueden revisarse con dobles. |

F003 no añadió puertas y F004 añadió T-06; por ello T-07 no renumera decisiones previas. Si las
fronteras compartidas aún no existen, acordar su entrega desde los Bolts de origen, sin reconstruirlas
en F005. La prueba integrada de AC-02 requiere F003, aunque las pruebas aisladas de transición no
dependen de que su UI esté terminada. SEC-001 se aplica en todos los niveles, no es otro módulo.

### Comprobación constitucional

Fuente vinculante: [digest](../../../.boltf/memory/constitution.digest.md), decisiones aprobadas;
alternativas de plantilla y ejemplos de skills no seleccionan tecnologías.

| Restricción | Aplicación prevista / comprobación pendiente |
| --- | --- |
| C#/.NET 8, Angular sin versión, Podman local | Reutilizar F001-B1 y T-01. No elegir Angular 20, PrimeNG o componentes de estilos por aparecer en una skill. |
| Archivos de configuración y User Secrets local; sin feature flags | Reutilizar configuración compartida, sin secretos en Git ni bypass provisional de seguridad. |
| GitHub Actions, GitHub Flow, GitHub Projects | Reutilizar CI y seguimiento por #4; no Azure DevOps ni creación de ramas/work items de Bolt. |
| Unitarias ≥80 %, mutación ≥60 %, build/lint, integración, arquitectura y scans sin críticos | Gates G de sección 7. El 70 % de ejemplos genéricos no es el umbral del proyecto. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en entrega futura; sin IaC ni elección de hosting. Trigger `develop` frente a GitHub Flow pendiente antes de CD. |
| OpenTelemetry hacia Azure, Resource Health y Activity Logs | Consumir observabilidad base; no equiparar telemetría con auditoría de decisiones. Sin objetivos operativos nuevos. |
| VNet, Private Endpoints, WAF, claves administradas por Azure y PII cifrada | Mantener restricciones en futuro entorno; clasificación/configuración pendientes antes de datos reales. |
| GDPR/HIPAA seleccionados en inicialización | No declarar aplicabilidad ni cumplimiento conseguido; LAB-OQ-008 y Q-015/Q-016 siguen abiertas. |

No se detecta una selección técnica nueva contraria a la constitución; esto no acredita gates de
implementación superados. El gate Penpot no está activo en la configuración de referencia
(`design-tool: none`); los HTML son referencias, no diseños aprobados.

## 3. Trazabilidad: FR/SEC → AC → UC → Gherkin → pruebas

Historia común: US-LAB-F005-01. Se mantienen los cuatro escenarios de
[approve-vacation-request.feature](../tests/approve-vacation-request.feature), sin modificarlos ni crear
tests ahora. P-01–P-09 identifican pruebas propuestas solo dentro de este plan.

| FR/SEC | AC | UC / evidencia | Escenario Gherkin actual | Pruebas propuestas / Bolt |
| --- | --- | --- | --- | --- |
| FR-004 aprobación, SEC-001 | AC-LAB-F005-01 | UC-005 pasos 1–5 | «Aprobar una solicitud pendiente y consultar el estado actualizado» (`@smoke`) | **P-01:** actor responsable asignado/autorizado y Pendiente existente; registrar Aprobada. B1 aislado, B2 registro real, B4 E2E desde F004. |
| FR-004 aprobación; FR-002/SEC-001 como dependencia | AC-LAB-F005-02 | UC-005 paso 6 y extensión 6a | Mismo primer escenario, segunda consulta | **P-02:** después de registro confirmado, el propietario lee Aprobada por lista/detalle de F003; otro empleado no obtiene datos. B2 integración de lectura, B4 UI. Sin plazo de propagación inventado; Q-022 pendiente. |
| FR-004 aprobación | Garantía de AC-01, sin AC negativo separado | UC-005 garantía mínima y 3a | «No aprobar una solicitud que ya no está pendiente» | **P-03:** parametrizar Aprobada/Rechazada/Retirada; intento directo no registra aprobación y conserva el estado. B1/B2/B4 con fixtures, sin implementar F006/F007. No decidir semántica de idempotencia. |
| SEC-001 | Restricción de AC-01, sin AC negativo separado | UC-005 precondiciones y 3b | «Denegar la aprobación por falta de autorización» (`@security`) | **P-04:** responsable R2 no asignado intenta aprobar la Pendiente del ámbito de R1, incluso por entrada manipulada; denegado sin escritura ni datos ajenos. B1/B2/B4. |
| SEC-001 | Restricción de AC-01; negativo explícito del encargo | Actor responsable y UC-005 3b | Refuerzo del escenario de autorización; no hay escenario dedicado al empleado | **P-05:** propietario actuando solo como Empleado intenta aprobar su Pendiente; no modifica ni registra aprobación, aunque F003 permita leerla. B1/B2/B4. Sin política de doble rol inventada. |
| FR-004 aprobación | Precondición de AC-01 | UC-005 3c | «No registrar una decisión para una solicitud inexistente» | **P-06:** solicitud inexistente no genera decisión ni escritura. B1/B2/B4; código, mensaje y posible equivalencia con denegación sin definir. |
| FR-004 aprobación; FR-005/UC-007 solo contexto | Garantía de AC-01; sin AC concurrente completo | UC-005 3a; Q-004/Q-023/Q-024 | Gap de concurrencia, no quinto escenario | **P-07:** tras lectura Pendiente, intercalar en el registro de pruebas un cambio ya establecido a Aprobada/Rechazada/Retirada antes de aplicar la aprobación; no sobrescribirlo con una aprobación. B1 como simulación; B2/B4 contra la garantía real de T-07. No elegir ganador de acciones simultáneas. |
| FR-004 aprobación | AC-01/02 parciales | UC-005 4a/6a; Q-022/Q-024 | Solo comentarios Gap | **P-08:** con resultado de registro no confirmado, no presentar éxito como acreditado; observar separadamente registro y lectura posterior. Representación controlada B3; resultados de fallo/recuperación y aceptación integrada bloqueados hasta aclaración. |
| FR-004 aprobación | AC-01, sin AC visual adicional | UC-005 pasos 2/5; cuatro HTML | Representación del primer escenario, no escenarios adicionales | **P-09:** componentes default/loading/error/success y transición visual según resultado acreditado; sin textos definitivos ni controles de rechazo/retirada. B3; recorrido real B4. |

P-07 verifica únicamente la restricción conocida si el estado ya ha cambiado. No define precedencia,
número de decisiones, respuesta a duplicados, ganador, mensaje o recuperación cuando dos operaciones
compiten. Pasar una prueba secuencial de P-03 o un doble de P-07 no demuestra seguridad concurrente.
F006/F007 no son prerrequisitos: estados distintos de Pendiente y cambios intercalados se preparan
mediante infraestructura de pruebas, no endpoints funcionales nuevos ni transiciones entregadas.

## 4. Componentes propuestos y reutilización de la transición

Todas las rutas siguientes son propuestas, no código ni archivos generados. Se amplían las áreas
compartidas de F001/F003/F004, sin imponer agregado, repositorio, Unit of Work o dispatcher.

| Componente | Ruta propuesta | Responsabilidad / límite |
| --- | --- | --- |
| Regla de estado | `src/backend/VacationManagement.Domain/VacationRequests/` | Encapsular la precondición Pendiente y la aprobación con destino fijo Aprobada. Sin motor genérico de estados o destino editable por cliente. |
| Caso de uso de aprobación | `src/backend/VacationManagement.Application/VacationRequests/Approve/` | Coordinar existencia, capacidad de decidir, ámbito de F004, regla de estado y registro. No invocar ReadOwn como autorización del responsable. |
| Registro/lectura compartidos | `src/backend/VacationManagement.Infrastructure/VacationRequests/` | Ampliar el adaptador de F001; F003 lee el resultado y F004 conserva su filtro Pendiente. T-03/T-07 condicionan garantías, sin escoger implementación. |
| Entrada de aprobación | `src/backend/VacationManagement.Api/` | Operación lógica propia, contexto T-04 y comprobaciones backend. T-02 decidirá exposición; no se fijan rutas HTTP, verbos, DTO ni códigos. |
| Acción Angular | `src/frontend/src/app/vacation-requests/assigned-pending/` | Incorporar aprobar al detalle de F004, sin nueva bandeja ni acciones F006/F007. Componente concreto por acordar. |
| Frontera frontend compartida | `src/frontend/src/app/vacation-requests/data-access/` | Consumir la operación de aprobar; separar estados de UI del estado de solicitud y del resultado incierto. Sin filtrar seguridad en navegador. |
| Consulta del empleado | Áreas `ReadOwn/` y `own-requests/` del [plan F003](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas) | Reutilización, no pantalla ni registro alternativos. Mantener lectura de los cuatro estados y propiedad. |
| Pruebas compartidas | `tests/VacationManagement.UnitTests/`, `tests/VacationManagement.IntegrationTests/`, `tests/Architecture.Tests/`, `src/frontend/e2e/` | Ampliar suites existentes cuando estén implementadas; no se eligen herramientas/versiones aquí. |

### Regla reutilizable sin implementar otros outcomes

Separar la precondición de estado de la autorización específica de cada acción. La comprobación de
origen Pendiente será reutilizable por F006; su autorización responsable/asignado también podrá
consumir el mecanismo compartido de F004/F005 cuando se implemente. F007 podrá compartir la
precondición de estado, pero seguirá necesitando **propiedad del empleado**, no permiso de responsable.
El registro real deberá sostener esa restricción bajo la garantía que se concrete en T-07.

En F005 solo se entrega la transición a Aprobada. No se generan métodos, endpoints o ramas de UI de
rechazo/retirada por anticipado. No se crean salidas desde estados finales ni se interpreta `En revisión`
como estado. Reutilizar una comprobación pequeña no justifica un servicio de dominio o máquina de
estados extensible sin evidencia adicional.

### Flujo lógico y límite de concurrencia

1. Abrir la Pendiente por la bandeja/detalle autorizado de F004.
2. Recibir la intención de aprobar y obtener el contexto real por T-04; no aceptar un actor/ámbito
   arbitrario enviado por la UI como prueba de permiso.
3. Verificar de nuevo existencia, capacidad de decidir y asignación acreditada por T-06, aunque la
   selección antes fuese válida. Si no se acredita acceso, no aprobar ni devolver datos fuera de ámbito.
4. Aplicar la transición solo si sigue Pendiente **en la frontera que registra**. Un `if` sobre una
   lectura anterior no demuestra esa garantía si el estado cambia después. Su comprobación real
   y la respuesta a acciones competidoras dependen de T-07; no se prescribe técnica para resolverlo.
5. Confirmar al responsable solo cuando conste registro confirmado de Aprobada. Si el resultado es
   incierto, no afirmar éxito ni tampoco que nada se guardó; fallo y recuperación siguen abiertos.
6. El empleado consulta por F003 el estado leído del registro. En una consulta posterior de F004,
   Aprobada ya no cumple el filtro Pendiente; no se añade actualización automática ni plazo de frescura.

La resolución observable de decisiones simultáneas, retirada durante aprobación y fallo de registro
queda pendiente de T-07/Q-024. No se elige bloqueo optimista/pesimista, versionado, idempotencia,
transacción, retry, compensación, mensajes ni códigos. El resultado exacto no definido no permite
sobrescribir una solicitud que ya no esté Pendiente.

## 5. Cuatro mockups y estados sin soporte

Leídos el [README](../mockups/README.md), el [CHANGELOG](../mockups/CHANGELOG.md) y los cuatro HTML.
Son referencias low-fi, no diseño aprobado; el CDN Tailwind del wireframe no selecciona estilos para
Angular. Los textos `TODO(content)` y los datos ilustrativos no se convierten en contratos.

| Mockup | Bolt y componente | Soporte / límite |
| --- | --- | --- |
| [Default](../mockups/approve-request-action-default.html) | F005-B3: acción sobre detalle F004; B4 real | Pendiente asignada y autorizada. Fechas/comentario ilustran datos de solicitud, no campos definitivos ni formulario de comentario de decisión. Q-005/Q-011 siguen abiertas. |
| [Loading](../mockups/approve-request-action-loading.html) | F005-B3; B4 real | Estado de envío de UI, no estado de dominio ni aprobación en curso persistida. No define deshabilitado, exclusión de doble clic, reintento, duración ni estado actual garantizado; Pendiente en pantalla puede haber cambiado. |
| [Error](../mockups/approve-request-action-error.html) | F005-B3 para shell; reglas B1/B2 y negativos B4 | Representa no Pendiente, no autorizado o inexistente, sin respuestas/copy diferenciados. No cubre resolución de concurrencia ni registro incierto. Su rótulo «No se ha registrado» no prueba que un fallo técnico no haya guardado el cambio. |
| [Success](../mockups/approve-request-action-success.html) | F005-B3; registro B2 y aceptación B4 | Aprobada solo tras confirmación real. Texto/canal de confirmación pendiente. Mostrarlo con un doble no acredita AC-01/02 ni consulta de F003. |

No existe soporte funcional cerrado para error de concurrencia frente a falta de autorización,
asignación desconocida/ambigua, fallo al registrar con resultado incierto, datos desactualizados en
F003 o solicitud inexistente frente a denegación. No se colapsan en una misma respuesta por usar un
solo HTML; tampoco se inventan pantallas, confirmación previa o acciones de recuperación.
`empty` no aplica a una acción sobre un detalle; la bandeja vacía pertenece a F004.

## 6. Bolts revisables por separado

Secuencia principal: F005-B1 → F005-B2 → F005-B3 → F005-B4. Si las puertas reales están bloqueadas,
B3 puede revisarse con dobles **después** de B1 y la base frontend de F004, sin habilitar una acción
operativa ficticia ni cerrar B2/B4. No se generan tareas, ramas ni issues de Bolt en esta entrega.

### F005-B1: transición y autorización backend aisladas

- **Objetivo:** comprobar Pendiente → Aprobada y las denegaciones antes de construir su UI; separar
  precondición de estado reutilizable de autorización específica de decisión.
- **Dependencias:** F001-B1 backend; fronteras revisadas F003-B1 y regla de ámbito F004-B1. Contexto,
  asignación y registro controlados; T-04/T-06/T-07 siguen pendientes para integración real.
- **Componentes/rutas propuestas:** áreas Domain/VacationRequests y Application/VacationRequests/Approve
  bajo `src/backend/`, y suite unitaria compartida de sección 4. Reutilizar el mecanismo de acceso de F004.
- **Entregables:** regla de estado, orquestación aislada de aprobación y pruebas de no escritura cuando
  no se cumplen condiciones; frontera de registro pendiente de concretar, sin tecnología elegida.
- **Pruebas:** P-01, P-03–P-06; quitar capacidad, asignación, existencia o Pendiente por separado impide
  aprobar. Parametrizar los tres estados finales y propietario solo Empleado. P-07 con intercalado
  controlado documenta el límite, no prueba concurrencia real. No implementar F006/F007 para fixtures.
- **Documentación:** trazabilidad fuente/prueba; diferencia entre lectura F004 y permiso de decidir;
  reutilización futura del guard y límites del doble/T-07, sin dar respuestas a LAB-OQ.
- **Criterio de salida:** matriz aislada comprobada, destino solo Aprobada y estado previo conservado
  en denegaciones. No se declara resuelta la garantía concurrente, la asignación o identidad reales.
- **Quality gates:** G, sección 7: build/lint, unitarias ≥80 %, mutación ≥60 %, arquitectura y scans
  aplicables. Integración real pendiente explícita de B2, no pasada con dobles.
- **Estimación orientativa:** complejidad media, sin duración comprometida.

### F005-B2: registro autorizado e integración con las consultas

- **Objetivo:** registrar Aprobada en la solicitud real y demostrar lectura por F003, preservando la
  restricción Pendiente en el registro y las reglas de F004.
- **Dependencias:** B1; F001-B4, F003-B2 y F004-B2 reales; T-02/T-03/T-04/T-06 concretadas;
  **T-07 bloqueante para cierre**. T-05 se consume solo si se transportan fechas. Aclarar registro
  efectivo/confirmado y evidencia de lectura (Q-004/Q-022/Q-024) para los caminos que se evalúen.
- **Componentes/rutas propuestas:** Application/VacationRequests/Approve, entrada
  `src/backend/VacationManagement.Api/` y adaptador compartido
  `src/backend/VacationManagement.Infrastructure/VacationRequests/`; ReadOwn y ReadAssignedPending
  se reutilizan sin otro almacén o consulta especial de resultado.
- **Entregables:** operación real de aprobar, verificación de capacidad/asignación al ejecutar y
  registro confirmado; consulta de Aprobada por propietario y exclusión en consulta Pendiente de F004.
- **Pruebas:** P-01–P-07 con actor/fuente de asignación/registro reales. Crear Pendiente por F001,
  aprobar como asignado, releer por F003, consultar F004; negativos directos y fixtures de estados
  finales/inexistencia. P-07 debe detectar un cambio entre lectura y registro, no solo estado final
  precargado. Su mecanismo de comprobación se concretará con T-07; sin API de rechazo/retirada nueva.
- **Documentación:** evidencia de integración y garantías realmente demostradas, decisiones cuando
  se acuerden, consultas reutilizadas y ejecución Podman. Mantener respuestas no definidas como gaps.
- **Criterio de salida:** registro y lectura reales reproducibles; no sobrescribir estados finales ni
  aprobar sin ámbito/capacidad. Sin T-07 o sin evidencia real, solo revisión parcial del camino
  secuencial; no cerrar este Bolt ni declarar UC-005 concurrente completo.
- **Quality gates:** G completo backend: build/lint, unitarias ≥80 %, mutación ≥60 %, integración,
  arquitectura y scans sin críticos; container build/scan al existir imagen.
- **Estimación orientativa:** alta por puertas y garantías pendientes, no por una tecnología elegida.

### F005-B3: acción de aprobar y cuatro representaciones de UI

- **Objetivo:** añadir solo aprobar al detalle del responsable y representar default/loading/error/success.
- **Dependencias:** B1 probado, F001-B1 frontend/T-01 y UI/frontera F004-B3 reutilizables; B2 para
  conexión real. Si B2/T-07 faltan, revisión exclusivamente aislada con dobles identificados. Contenido
  final condicionado a Q-011/Q-024 y confirmación de datos visibles de detalle con F004.
- **Componentes/rutas propuestas:** `src/frontend/src/app/vacation-requests/assigned-pending/` y
  `src/frontend/src/app/vacation-requests/data-access/`. Reutilizar consulta UI de F003, sin reescribirla.
- **Entregables:** acción y representaciones de los [cuatro mockups de sección 5](#5-cuatro-mockups-y-estados-sin-soporte),
  sin comentario de decisión, confirmación previa, rechazo, retirada o botón de reversión añadidos.
- **Pruebas:** P-09 con respuestas controladas; loading no implica éxito ni estado vigente. P-08 no
  representa registro incierto como éxito o como fallo definitivo sin evidencia. Error no conserva
  datos fuera de ámbito. Revisión móvil/escritorio, teclado/foco y jerarquía, sin afirmar nivel WCAG.
  Backend sigue rechazando acciones manipuladas aunque un control no esté visible.
- **Documentación:** correspondencia HTML/componente; shells frente a comportamiento aceptable,
  textos pendientes y ausencia de representación diferenciada de concurrencia/fallo incierto.
- **Criterio de salida:** cuatro referencias revisadas con límites visibles; success solo responde a
  registro confirmado. Sin mensajes/reglas aclarados o B2 real, salida parcial de UI, no aceptación
  funcional; el HTML error no se usa como contrato para cualquier fallo técnico.
- **Quality gates:** G frontend: build/lint, unitarias ≥80 %, mutación ≥60 %, componentes/arquitectura
  aplicables y scans sin críticos. E2E con dobles no sustituye B4.
- **Estimación orientativa:** media; aclaraciones visuales pueden condicionar cierre.

### F005-B4: cuatro escenarios y evidencia integrada de calidad

- **Objetivo:** verificar las dos AC mediante los cuatro escenarios, negativos adicionales y
  conservación de estado, desde bandeja F004 hasta consulta del empleado F003.
- **Dependencias:** B1/B2/B3 y sus prerrequisitos reales; F003-B3 y F004-B3 para recorrido UI;
  T-04/T-06/T-07 operativas y puertas compartidas aplicables concretadas. Evidencia/respuestas
  aclaradas para los caminos bajo aceptación; no es necesario entregar F006/F007.
- **Componentes/rutas propuestas:** suites comunes de integración/arquitectura y `src/frontend/e2e/`.
  Sin endpoints nuevos para cambiar estado o crear identidades solo para pruebas.
- **Entregables:** trazabilidad de los cuatro Gherkin a pruebas ejecutables, matriz de resultados y
  gates, negativos del empleado/no asignado/estados finales e informe de caminos bloqueados.
- **Pruebas:** P-01–P-06 end-to-end con registro real: aprobar desde F004 y leer Aprobada en F003;
  empleado ajeno sin datos, responsable no asignado/propietario solo Empleado sin escritura,
  inexistente sin decisión y cada estado final inalterado. P-07 con intercalados reproducibles según
  la garantía acordada; no inventar resultado exacto de competidores simultáneos. P-08/P-09 solo
  alcanzan aceptación completa cuando su comportamiento sea definido, no mediante placeholders.
- **Documentación:** comandos realmente ejecutados, resultados por escenario/AC, evidencia de
  registro/lectura y gaps de concurrencia/actualización. Revisión personal, sin sign-off de negocio.
- **Criterio de salida:** AC-01/02 y cuatro escenarios comprobados con dependencias reales;
  negativos obligatorios satisfactorios y gates pasados. T-07 sin cerrar o caminos sin especificar
  impiden declarar UC-005 completo; no ocultar pendientes detrás de porcentajes o un happy path.
- **Quality gates:** G íntegro: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración/E2E,
  arquitectura y scans sin críticos; alcance y bloqueos documentados.
- **Estimación orientativa:** media/alta, condicionada a integración y aclaraciones.

## 7. Quality gates comunes (G)

- Build y lint/format, cobertura unitaria ≥80 % y mutación ≥60 % sobre el alcance medido de aplicación
  acordado; reportar pruebas del código afectado sin rebajar el umbral ni sustituir negativos por cobertura.
- Integración y arquitectura en las fronteras afectadas. B1 aislado no acredita T-04/T-06/T-07; probar
  cada condición de autorización/estado en la entrada real, no solo mediante componentes de UI.
- Scans de seguridad/dependencias sin críticos y construcción/escaneo de contenedor sin críticos al
  existir imagen. Gate no disponible: registrar bloqueo o no aplicabilidad justificada, nunca «pasado».
- Reutilizar reproducibilidad Podman/GitHub Actions de F001. Pruebas de no regresión: F001 sigue
  creando Pendiente con FR-006; F003 sigue leyendo propios de los cuatro estados sin escribir;
  F004 solo devuelve Pendiente asignadas, sin convertir permiso de lectura en permiso de decidir.
- Negativos mínimos: responsable no asignado, propietario solo Empleado, Aprobada/Rechazada/Retirada
  e inexistencia; comprobar estado/registro además de payload y DOM. Una política de UI no es SEC-001.
- Propuesta: correlacionar aprobar/registro/consulta mediante OpenTelemetry hacia Azure sin contenido
  personal o comentarios en telemetría. No añadir historial detallado, retención, alertas, métricas
  objetivo o declaración de cumplimiento. Auditoría de decisión permanece abierta Q-015/Q-016.

Estos son gates de la futura implementación, no controles ya ejecutados sobre código en esta entrega.

## 8. Preguntas abiertas, soporte incompleto y riesgos

| Fuente | Cuestión sin resolver | Tratamiento / bloqueo |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-013/Q-014 | Fuente, propiedad y cambios de asignación; capacidad de decidir | T-04/T-06 heredadas; no escoger IdP/modelo de autorización ni administrar asignaciones. B2/B4 no se cierran con actores/ámbitos fake. |
| LAB-OQ-006; Q-003/Q-004/Q-023/Q-024; UC-005 3a | Estado cambiado, decisiones competidoras, retirada y efectividad de decisión | T-07 funcional/técnica pendiente. Solo restricción no Pendiente → no aprobar; sin ganador, bloqueo, versionado, idempotencia o mensajes seleccionados. |
| LAB-OQ-007 en F005; Q-011 | Comentario de decisión y su obligatoriedad | No añadir campo, validación o requisito de motivo. En baseline LAB-OQ-007 se refiere al rechazo; en F005 se amplía al comentario de aprobación. No corregir ni reinterpretar las fuentes como respuesta. |
| LAB-OQ-006; Q-004 | Reapertura, reversión o decisión más de una vez | No se implementan salidas de estados finales. Esto no resuelve la política definitiva ni la respuesta a repetición. |
| LAB-OQ-008; Q-013/Q-015/Q-016 | Autenticación, privacidad, evidencia de quién/cuándo, auditoría y retención | Reutilizar mecanismo acordado en T-04; no inventar historial, campos de decisión ni normativa aplicable. |
| Q-004/Q-014/Q-022/Q-024; UC-005 4a/6a | Qué acredita registro efectivo, fallo incierto y estado actualizado | B2/B4 condicionados para esos caminos. No prometer consistencia inmediata, polling, push, retry, rollback ni tiempo de propagación. |
| Q-005/Q-011/Q-021/Q-024 | Datos visibles, respuestas y contenido de confirmación/error | Mockups provisionales; no equiparar no autorizado, inexistente, no Pendiente y fallo de registro por disponer de un único error. |
| Q-019/Q-022/Q-025 | NFR y evidencia/autoridad de aceptación | Sin targets ni sign-off ficticio. LAB-HYP permanece Draft aunque pasen pruebas técnicas. |
| F001/F003/F004 planificados, no acreditados como implementados | Confundir referencia con dependencia entregada | Revisar base/fronteras de origen al ejecutar. B1/B3 pueden ser aislados; integración exige componentes reales. |

La concurrencia se registra expresamente por este encargo en el contexto de LAB-OQ-006/007; la
evidencia directa de su comportamiento no definido procede de UC-005 y Q-024. LAB-OQ-007 no pasa a
ser una definición de concurrencia ni se da por resuelta su pregunta de comentario. LAB-OQ-005 sigue
abierta y fuera del alcance, sin impacto en saldo inferido de una aprobación.

## 9. Fuentes y seguimiento

- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md) y [clarificaciones](../../clarification-summary.md).
- [Requisitos F005](../requirements/requirements.md), [UC-005](../requirements/use-cases/UC-005.md), [cuatro Gherkin](../tests/approve-vacation-request.feature), [modelo de estados](../requirements/state-model.md) y [mockups](../mockups/README.md).
- [Dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).
- [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [puertas T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: plan](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [F004: plan](../../lab-004-view-assigned-pending-requests/planning/plan.md) y [T-06](../../lab-004-view-assigned-pending-requests/planning/research.md).
- [UC-006](../../lab-006-reject-vacation-request/requirements/use-cases/UC-006.md), [UC-007](../../lab-007-withdraw-pending-vacation-request/requirements/use-cases/UC-007.md) y [AC-LAB-F007-02](../../lab-007-withdraw-pending-vacation-request/requirements/requirements.md), como contexto recogido en el modelo de estados; no como alcance implementado.

El comentario solicitado para #4 está preparado en [research.md](research.md#6-comentario-preparado-para-el-issue-4),
no publicado: no hay herramienta de escritura en GitHub disponible en esta sesión. No se modifica el
cuerpo ni el estado del issue, ni se crea otro work item. Los enlaces remotos del comentario son
previstos hasta publicar los archivos; no se ha solicitado commit/push. No se continúa automáticamente
con tasks, Gherkin adicional, implementación, contratos o Azure DevOps.