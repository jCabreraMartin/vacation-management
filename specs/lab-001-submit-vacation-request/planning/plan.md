# Plan técnico: LAB-F001 — Presentar una solicitud de vacaciones

**Estado:** Draft / LAB-HYP. Plan de un laboratorio personal, no aprobado por un negocio real.  
**Escenario:** fullstack (backend, frontend y cloud-platform).  
**Issue:** [#1](https://github.com/jCabreraMartin/vacation-management/issues/1).  
**Rama comprobada:** `feature/vacation-management-lab-catalog`, mediante la referencia de `.git/HEAD`, antes de planificar. No se crea ni cambia ninguna rama.  
**Estimación:** cinco Bolts propuestos, con complejidad relativa inicial; no se fijan fechas, duraciones ni compromisos.  
**Resultado de esta entrega:** únicamente este plan y [research.md](research.md). No se inicia implementación, investigación externa, generación de tareas ni contratos.

## 1. Objetivo y límites

Dar al Empleado un flujo para introducir fecha inicial, fecha final y comentario opcional, enviar la
solicitud, registrarla inicialmente como `Pendiente` y recibir confirmación. Se conserva la trazabilidad
a US-LAB-F001-01, FR-001, BR-001 (parcial), SEC-001 y AC-LAB-F001-01/02.

LAB-F002 es la capacidad de validación **interna al flujo de presentación**: se comprueba presencia de
ambas fechas y se rechaza fecha final anterior a inicial (FR-006, UC-002). No se requiere entregar o
aprobar LAB-F002 antes de iniciar LAB-F001; no se crea una dependencia circular ni un servicio separado
de validación. Sus escenarios se reutilizan como evidencia de esta capacidad, sin mantener otra copia.

### Incluido

- Captura de los tres campos expresos; omitir el comentario es una variante válida del flujo.
- Registro del comentario cuando se aporta, junto a la solicitud con estado inicial `Pendiente`.
- Rechazo de fechas ausentes o intervalo invertido, comunicando error y sin crear una solicitud pendiente.
- Presentación visual de inicio, envío en curso, errores FR-006 y confirmación; los textos siguen pendientes.
- Vinculación conceptual entre empleado y solicitud para respetar SEC-001, sin elegir identidad ni autorización.
- Pruebas aisladas, de integración y de extremo a extremo para el alcance expresamente definido.

### Excluido

No se incluyen consultas/listados de LAB-F003, asignación/bandeja de LAB-F004, aprobación de LAB-F005,
rechazo de LAB-F006 ni retirada de LAB-F007. No se implementan estados ni transiciones posteriores a
`Pendiente`, administración de personas, saldo de días, festivos, fines de semana, solapamientos, límites
de duración, aprobación, reintentos, notificaciones, integraciones o políticas de conservación.

No se selecciona base de datos, ORM, API style, protocolo, proveedor de identidad, modelo de
autorización ni plataforma cloud. Tampoco se define ahora un identificador de solicitud, longitud de
comentario, formato de fechas o respuesta de fallos no respaldada.

## 2. Evidencia y trazabilidad

| Fuente | Comportamiento que guía el plan | Pruebas propuestas / límite |
| --- | --- | --- |
| BR-001 (parcial), FR-001; US-LAB-F001-01; AC-LAB-F001-01; UC-001 pasos 1–5 | Presentar fechas y registrar `Pendiente`, con confirmación | Escenario de [presentación sin comentario](../tests/submit-vacation-request.feature), integración de registro y comprobación de respuesta visible. No cubre el flujo de decisión de BR-001 completo. |
| FR-001; AC-LAB-F001-02; UC-001 extensión 2a | Comentario opcional, asociado si se proporciona | Segundo escenario del mismo Gherkin; comprobar valor conservado y asociación a la solicitud, sin reglas adicionales de longitud o normalización. |
| FR-006; US-LAB-F002-01; AC-LAB-F002-01; UC-002 extensiones 2a/2b | Falta una fecha: error y ninguna solicitud pendiente creada | Reutilizar [Gherkin de F002](../../lab-002-validate-vacation-date-range/tests/validate-vacation-date-range.feature): ausencia inicial y ausencia final; prueba aislada adicional de ambas ausentes, derivada de la misma regla. |
| FR-006; AC-LAB-F002-02; UC-002 extensión 2c | Fin anterior al inicio: error y ninguna solicitud pendiente creada | Prueba del intervalo invertido y comprobación de ausencia de escritura en la frontera de registro. |
| SEC-001; UC-001 requisitos especiales | La solicitud se asocia al ámbito del empleado | Pruebas con contexto de actor controlado en el caso de uso; verificación de identidad real bloqueada hasta resolver Q-013. No se introduce un campo de propietario editable en el formulario. |
| UC-001 garantía mínima y variaciones tecnológicas | No hay resultado especificado para fallo técnico de registro | Gap Q-024: no se inventa una respuesta, retry, compensación ni resultado persistido. |
| Q-002, Q-009, Q-010, Q-011, Q-020 | Fechas aceptadas, error comprensible, confirmación y contenido incompletos | Se verifica solo la parte observable ya definida; no se declara aceptación completa de estos puntos con placeholders. |

El Gherkin actual es documentación BDD, no prueba ejecutada ni aceptación aprobada. Su precondición de
fechas presentes y fin no anterior no resuelve todas las políticas abiertas de calendario. No se
aceptan ni rechazan esas otras políticas por inferencia.

## 3. Constitución y decisiones

Se aplican las decisiones enumeradas como aprobadas en la [constitución canónica](../../../.boltf/memory/constitution.md)
y su [digest](../../../.boltf/memory/constitution.digest.md); ejemplos y casillas sin marcar no son vinculantes.

| Decisión o restricción | Aplicación a LAB-F001 | Estado |
| --- | --- | --- |
| C#/.NET 8 y Angular (versión no especificada) | Backend y formulario sobre ese stack | Vinculante; versión Angular pendiente antes de iniciar el proyecto frontend. |
| Podman local; configuración por archivos y .NET User Secrets local; sin feature flags | Reproducir entorno y separar secretos de archivos versionados | Vinculante; no se prescribe Compose, Aspire ni un servicio cloud. |
| GitHub Actions y GitHub Flow; GitHub Projects | Gates CI y trazabilidad con #1; no usar Azure DevOps | Vinculante; sin creación de tareas ni ramas en esta entrega. |
| Cobertura unitaria ≥80 %, mutación ≥60 %; build/lint, integración y pruebas de arquitectura; security/container scans sin críticos | Evidencia por cada Bolt aplicable y consolidación final | Vinculante. No se hereda 70 % de mutación de ejemplos genéricos. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en una eventual entrega desplegable | Vinculante, pero el despliegue no es necesario para revisar reglas o UI aisladas; sin IaC en esta feature mientras no exista target confirmado. |
| OpenTelemetry hacia Azure; Resource Health y Activity Logs | Proponer trazas del envío y registro en la integración; monitorización de infraestructura si se habilita | Destino vinculante; exporter/configuración y acceso al entorno pendientes. Sin SLO inventado. |
| VNet, Private Endpoints, WAF; claves administradas por Azure y PII cifrada | Mantener restricciones para el diseño del entorno Azure | No sustituir por controles elegidos aquí. Clasificación de datos y despliegue pendientes. |
| GDPR/HIPAA seleccionados en inicialización | Conservar la restricción y aclarar alcance | No se declara cumplimiento; Q-015/Q-016 pendientes antes de uso con datos reales. |
| Trigger dev en `develop` frente a GitHub Flow | No configurar despliegue automático contradictorio | Pendiente; bloquea automatización dev, no reglas aisladas. |
| Estilo arquitectónico/API, almacenamiento, identidad y autorización | No seleccionar alternativas de plantilla | Pendientes; ver puertas de entrada en cada Bolt y [registro técnico](research.md). |

La arquitectura propone monolito modular, SPA y puertos. Este plan los usa como **descomposición lógica
provisional**, no como arquitectura ratificada ni como agregado/entidad DDD confirmado. No añade CQRS,
event sourcing, broker, eventos de dominio ni servicios distribuidos.

La configuración vigente de ámbitos declara `design-tool: none`: el gate Penpot no está activo. Los
seis HTML existentes son referencias visuales; no existe evidencia de aprobación de diseño ni de una
verificación visual de accesibilidad completa.

## 4. Áreas afectadas y diseño propuesto

Los directorios `src/backend/` y `src/frontend/` existen y están vacíos. Todas las rutas de archivos o
subdirectorios de aplicación que siguen son **propuestas no existentes**, sujetas a la base técnica
acordada; no constituyen una lista de tareas ni un scaffold generado.

| Área | Ruta propuesta, no existente | Responsabilidad / límite |
| --- | --- | --- |
| Formulario Angular | `src/frontend/src/app/vacation-requests/submit-request/` | Dos fechas, comentario opcional, acción de enviar y estados visuales; sin navegación a F003 ni campos adicionales. |
| Frontera frontend de presentación | `src/frontend/src/app/vacation-requests/data-access/` | Separar representación y transporte. Tipo/formato de fechas, cliente y protocolo pendientes. Un doble solo sirve para pruebas, no como registro real. |
| Reglas de la solicitud | `src/backend/VacationManagement.Domain/VacationRequests/` | FR-006 y estado inicial Pendiente; no imponer identidad técnica ni clasificación DDD definitiva. |
| Caso de uso de presentación | `src/backend/VacationManagement.Application/VacationRequests/Submit/` | Recibir datos y contexto de empleado, validar, registrar y entregar resultado confirmado; sin elegir dispatcher/CQRS. |
| Entrada del backend | `src/backend/VacationManagement.Api/` | Exponer una operación de presentar tras decidir API style; sin rutas HTTP, verbos, DTO definitivos ni códigos de respuesta fijados aquí. |
| Adaptación de registro | `src/backend/VacationManagement.Infrastructure/VacationRequests/` | Implementar el registro con tecnología por decidir; pruebas con el adaptador elegido, sin esquema ni migración propuestos ahora. |
| Pruebas backend | `tests/VacationManagement.UnitTests/` y `tests/VacationManagement.IntegrationTests/` | Regla y caso de uso aislados; integración del registro/entrada cuando se decidan. |
| Pruebas de arquitectura y E2E | `tests/Architecture.Tests/` y `src/frontend/e2e/` | Límites acordados y recorridos UI integrados; herramientas/versiones por verificar, no seleccionadas por plantilla. |

### Flujo técnico propuesto

1. El formulario recoge exclusivamente fechas inicial/final y comentario opcional. Se propone un
   formulario tipado y validación de presentación equivalente a FR-006, sin elevarla a autoridad única.
2. El adaptador de entrada entrega los datos y el contexto de empleado al caso de uso, con el mecanismo
   de identidad todavía pendiente. No se toma la identidad del contenido libre del formulario.
3. El backend vuelve a comprobar FR-006 antes de cualquier registro. La regla permanece dentro del
   flujo; no se crea endpoint ni dependencia desplegable para LAB-F002.
4. Si la entrada incumple FR-006, no se invoca el registro; se comunica error, con contenido exacto por
   concretar. No se establece un código o transporte técnico definitivo.
5. Si supera las condiciones conocidas y las decisiones aplicables se han concretado, el caso de uso
   registra solicitud, comentario si existe, relación de pertenencia y estado inicial `Pendiente`.
6. La UI representa confirmación únicamente tras resultado de registro confirmado. El estado loading
   es de presentación, no un estado de dominio ni prueba de un trabajo en background.

No se fija representación temporal (p. ej., fecha de calendario frente a timestamp), transformación,
zona horaria, identificador, normalización del comentario ni persistencia en memoria como sustitución
de producción. Tampoco se afirma atomicidad, idempotencia o rollback: sus garantías requieren resolver
la semántica y comprobar la tecnología elegida.

## 5. Referencias visuales y cobertura de estados

Se han leído el [README](../mockups/README.md), el [CHANGELOG](../mockups/CHANGELOG.md) y todos los HTML
enlazados. El CDN Tailwind v4 de los wireframes no selecciona por sí mismo la librería de estilos de
la futura aplicación Angular.

| Mockup leído | Área que materializa | Bolt / comprobación |
| --- | --- | --- |
| [Default](../mockups/submit-vacation-request-step1-default.html) | Captura de dos fechas y comentario opcional | B3: labels, foco, campos y acción; B5: envío sin comentario y con comentario. |
| [Loading](../mockups/submit-vacation-request-step1-loading.html) | Feedback de envío, con texto pendiente | B3: representación bajo respuesta controlada; B5: espera real sin simular éxito. Bloqueo de controles/reintentos no decidido. |
| [Error sin fecha inicial](../mockups/submit-vacation-request-step1-missing-start-error.html) | FR-006, asociación campo-error | B2: ausencia inicial sin registro; B3: aria-invalid/describedby; B5: validación integrada. |
| [Error sin fecha final](../mockups/submit-vacation-request-step1-missing-end-error.html) | FR-006, asociación campo-error | B2: ausencia final sin registro; B3 y B5: mismo comportamiento visible, sin inventar mensaje. |
| [Error intervalo invertido](../mockups/submit-vacation-request-step1-inverted-range-error.html) | FR-006, fin anterior al inicio | B2, B3 y B5; no aplicar límites min/max adicionales del calendario. |
| [Success](../mockups/submit-vacation-request-step1-success.html) | Confirmación y estado Pendiente | B3: representación aislada, no prueba de registro; B4/B5: estado realmente registrado antes de confirmar. |

`empty` no aplica al formulario: campos sin completar pertenecen a default. El mockup loading tiene
campos en blanco; eso no decide si se conservan, bloquean o reinician valores durante/después de enviar.
Q-010/Q-024 y la revisión UX deben resolver ese comportamiento si se necesita implementarlo. No se
crea una pantalla de fallo de infraestructura a partir del error de validación.

## 6. Secuencia de Bolts propuesta

Cada Bolt tiene un resultado revisable por separado, con pruebas y documentación propias. La
secuencia es B1 → B2 → B3 → B4 → B5; B3 puede revisarse con un doble después de B1 si se acuerda
separarlo de B2, sin considerarlo una feature operativa. No se crean ramas, issues de Bolt ni tareas.
Los futuros nombres de rama deberán seguir la estrategia GitHub Flow del repositorio, no ejemplos
genéricos de la skill. Las referencias B1–B5 son unidades de planificación, no trabajo iniciado.

### B1 — Base mínima para el flujo

- **Objetivo:** habilitar construcción y pruebas aisladas de backend .NET 8 y frontend Angular, sin
  asumir una foundation ya implementada (fases 4–5 del roadmap).
- **Dependencias y entrada:** stack vinculante; decidir versión Angular/toolchain y aceptar estructura
  mínima. API, base de datos e identidad real no son necesarias para compilar pruebas aisladas.
- **Entregables:** base ejecutable de prueba/build, configuración local sin secretos en Git y fronteras
  mínimas de la feature. Sin una plataforma común nueva para features ajenas.
- **Pruebas:** build/lint; prueba de arranque de cada base y pruebas estructurales de las fronteras
  aceptadas. No simular cobertura de negocio con código sin reglas.
- **Documentación:** reproducibilidad de herramientas y comandos reales elegidos, decisiones que
  continúan abiertas y límites de la base respecto al roadmap.
- **Salida:** ambos proyectos construibles, comandos reproducibles y revisión de límites; ninguna
  dependencia técnica se presenta como decidida sin acuerdo. Sin despliegue.
- **Orientación:** complejidad media, incertidumbre de toolchain. No es estimación de duración.

### B2 — Validación FR-006 y presentación aislada

- **Objetivo:** probar el caso de uso con sus reglas conocidas, registro inicial Pendiente y comentario
  opcional, sin adaptador de almacenamiento real.
- **Dependencias y entrada:** B1 y una representación de fechas acordada para el slice. Contexto de
  actor y registro pueden controlarse mediante dobles de prueba claramente identificados.
- **Entregables:** reglas FR-006 invocadas por presentación; caso de uso aislado y frontera de registro
  propuesta. No seleccionar un patrón de repositorio global, agregado o proveedor de identidad.
- **Pruebas:** ausencia inicial/final/ambas e intervalo invertido no invocan el registro; sobre entrada
  que cumple las condiciones conocidas, el doble recibe datos, comentario si se aporta, pertenencia
  del actor controlado y estado Pendiente. Verificar los dos escenarios F001 y los tres de F002 como
  especificación de pruebas, no duplicarlos en otra feature.
- **Documentación:** matriz AC/UC/pruebas aisladas y límites de los dobles; representación de fechas
  aceptada y cualquier pregunta de calendario que continúe abierta.
- **Salida:** reglas y orquestación verificadas sin tecnología persistente; no se declara implementado
  el registro real ni aceptado el AC completo con evidencia de un doble.
- **Orientación:** complejidad media; limitada a FR-006, no una entrega previa de LAB-F002.

### B3 — Formulario y estados de presentación

- **Objetivo:** representar el flujo de US-LAB-F001-01, sus variantes y los seis mockups de la sección 5.
- **Dependencias y entrada:** B1; semántica de fechas compatible con B2; se propone consumir una
  frontera de presentación controlada en pruebas hasta que B4 aporte la integración.
- **Entregables:** campos asociados a etiquetas, comentario opcional, acción de enviar, estados
  default/loading/error/success y asociación de errores a campos; sin nueva navegación ni colecciones.
- **Pruebas:** componente con/sin comentario; tres casos FR-006; loading y éxito bajo resultados
  controlados; teclado/foco y referencias accesibles; layout móvil y escritorio. No fijar texto exacto
  ni valores de timeout. E2E con dobles se identifica como prueba de UI, no de persistencia.
- **Documentación:** correspondencia UI/HTML/AC y lista de TODO(content). Acordar mensajes antes de
  evaluar “error comprensible”; no sustituirlo por una aserción a un placeholder.
- **Salida:** estados cubiertos en pruebas de componente, equivalencia con FR-006 y revisión visual;
  gaps de contenido visibles. Si los mensajes no están aclarados, es salida parcial, no aceptación final.
- **Orientación:** complejidad media; sin promesas sobre recuperación o bloqueo de controles.

### B4 — Registro e identidad integrados, condicionados a decisiones

- **Objetivo:** sustituir los dobles por el registro y la entrada reales de presentación, sin incorporar
  funciones de consulta/decisión/retirada de otras features.
- **Dependencias y entrada:** B1/B2/B3; decidir almacenamiento/acceso a datos, API style/protocolo,
  semántica de fechas, identificación/pertenencia y autorización aplicable. Resolver qué constituye
  registro confirmado y qué respuesta ofrecer si no se puede confirmar. Son puertas pendientes, no defaults.
- **Entregables:** adaptadores de entrada y registro, vinculación del actor a su solicitud, comunicación
  frontend/backend y confirmación tras registro. Operación de presentación solamente, sin CRUD extra.
- **Pruebas:** entrada inválida enviada directamente al backend no crea solicitud pendiente; entrada
  aceptable guarda fechas/comentario/estado/pertenencia; UI no da éxito sin resultado confirmado;
  integración con almacenamiento real elegido y contexto de identidad acordado. Comprobar seguridad
  según reglas confirmadas sin inventar login o respuestas para identidad ausente.
- **Documentación:** condiciones de ejecución local con Podman, configuración/User Secrets, límites
  de registro y decisiones concretadas; acceso a telemetría OpenTelemetry hacia Azure sin datos sensibles.
- **Salida:** AC-LAB-F001-01/02 y FR-006 comprobables contra el registro real; identidad no tomada de
  un campo editable; integración revisada y resultados documentados. Si faltan decisiones de entrada,
  B4 permanece bloqueado; un almacén fake no permite declararlo terminado.
- **Orientación:** complejidad alta por decisiones pendientes, no por una base de datos elegida.

### B5 — Verificación completa y evidencia de calidad

- **Objetivo:** demostrar el flujo de extremo a extremo y sus límites, sin hacer de F003 un requisito
  previo para inspeccionar el resultado guardado.
- **Dependencias y entrada:** B4 integrado y comportamiento/mensajes acordados para los criterios a
  evaluar. Las pruebas pueden verificar el registro mediante fixtures, no creando un endpoint de consulta.
- **Entregables:** automatización de los dos escenarios de F001 y los tres de F002, trazabilidad de
  integración/UI, evidencia de quality gates y registro de cobertura incompleta por preguntas abiertas.
- **Pruebas:** recorrido móvil/escritorio; comentario omitido/asociado; sin fechas e intervalo invertido;
  comprobación de registro Pendiente y confirmación; pruebas de arquitectura y scans aplicables.
  La herramienta BDD/E2E se confirma antes de automatizar; no se genera código aquí.
- **Documentación:** comandos realmente ejecutados, resultados y gaps, sin afirmar aprobación de
  negocio ni conformidad regulatoria. Diferenciar prueba aislada, integración y aceptación del laboratorio.
- **Salida:** todas las aserciones implementadas tienen fuente, todos los gates aplicables pasan y
  cada gap bloqueante se resuelve explícitamente o impide declarar la feature completa. No se oculta
  cobertura ausente detrás de porcentajes globales.
- **Orientación:** complejidad media; revisión visual y contenido pueden condicionar el cierre.

## 7. Gates comunes y seguridad

- Por cada Bolt con código: build y lint/format, pruebas unitarias, integración y arquitectura que
  apliquen; cobertura unitaria ≥80 % y mutación ≥60 % sobre el alcance acordado del código de la
  aplicación. No se cambian umbrales por falta de infraestructura o por tratarse de laboratorio.
- Security scans y escaneos de imagen: cero críticos; container build/scan al existir imagen.
  Si un gate aún no puede ejecutarse, registrar el motivo y la puerta pendiente, no anotarlo como aprobado.
- Las pruebas y configuración deben ser reproducibles localmente con Podman y en GitHub Actions,
  según el gate correspondiente. No se provisiona Azure ni se altera CI existente en esta entrega.
- SEC-001 y la pertenencia se evalúan en backend como propuesta, sin asumir proveedor/modelo de
  autorización. Una UI que oculta acciones no prueba el control de acceso.
- Proponer trazas del envío/registro con OpenTelemetry hacia Azure sin comentario ni fechas personales
  en logs. Retención, exporter, alertas, clasificación PII y acceso al entorno quedan pendientes.
- No se afirma GDPR/HIPAA satisfecho; no utilizar datos personales reales antes de determinar
  clasificación, seguridad y obligaciones aplicables. No añadir metas de latencia, SLA o capacidad.

## 8. Dependencias, bloqueos y riesgos

| Tema | Dónde bloquea | Tratamiento sin ampliar alcance |
| --- | --- | --- |
| Foundation aún vacía | B1 | Incluir base mínima como parte revisable; no presuponer infraestructura ya desplegada ni una feature adicional previa. |
| LAB-F002 / FR-006 | B2, B3 y B5 | Capacidad consumida en presentación, sin dependencia de secuenciación; una sola regla backend y equivalencia UI, Gherkin fuente reutilizado. |
| Versión Angular/toolchain | B1 frontend | Decisión técnica pendiente T-01 en research; no fijar una versión por plantilla. |
| Fechas y conjunto de entradas aceptadas (LAB-OQ-002/004; Q-002/020) | Representación en B2/B3 y aceptación completa B5 | Concretar semántica/representación; no inferir aceptación del mismo día, festivos, pasadas o solapamientos. No ampliar FR-006. |
| API y persistencia sin decidir | B4 | Puertas T-02/T-03; dobles solo para B2/B3. No crear contratos/DDL en esta entrega. |
| Identidad, autorización y pertenencia (LAB-OQ-008; Q-013/014) | B4 y cierre SEC-001 en B5 | Puerta T-04, sin proveedor elegido. Asignación de responsables no es necesaria para presentar; queda para F004–F006. |
| Error comprensible/confirmación/comentario (Q-009/010/011) | Contenido final B3 y aceptación B5 | Mantener TODO(content); acordar el criterio verificable sin inventar texto, canal o longitud. |
| Fallo de registro y reenvío (Q-024) | B4 resiliencia y B5 de ese error | Definir resultado incierto y recuperación antes de automatizar; no prometer atomicidad, idempotencia ni reintentos. |
| Mockups estáticos: loading vacío, botón representativo | B3/B5 | No inferir retención/reset de campos, bloqueo ni tiempos; revisar con autor del ejercicio. |
| Sin NFR (LAB-OQ-010; Q-019) | Evaluación NFR, no pruebas aisladas | No fijar objetivos. No declarar rendimiento/producción validados. |
| Trigger `develop` / GitHub Flow; plataforma sin elegir | Solo automatización de despliegue | No bloquea plan/reglas/UI; no crear Terraform ni activar CD para resolverlo dentro de F001. |
| F003–F007 consumen solicitudes a futuro | Fuera de esta entrega | No depender de su implementación. No crear listados, endpoints o estados adicionales para probar F001. |

El saldo LAB-OQ-005, “En revisión”, asignación/cardinalidad, motivos de decisión, integraciones y
retención siguen abiertos, pero no se convierten en investigaciones técnicas necesarias para este
slice de presentación. No hay jobs ni consumidores asíncronos evidenciados que exijan cobertura BDD nueva.

## 9. Fuentes y estado de publicación

- [Roadmap general](../../../docs/roadmap/implementation-roadmap.md), fases 2–6 y 9: orientación, no foundation existente.
- [Baseline LAB-HYP](../../lab/requirements-baseline.md) y [aclaraciones](../../clarification-summary.md).
- [Requisitos F001](../requirements/requirements.md), [UC-001](../requirements/use-cases/UC-001.md), [Gherkin F001](../tests/submit-vacation-request.feature).
- [Requisitos F002](../../lab-002-validate-vacation-date-range/requirements/requirements.md), [UC-002](../../lab-002-validate-vacation-date-range/requirements/use-cases/UC-002.md), [Gherkin F002](../../lab-002-validate-vacation-date-range/tests/validate-vacation-date-range.feature).
- [Modelo conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [propuesta arquitectónica](../../../docs/design/architecture/architecture-overview.md).
- [Mockups F001](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md), seis HTML enlazados en sección 5.
- [Investigaciones y decisiones pendientes](research.md).

Estos documentos se generan localmente. Su enlace remoto no implica que estén publicados: no se
solicita commit ni push. La actualización del issue #1 debe indicar esta limitación y preservar su
contenido/estado; si la herramienta autenticada no está disponible, se informará como sincronización
pendiente, nunca como realizada. No se crean otros work items ni se usa Azure DevOps.