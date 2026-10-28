# Plan técnico: LAB-F003 — Consultar solicitudes propias de vacaciones

**Estado:** Draft / LAB-HYP. Laboratorio personal; sin validación de negocio ni de producción.  
**Escenario:** fullstack, con alcance de consulta backend y UI; sin aprovisionamiento cloud en esta entrega.  
**Issue:** [#2](https://github.com/jCabreraMartin/vacation-management/issues/2).  
**Rama verificada antes de planificar:** `feature/vacation-management-lab-catalog`, según `.git/HEAD`. No se crea ni cambia ninguna rama.  
**Estimación inicial:** cuatro Bolts propios, de complejidad relativa media/alta; orientación, no fechas ni compromisos.  
**Entregables actuales:** este documento y [research.md](research.md). Sin código, tareas, contratos ni cambios en las fuentes.

## 1. Objetivo, evidencia y límites

Permitir al Empleado consultar la lista y el detalle de sus solicitudes, incluido el estado actual,
conforme a FR-002, SEC-001, US-LAB-F003-01, AC-LAB-F003-01/02 y UC-003. La regla principal es que el
empleado nunca reciba datos de solicitudes ajenas, tanto en la lista como en un acceso directo al detalle.

Se distinguen decisiones vinculantes de la constitución, comportamientos Draft de las especificaciones,
propuestas técnicas de este plan y preguntas abiertas. El monolito modular, las capas y los puertos de la
arquitectura son propuestas, no decisiones constitucionales ni clasificaciones DDD confirmadas.

### Alcance de lectura

- Lista de solicitudes del empleado actual, selección de una solicitud propia y visualización del detalle/estado.
- Acceso limitado en backend por pertenencia; una URL o selección manipulada no otorga acceso a otra persona.
- Lectura del estado almacenado entre `Pendiente`, `Aprobada`, `Rechazada` y `Retirada`, sin cambiarlo.
- Representaciones de lista default/empty/loading/error y detalle default/error, con las limitaciones de la sección 5.
- Pruebas positivas y negativas de propiedad, separadas por nivel: aisladas, integración y extremo a extremo.

El Empleado es el único actor de este flujo. No se incluye la bandeja del responsable, administración
de asignaciones, modificación de solicitudes, decisiones, retirada ni sus acciones en la UI. F005/F006/F007
consumirán esta consulta para ver sus resultados; no son prerrequisitos de entrega de F003. Las pruebas
con estados distintos de Pendiente usarán fixtures o dobles identificados, sin implementar transiciones.
`En revisión` no es un estado del modelo y no se añade a la consulta.

No se inventan periodo, filtros, búsqueda, paginación, ordenación, columnas, identificadores visibles,
campos nuevos, motivos, textos de error, retención, caché, reintentos, actualización en tiempo real ni
objetivos NFR. Se mantiene la semántica abierta del recurso inexistente frente al acceso ajeno.

## 2. Base común y decisiones heredadas

### Reutilización sin duplicación

La base técnica se consume desde [F001-B1](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo).
Su existencia como plan no significa que esté implementada. F003 no crea otra foundation, solución,
pipeline o configuración de herramientas. Los Bolts propios se nombran `F003-B1` a `F003-B4` para no
confundirlos con los de F001.

Las únicas definiciones de T-01–T-05 permanecen en el
[registro técnico de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar).
Su aplicación al flujo de lectura se describe allí por referencia, sin copiar ni cerrar sus decisiones.

| Referencia heredada | Uso en F003 y condición de entrada |
| --- | --- |
| F001-B1 / T-01 | Reutilizar proyectos y toolchain; backend para F003-B1 y frontend para F003-B3. No presuponer versión Angular. |
| T-02 | Condiciona entrada/salida real de lista y detalle en F003-B2; ningún endpoint, verbo o código de respuesta se selecciona aquí. |
| T-03 | Condiciona lectura real de lo registrado por F001-B4 y localización de solicitudes; no crear otro almacén o modelo persistente. |
| T-04 | Condiciona identidad/pertenencia reales en F003-B2 y su verificación en F003-B4. En F003-B1 solo se usa contexto de actor controlado en pruebas. |
| T-05 | Reutilizar la representación de fechas acordada por F001 cuando se expongan los datos ya respaldados; no introducir conversión o reglas propias. |

No se añaden T-06 ni otras puertas técnicas en esta revisión: las elecciones técnicas necesarias
pertenecen a las puertas anteriores. Los campos visibles, estados vacíos, respuestas de error y NFR
son aclaraciones funcionales pendientes, no tecnologías que este plan pueda seleccionar.

### Constitución aplicable

Fuente: [digest](../../../.boltf/memory/constitution.digest.md); las alternativas de plantilla no son decisiones vinculantes.

| Decisión vinculante | Aplicación / límite |
| --- | --- |
| C#/.NET 8 y Angular sin versión especificada | Mantener stack y consumir F001-B1/T-01. No elegir framework de UI adicional. |
| Podman local, archivos de configuración y User Secrets; sin feature flags | Reutilizar entorno/configuración compartidos, no registrar secretos en Git ni crear otro orquestador. |
| GitHub Actions, GitHub Flow y GitHub Projects | Reutilizar gates y asociar documentación a #2; sin Azure DevOps ni creación de work items de Bolt. |
| Cobertura unitaria ≥80 %, mutación ≥60 %, build/lint, integración, arquitectura y scans sin críticos | Aplicación por Bolt según la sección 7. No adoptar 70 % de ejemplos genéricos. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en futuro despliegue; sin IaC ni elección de plataforma para entregar esta consulta. |
| OpenTelemetry hacia Azure; Resource Health y Activity Logs | Reutilizar instrumentación de base; proponer correlación de consultas sin exponer datos de solicitudes. Sin umbrales ni retención elegidos. |
| VNet, Private Endpoints, WAF, claves administradas por Azure y PII cifrada | No eludir restricciones; clasificación de datos y configuración de despliegue pendientes. |
| GDPR/HIPAA seleccionados | Aplicabilidad y evidencia siguen pendientes. No se declara cumplimiento del laboratorio. |

La contradicción del trigger dev en `develop` frente a GitHub Flow sigue abierta para CD; no bloquea
la lectura aislada. Base de datos, ORM, API, IdP y modelo de autorización continúan sin seleccionar.

## 3. Trazabilidad de FR/SEC a pruebas propuestas

Historia común: US-LAB-F003-01. Los dos escenarios actuales del
[Gherkin F003](../tests/view-own-vacation-requests.feature) se conservan; no se generan escenarios nuevos en esta entrega.
Los identificadores P-01–P-07 siguientes son referencias de pruebas propuestas, no tests ya creados.

| FR/SEC | AC | UC | Escenario Gherkin actual | Pruebas y evidencia previstas |
| --- | --- | --- | --- | --- |
| FR-002, SEC-001 | AC-LAB-F003-01 | UC-003 pasos 1–3 | «Consultar la lista, el detalle y el estado de solicitudes propias» (`@smoke`) | P-01: lista con registros propios y ajenos en el origen, devuelve solo los propios; sin comparar un orden no definido. F003-B1 aislado, B2 integración, B4 E2E. |
| FR-002, SEC-001 | AC-LAB-F003-01 | UC-003 paso 4 | Mismo escenario, selección del detalle | P-02: el propietario puede abrir su solicitud y ver su estado; campos limitados a la proyección respaldada/acordada. B1, B2 y B4. |
| SEC-001 | AC-LAB-F003-02 | UC-003 extensión 2a y garantía mínima | «Denegar la consulta de una solicitud ajena» (`@security`) | P-03: empleado A solicita directamente el detalle de B; denegación sin devolver campos o estado de B, incluidos payload y DOM. B1, B2 y B4. No fijar mensaje/código. |
| SEC-001, FR-002 | AC-LAB-F003-01/02 | UC-003 límite de propiedad | Refuerzo técnico de ambos escenarios, no escenario de negocio adicional | P-04: consultar como A, como B y alterar la selección no cruza ámbitos; el filtro visual no es el control. Pruebas contra el caso de uso y la entrada reales en B2/B4. |
| FR-002 | AC-LAB-F003-01 | UC-003 estado actual; baseline sección 4 | Parte «puede ver su estado actual» del primer escenario | P-05: lectura/mapeo de los cuatro estados del modelo con fixtures; no escritura ni transición. Integración inicial con F001 verifica Pendiente real; las transiciones de F005/006/007 no se implementan. |
| FR-002 | Sin AC específico completo | UC-003 extensión 3a/3b | Solo comentarios Gap, no escenario con resultado definido | P-06: representación de empty/loading/error con dobles en UI; semántica final, recuperación, mensajes y detalle inexistente bloqueados por Q-012/Q-024. No contarlos como aceptación integrada. |
| FR-002, SEC-001 | AC-LAB-F003-01/02 | UC-003 pasos 2–4 | Recorridos de ambos escenarios | P-07: una lectura no modifica datos ni estado; usar instrumentación de pruebas, no endpoints de escritura nuevos. B1/B2/B4. |

BR-001 aporta contexto parcial del flujo centralizado en la baseline; F003 no completa por sí sola el
proceso de presentación/decisión. El éxito de las pruebas no aprueba los requisitos Draft ni resuelve
Q-021/Q-025 sobre evidencia y aceptación.

## 4. Responsabilidades y áreas propuestas

Las siguientes rutas se proponen como ampliaciones de las áreas de F001, no como archivos existentes
ni scaffold generado. La separación lógica no presupone CQRS, repositorios, agregados o un ORM.

| Área | Ruta propuesta, no existente según la base de planificación | Responsabilidad |
| --- | --- | --- |
| Lectura autorizada de lista/detalle | `src/backend/VacationManagement.Application/VacationRequests/ReadOwn/` | Resolver el contexto de empleado y restringir el resultado antes de devolver datos; sin campos nuevos ni reglas de validación de presentación. |
| Lectura del registro compartido | `src/backend/VacationManagement.Infrastructure/VacationRequests/` | Ampliación del adaptador de F001, reutilizando T-03; consultar por ámbito/selección sin escoger tecnología. |
| Entrada de consulta | `src/backend/VacationManagement.Api/` | Dos capacidades lógicas: lista propia y detalle propio. T-02 decidirá exposición y referencia técnica de solicitud, no este documento. |
| Frontera frontend | `src/frontend/src/app/vacation-requests/data-access/` | Consumir resultados autorizados; no descargar solicitudes ajenas para filtrarlas en navegador. |
| Lista y detalle | `src/frontend/src/app/vacation-requests/own-requests/` | UI de solo lectura y selección; lista sin controles de filtro, búsqueda, paginación ni orden. |
| Pruebas | `tests/VacationManagement.UnitTests/`, `tests/VacationManagement.IntegrationTests/`, `tests/Architecture.Tests/`, `src/frontend/e2e/` | Reutilizar áreas de prueba de F001; fixtures separados por propietario y evidencia de aislamiento. |

### Flujo backend propuesto, anterior a la UI

1. La entrada de consulta obtiene el actor por el mecanismo que acuerde T-04. No acepta un propietario
   arbitrario indicado por la UI como prueba de autorización.
2. El caso de uso solicita lista/detalle dentro del ámbito del empleado. La condición de propiedad
   debe mantenerse en el acceso a datos y en la salida del caso de uso; no basta con ocultar filas.
3. La selección de un detalle se comprueba de nuevo en backend, aunque proceda de una lista propia;
   una referencia manipulada no devuelve ninguna información de otra persona.
4. Se construye el resultado de lectura con datos respaldados/acordados y el estado ya almacenado.
   No se escribe, recalcula ni cambia el estado. No se añade filtro por Pendiente a las consultas propias.
5. La UI representa el resultado autorizado. Denegación, ausencia de recurso y fallo técnico no se
   colapsan por decisión implícita: su respuesta externa y contenido siguen abiertos.

El detalle ilustrativo contiene fechas, comentario opcional y estado ya presentes en las fuentes.
El resumen de lista contiene placeholders de fechas y un TODO para confirmar su exposición; no se
convierte ese placeholder en una proyección definitiva. Se preserva Q-005 y no se añaden nombres,
identificadores visibles, historial, saldo, motivos ni campos de otras features.

## 5. Los seis mockups y sus límites

Se han leído todos los HTML del [índice](../mockups/README.md) y el
[CHANGELOG](../mockups/CHANGELOG.md), incluida la revisión de encabezados del 28 de octubre. Son
referencias visuales, no contratos de consulta ni prueba de que una política esté resuelta.

| Mockup | Bolt que lo materializa | Soporte y límites |
| --- | --- | --- |
| [Lista default](../mockups/own-requests-list-default.html) | F003-B3; conexión real B4 | Lista propia y estado respaldados. Datos de fechas ilustrativos; Q-005 determina proyección sin inventar columnas/orden. |
| [Lista empty](../mockups/own-requests-list-empty.html) | F003-B3 con doble; B4 condicionado | No tener solicitudes se menciona en UC-003, pero contenido/acciones y respuesta final no están definidos (Q-012). |
| [Lista loading](../mockups/own-requests-list-loading.html) | F003-B3 con demora controlada; B4 | Estado de UI durante la consulta; no un estado de dominio, timeout, SLO ni regla de reintento. |
| [Lista error](../mockups/own-requests-list-error.html) | F003-B3 con doble; B4 condicionado | UC-003 menciona consulta fallida, sin causa, recuperación o texto (Q-012/Q-024). No fijar ese comportamiento por el mockup. |
| [Detalle default](../mockups/own-request-detail-default.html) | F003-B3; conexión real B4 | Acceso al detalle propio con estado. Solo datos ya respaldados y proyección pendiente de revisar. |
| [Detalle error](../mockups/own-request-detail-error.html) | F003-B3 para presentación; control backend B1/B2; E2E B4 | Denegación de solicitud ajena respaldada por AC-02. El mockup no revela datos/existencia; texto/código y equivalencia con recurso inexistente no están definidos. |

El estado de detalle inexistente **no tiene resultado esperado ni mockup específico**. No inferir un
código HTTP, una redirección o respuesta idéntica a «ajena». Se puede comprobar que nunca se devuelven
datos ajenos, pero el cierre de la respuesta visible exige Q-012/Q-021. No se crean estados de detalle
loading/empty/success ni se inventan acciones de recuperación.

## 6. Bolts propios, reglas antes que UI

La secuencia principal es F003-B1 → F003-B2 → F003-B3 → F003-B4. Si F001-B4 sigue bloqueado, F003-B1
puede producir evidencia aislada y F003-B3 puede revisarse después contra su frontera probada con
dobles. Esta vía no completa B2 ni reemplaza el registro real. No se implementa UI antes de comprobar
la regla backend de pertenencia. B1 de F001 se reutiliza sin un Bolt nuevo de foundation.

### F003-B1 — Regla de acceso y consulta backend aislada

- **Objetivo:** comprobar lista/detalle propios y denegación de ajenos antes de preparar la UI.
- **Dependencias:** base backend de F001-B1; T-04 como puerta compartida aún pendiente. No exige
  F001-B4 para pruebas aisladas: actor A/B, selección de solicitud y lectura se controlan en fixtures/dobles.
- **Componentes y rutas propuestas:** `VacationManagement.Application/VacationRequests/ReadOwn/`
  bajo `src/backend/`; frontera lógica de lectura sin API/almacén elegidos; pruebas en el área unitaria compartida.
- **Entregables:** regla de pertenencia, casos de consulta de lista/detalle y límites de salida comprobables,
  sin proveedores, tokens, política de login ni un modelo de usuario inventados.
- **Pruebas:** P-01–P-05 y P-07: origen con propias y ajenas, detalle propio, detalle ajeno directo,
  cambio A/B, manipulación de selección y lectura de cuatro estados mediante datos de prueba; ninguna escritura.
  Una referencia de prueba no selecciona el identificador real del dominio.
- **Documentación:** trazabilidad de pruebas, frontera y limitaciones de dobles; dejar Q-012 abierta
  para inexistencia/error. No certificar T-04 por usar un actor de prueba.
- **Criterio de salida:** ni lista ni detalle entregan datos ajenos en los casos probados; lógica
  backend revisada por separado y ningún resultado de persistencia/identidad reales anunciado.
- **Quality gates:** G de sección 7 sobre código afectado; build/lint, unitarias ≥80 %, mutación ≥60 %,
  arquitectura y scans aplicables. Integración real pendiente explícita de B2, no marcada como pasada.
- **Estimación orientativa:** complejidad media, centrada en aislamiento de acceso.

### F003-B2 — Consultas reales y autorización en la entrada backend

- **Objetivo:** integrar lista/detalle con los registros de F001 y el contexto autorizado real, antes
  de declarar que los AC funcionan con la UI conectada.
- **Dependencias:** F003-B1; **F001-B4** para registros Pendiente/pertenencia; T-02/T-03/T-04 y T-05
  cuando se transporten fechas. Ninguna puerta se redefine aquí. Mientras F001-B4 esté bloqueado,
  solo son revisables las pruebas de frontera con dobles, no la salida integrada de este Bolt.
- **Componentes y rutas propuestas:** entrada en `src/backend/VacationManagement.Api/`, consulta
  en `src/backend/VacationManagement.Application/VacationRequests/ReadOwn/` y adaptación de lectura
  en `src/backend/VacationManagement.Infrastructure/VacationRequests/`, como extensiones de F001.
- **Entregables:** dos capacidades de lectura dentro del ámbito del empleado, reutilizando el registro
  existente y sin seleccionar URL, ORM, base de datos o modelos de autorización. Proyección final solo
  tras aclarar Q-005; semántica de inexistencia/fallo tras Q-012/Q-024 para esos caminos.
- **Pruebas:** P-01–P-04/P-07 contra backend y almacén elegidos: registros de A/B y contexto real
  acordado, lista sin datos de B, acceso directo de A al detalle de B denegado sin sus datos, acceso de B
  permitido. No depender del filtro de UI. P-05 verifica Pendiente creado por F001; fixtures de los otros
  estados no equivalen a ejecución de F005/006/007. No exigir orden en aserciones de colecciones.
- **Documentación:** contrato lógico elegido fuera de este paso, evidencia de integración y relación
  actor/pertenencia, gaps de respuesta y acceso local mediante Podman; no reproducir T-01–T-05.
- **Criterio de salida:** consultas de registros reales con aislamiento de lista y detalle probado;
  ningún dato ajeno en payloads de éxito o denegación; respuestas finales revisadas para los caminos
  entregados. F001-B4/T-04 pendientes impiden cerrar este Bolt.
- **Quality gates:** G completo para backend: build/lint, unitarias ≥80 %, mutación ≥60 %, integración,
  arquitectura y scans sin críticos; container build/scan al existir imagen.
- **Estimación orientativa:** complejidad alta por dependencias/decisiones, no por una tecnología elegida.

### F003-B3 — Lista y detalle de solo lectura

- **Objetivo:** materializar los seis HTML de sección 5 sin decidir políticas de consulta ni exponer datos ajenos.
- **Dependencias:** F001-B1 frontend/T-01 y regla/frontera backend comprobada en F003-B1. La conexión
  real requiere F003-B2; si está bloqueado por F001-B4, se permite revisión aislada con dobles etiquetados.
  Reutilizar T-02/T-05 para la representación que finalmente se acuerde.
- **Componentes y rutas propuestas:** `src/frontend/src/app/vacation-requests/own-requests/` y
  `src/frontend/src/app/vacation-requests/data-access/`, compartiendo base/routing que se acuerde, sin fijar URLs.
- **Entregables:** lista propia y selección de detalle, lectura del estado actual, shells de carga/vacío/error
  y presentación de denegación sin datos. Sin botones de aprobar/rechazar/retirar/editar.
- **Pruebas:** componentes con fixtures propios y estados conocidos; selección y detalle propio;
  loading con respuesta controlada; errores/vacío con placeholders sin afirmar copy final. Probar que
  un resultado denegado no deja visible el detalle anterior. Verificar jerarquía, teclado/foco y layout
  móvil/escritorio; no comparar fechas/columnas no acordadas como campos obligatorios de lista.
- **Documentación:** matriz HTML/componente/pruebas y TODO(content), diferencias entre presentación
  simulada y flujo integrado, Q-005/Q-012/Q-021/Q-024 sin resolver. El CDN de wireframe no elige estilos de Angular.
- **Criterio de salida:** seis referencias cubiertas o limitadas explícitamente; UI solo representa
  datos autorizados y no implementa por sí sola seguridad. Placeholders y dobles permiten revisión
  parcial, no aceptación funcional de estados cuyo resultado sigue abierto.
- **Quality gates:** G sobre frontend; build/lint, unitarias ≥80 %, mutación ≥60 %, pruebas de
  componente y arquitectura aplicables, scans sin críticos; E2E real permanece en B4 si B2 no está listo.
- **Estimación orientativa:** complejidad media; mensajes y proyección pendientes pueden condicionar cierre.

### F003-B4 — Verificación integrada del recorrido y de accesos negativos

- **Objetivo:** demostrar ambos escenarios Gherkin con registros reales de F001, sin incorporar las
  transiciones futuras de F005/F006/F007.
- **Dependencias:** F003-B1/B2/B3 y F001-B4 cerrados para el alcance real; T-04 operativo, demás
  puertas heredadas aplicables concretadas; contenido/respuestas aclarados para los criterios a evaluar.
- **Componentes y rutas propuestas:** pruebas compartidas de integración/arquitectura y
  `src/frontend/e2e/`; sin código funcional adicional ni endpoints para crear estados de prueba.
- **Entregables:** automatización de los dos recorridos, datos de prueba de dos empleados, evidencia
  de aislamiento de lista/detalle y gates, con gaps no automatizables separados de resultados pasados.
- **Pruebas:** P-01–P-04/P-07 de extremo a extremo: presentar con F001 y consultar Pendiente; navegar
  a detalle propio; intentar detalle de otro actor directamente y comprobar denegación sin sus datos;
  alternar contextos A/B sin conservar información ajena. P-05 con fixtures comprueba solo lectura de
  Aprobada/Rechazada/Retirada; no afirmar cobertura de sus transiciones. P-06 se integra únicamente
  después de definir resultados, sin inventar latencia, reintento o respuesta para inexistencia.
- **Documentación:** comandos realmente ejecutados, resultados, matriz de cobertura y revisión personal
  Draft. No aprobar AC mediante assertions sobre TODO(content) ni declarar compliance o producción validados.
- **Criterio de salida:** AC-01/02 verificados con backend/registro reales, pruebas de seguridad
  negativas satisfactorias y gates aplicables pasados; preguntas que impiden validar un camino quedan
  como bloqueo/exclusión documentada, no como cobertura completa de UC-003.
- **Quality gates:** G íntegro, incluyendo integración/E2E, arquitectura y scans sin críticos, cobertura
  unitaria ≥80 % y mutación ≥60 %. Sin F001-B4 o T-04, no se declara acabado por usar datos fake.
- **Estimación orientativa:** complejidad media/alta, dependiente de integración y contenido acordado.

## 7. Gates comunes (G)

- Build y lint/format; pruebas unitarias con cobertura ≥80 % y mutación ≥60 %, según los umbrales
  aprobados. Definir el alcance medido de aplicación y reportar resultados, sin ocultar acceso sin probar
  detrás del porcentaje global; no cambiar el mínimo a 70 % de mutación.
- Integración y arquitectura para las fronteras afectadas; B1 aislado no demuestra persistencia ni
  autorización reales. Las pruebas reales de integración son necesarias para cierre de B2/B4.
- Scans de seguridad/dependencias y, al existir imagen, construcción/escaneo de contenedor sin
  hallazgos críticos. Si un gate no puede ejecutarse, anotar por qué, no marcarlo como pasado.
- Ejecución reproducible con la base F001-B1, Podman y GitHub Actions, sin nuevas herramientas
  escogidas aquí. Pruebas de UI con dobles se identifican como tales, no como E2E real.
- Comprobaciones negativas obligatorias: lista nunca contiene ajenas y acceso directo al detalle ajeno
  nunca devuelve sus datos. No basta con esconder controles; verificar backend, payload y DOM.
- Propuesta de telemetría: correlacionar consultas/autorización con OpenTelemetry hacia Azure sin
  registrar contenido de solicitudes o datos personales. No inventar retención, auditoría o alertas.

## 8. Preguntas abiertas, soporte incompleto y riesgos

| Referencia | Pregunta / riesgo que se mantiene abierto | Efecto en Bolts y mitigación propuesta |
| --- | --- | --- |
| LAB-OQ-002; Q-005 | Campos visibles, periodo, filtros, búsqueda, paginación y orden sin definir | B2/B3: conservar solo la proyección respaldada/acordada; no diseñar opciones por defecto. Los placeholders de lista no deciden campos finales. |
| LAB-OQ-008; Q-013/014 | Identidad, autorización, pertenencia y fuente de verdad | T-04 compartida; B1 con actor controlado, B2/B4 bloqueados para validación real hasta resolverla. |
| Q-012/Q-021 | Detalle ajeno frente a inexistente: respuesta externa y texto no definidos | B1 puede probar no devolución de datos; B2/B3/B4 no fijan código, equivalencia ni mensaje. Mockup de denegación no define inexistencia. |
| Q-012/Q-024 | Vacío, fallo de consulta, reintentos y recuperación | Shells de B3 solo representativos con dobles; sin criterios de negocio nuevos ni escenarios Gherkin inventados. |
| LAB-OQ-009 en F003/UC-003; LAB-OQ-008 y Q-015 en baseline/resumen | La spec/UC citan LAB-OQ-009 para retención, pero baseline lo usa para integraciones | Conservar la referencia sin renumerar fuentes. Retención no está decidida; no introducir filtros históricos, purgado ni periodos de consulta por este desajuste. |
| LAB-OQ-009; Q-017/018 | Integraciones externas sin fuente | No hay integración de negocio que añadir a la lectura. Azure es destino técnico de observabilidad, no una dependencia de RR. HH. |
| LAB-OQ-010; Q-019/Q-022 | Rendimiento, disponibilidad, accesibilidad y frescura del estado sin objetivos | B4 no impone latencia, polling, push, caché ni actualización inmediata; lectura del valor almacenado, sin prometer una garantía no especificada. |
| Q-025 | Aceptación y autoridad no confirmadas | Evidencia y revisión de aprendizaje, no sign-off de un negocio. |
| F001-B4 bloqueado | No hay registros reales y pertenencia integrada para consultar | F003-B1/B3 pueden avanzar solo con dobles; F003-B2/B4 no se cierran con ellos. No completar F001 ni recrear su registro desde F003. |
| F005/F006/F007 futuras | Confundir lectura de estados con implementación de decisiones | Usar fixtures para cuatro estados; sin transiciones, historial, motivos o botones de decisión/retirada. |

No se seleccionan nuevas tecnologías ni políticas para mitigar estos riesgos. LAB-OQ/Q siguen abiertos;
no se modifica la baseline, requirements, UCs, Gherkin, mockups, arquitectura ni el plan validado de F001.

## 9. Fuentes y comentario de seguimiento

- [Constitución: digest](../../../.boltf/memory/constitution.digest.md).
- [Roadmap vigente](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md) y [clarificaciones](../../clarification-summary.md).
- [Requisitos F003](../requirements/requirements.md), [UC-003](../requirements/use-cases/UC-003.md) y [dos escenarios Gherkin](../tests/view-own-vacation-requests.feature).
- [Modelo conceptual](../../../docs/design/ddd/vacation-management/domain-model.md), [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).
- [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [research, puertas T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md).
- [Mockups F003](../mockups/README.md), [CHANGELOG](../mockups/CHANGELOG.md) y seis HTML enlazados en sección 5.

La solicitud de seguimiento consiste en **añadir un comentario** en #2, sin sustituir el cuerpo, cerrar
el issue ni crear work items. El resumen debe indicar cuatro Bolts, reutilización de F001-B1/T-01–T-05,
dependencia real F001-B4 y gaps Q-005/Q-012/Q-013/Q-021/Q-024, con enlaces a estos dos documentos.
No se solicita commit/push: los enlaces remotos solo estarán disponibles cuando la rama y documentos
se publiquen. Si no hay herramienta autenticada de escritura, el comentario se informa como pendiente.