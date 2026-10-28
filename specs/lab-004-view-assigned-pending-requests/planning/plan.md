# Plan técnico: LAB-F004 — Consultar solicitudes pendientes asignadas

**Estado:** Draft / LAB-HYP. Laboratorio personal; sin aprobación de negocio ni validación de producción.  
**Escenario:** fullstack; consulta backend y UI, sin aprovisionamiento cloud en esta entrega.  
**Issue:** [#3](https://github.com/jCabreraMartin/vacation-management/issues/3).  
**Rama verificada antes de planificar:** `feature/vacation-management-lab-catalog`, mediante `.git/HEAD`. No se crean ni cambian ramas.  
**Estimación inicial:** cuatro Bolts propios; complejidad relativa media/alta, sin fechas ni compromisos.  
**Salida actual:** este plan y [research.md](research.md). No se generan código, tareas, OpenAPI ni modelo de datos.

## 1. Objetivo y alcance trazado

Permitir al Responsable aprobador consultar únicamente las solicitudes `Pendiente` de empleados que
tiene asignados, y seleccionar una para revisar su detalle dentro de ese mismo ámbito. Trazabilidad:
FR-003, SEC-001, US-LAB-F004-01, AC-LAB-F004-01/02 y UC-004. BR-001 aporta contexto parcial del flujo
centralizado; F004 no implementa ni completa por sí sola el proceso de decisión.

La evidencia de aceptación propuesta por FR-003 en la baseline utiliza **dos responsables**: cada uno
debe ver solo pendientes de sus empleados asignados. Los datos controlados de prueba no deciden
cardinalidad, fuente, vigencia o administración real de asignaciones.

### Regla de acceso y selección

Para devolver una solicitud por esta bandeja o su detalle deben cumplirse conjuntamente:

1. El actor actúa como Responsable aprobador autorizado, no solo como Empleado.
2. El empleado propietario de la solicitud pertenece al ámbito asignado a ese responsable.
3. El estado actual leído de la solicitud es exactamente `Pendiente`.

Las tres condiciones se comprueban en backend; no son filtros opcionales de interfaz. La posesión de
una referencia de solicitud, su presencia previa en pantalla o ser su propietario como Empleado no
habilitan el acceso a la bandeja del responsable. Una selección directa/manipulada no debe devolver
solicitudes no asignadas ni no pendientes. No se fija el código, texto o forma técnica de la respuesta.

La exigencia negativa de no acceder como Empleado sin rol de responsable forma parte explícita de
este encargo de planificación y aplica SEC-001; no se presenta como un tercer escenario Gherkin ya existente.
«Rol de responsable» es aquí una capacidad funcional: no selecciona RBAC, claims, policies, IdP o login.

### Límites

- Lectura de bandeja y detalle; no modifica solicitudes ni asignaciones.
- `Aprobada`, `Rechazada` y `Retirada` quedan fuera de los resultados de esta bandeja, aunque el empleado
  esté asignado. Se usan fixtures para comprobar su exclusión, sin implementar transiciones.
- F005/F006 actuarán desde esta bandeja en sus propias entregas. F007 hará que una retirada deje de
  aparecer por no cumplir `estado = Pendiente`. F004 no implementa botones de decisión/retirada,
  notificaciones, actualizaciones push, polling ni tiempos de propagación.
- No se crea un estado `En revisión`, historial, reservas de saldo ni política de sustitución/delegación.
- No se eligen base de datos, ORM, API, IdP, modelo de autorización, almacenamiento o integración para
  obtener asignaciones. No se construye un módulo para asignar, reasignar, sustituir o cambiar equipos.
- Los campos del resumen/detalle siguen sin definir. No se heredan fechas, nombres o comentario de los
  mockups de F003 como campos visibles obligatorios de F004. No se inventan orden, paginación,
  búsqueda, filtros configurables, cardinalidades, periodos ni NFR.

## 2. Reutilización, dependencias y puertas

### Base y consultas compartidas

- Reutilizar [F001-B1](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo)
  como base .NET/Angular y de pruebas. Un plan validado no demuestra que esa base esté implementada.
- Reutilizar las [fronteras de consulta y acceso de F003](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas):
  contexto de actor, lectura de solicitud, control previo a devolución y salida sin datos ajenos.
  No se crean otro almacén, framework de seguridad ni mecanismo de selección técnica.
- La condición «propiedad del empleado actual» de F003 no autoriza al responsable. Mantener el
  mecanismo compartido de evaluación de acceso y añadir el ámbito asignado con la condición Pendiente;
  no reemplazar ni alterar la regla de consulta propia de F003, que puede leer otros estados.
- La revisión del componente compartido de F003-B1 es el prerrequisito de reutilización de reglas/fronteras;
  su integración de lectura de F003-B2 se consume cuando esté disponible. No se exige la UI ni la
  aceptación completa de F003 para F004. Si esas fronteras aún no existen, acordar su entrega compartida
  antes de implementar F004, sin reconstruirlas en paralelo.

| Dependencia o puerta | Referencia única | Dónde condiciona F004 |
| --- | --- | --- |
| Base F001-B1 | [Plan F001](../../lab-001-submit-vacation-request/planning/plan.md) | Backend de F004-B1 y frontend de F004-B3; no repetir foundation. |
| Registro F001-B4 | [B4 de F001](../../lab-001-submit-vacation-request/planning/plan.md#b4--registro-e-identidad-integrados-condicionados-a-decisiones) | Prerrequisito de F004-B2/B4 para solicitudes Pendiente y pertenencia reales. No usar un fake para declarar esos Bolts integrados. |
| T-01–T-05 | [Registro de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar) | T-01 para UI; T-02/T-03 para exposición/lectura; T-04 para identidad y autorización reales. T-05 solo si se acuerda mostrar datos de fechas, sin inventar campos. |
| Puertas propias de F003 | [Registro de F003](../../lab-003-view-own-vacation-requests/planning/research.md#2-decisiones-técnicas-propias) | F003 no añadió T-06 u otras puertas. Sus gaps de respuesta/proyección se mantienen enlazados, no se renumeran como tecnología nueva. |
| **T-06: dato de asignación** | [Definición de F004](research.md#2-t-06--disponibilidad-del-dato-de-asignación) | Nueva puerta funcional/técnica, pendiente: LAB-OQ-003, Q-006/Q-007/Q-014. Bloquea integración real F004-B2/B4; pruebas aisladas B1 y UI B3 pueden usar asignaciones controladas. |

T-04 identifica al actor y permite comprobar su capacidad; T-06 aporta el dato de empleados asignados.
Una no sustituye a la otra. Tener un actor responsable no acredita asignaciones. T-06 no se cierra con
fixtures ni autoriza a inventar la fuente, política de asignación o un servicio externo.

### Constitución aplicable

Fuente: [digest vigente](../../../.boltf/memory/constitution.digest.md); los ejemplos y alternativas
sin marcar de la constitución no se adoptan como decisiones vinculantes.

| Decisión vinculante | Aplicación y límite |
| --- | --- |
| C#/.NET 8, Angular sin versión fijada, Podman local | Reutilizar F001-B1/T-01; no crear otra base o seleccionar versión aquí. |
| Configuración por archivos, .NET User Secrets local; sin feature flags | Reutilizar configuración compartida, sin secretos en Git ni mecanismo provisional de permisos activado por flag. |
| GitHub Actions, GitHub Flow y GitHub Projects | Gates y seguimiento con #3; sin Azure DevOps ni creación de tareas/issues de Bolt. |
| Cobertura unitaria ≥80 %, mutación ≥60 %, build/lint, integración, arquitectura y scans sin críticos | Gates por Bolt, según sección 7. El 70 % de ejemplos genéricos no aplica como umbral aprobado. |
| Terraform, rolling, dev/uat/prod; `pre` deshabilitado | Respetar en despliegue futuro; esta planificación no provisiona ni escoge plataforma. |
| OpenTelemetry hacia Azure; Resource Health y Activity Logs | Reutilizar observabilidad base. Sin datos de solicitudes/asignaciones en telemetría ni nuevas metas operativas. |
| VNet, Private Endpoints, WAF, claves administradas por Azure y PII cifrada | Restricciones de futuro entorno; clasificación y configuración concretas siguen abiertas. |
| GDPR/HIPAA seleccionados en inicialización | No afirmar cumplimiento logrado ni inventar obligaciones, retención o política de auditoría. |

El trigger dev en `develop` frente a GitHub Flow sigue pendiente para CD, no para consultas aisladas.
La arquitectura modular y los puertos son propuestas de aprendizaje, no decisiones constitucionales.

## 3. Trazabilidad: FR/SEC → AC → UC → Gherkin → pruebas

Historia común: US-LAB-F004-01. Los dos escenarios de
[view-assigned-pending-requests.feature](../tests/view-assigned-pending-requests.feature) permanecen
sin cambios. P-01–P-08 son referencias de pruebas propuestas, no tests ya creados ni tareas ejecutables.

| FR/SEC | AC | UC / evidencia | Escenario Gherkin actual | Pruebas propuestas |
| --- | --- | --- | --- | --- |
| FR-003, SEC-001 | AC-LAB-F004-01 | UC-004 pasos 1–4; evidencia de FR-003 en baseline con dos responsables | «Ver las solicitudes pendientes de empleados asignados» (`@smoke`) | **P-01:** responsables R1/R2 con ámbitos de prueba distintos y solicitudes Pendiente: cada uno ve solo las de sus asignados. B1 aislado, B2 integración, B4 E2E; comparar conjuntos, no orden. |
| SEC-001 | AC-LAB-F004-02 | UC-004 extensión 4a y garantía mínima | «Denegar la consulta de una solicitud de empleado no asignado» (`@security`) | **P-02:** R1 no obtiene detalle ni datos de solicitudes del ámbito de R2 o de empleados sin relación acreditada con R1; acceso directo/manipulado también denegado. B1/B2/B4. |
| FR-003, SEC-001 | AC-LAB-F004-01 y restricción de pendientes | UC-004 paso 3; alcance excluye solicitudes decididas | Refuerzo del primer escenario; no hay otro escenario de estados | **P-03:** para empleados asignados, excluir Aprobada/Rechazada/Retirada de lista y detalle de esta bandeja mediante fixtures; solo Pendiente es visible. B1/B2/B4. Sin transiciones. |
| SEC-001 | Sin AC específico separado para rol; refuerzo de aislamiento | Actores del flujo y precondiciones UC-004; prueba negativa explícita de este encargo | No existe escenario dedicado; no se modifica Gherkin | **P-04:** un Empleado sin capacidad de responsable no accede a bandeja/detalle del responsable, incluso siendo propietario de una solicitud Pendiente. Verificar backend/payload/DOM sin elegir mensaje/código. B1/B2/B4. |
| FR-003, SEC-001 | AC-LAB-F004-01/02 | UC-004 paso 5 | Primer escenario cubre bandeja; detalle positivo se apoya en UC-004, no escenario específico | **P-05:** abrir detalle de una pendiente asignada; repetir condiciones de acceso/estado al seleccionar y no devolver datos fuera de ámbito. B1/B2/B4. Campos concretos pendientes Q-005. |
| SEC-001 | Garantía de acceso, sin AC completo para ambigüedad | UC-004 extensión 2a | Solo comentarios Gap | **P-06:** si no puede acreditarse un ámbito de asignación, no inferir ni ampliar acceso ni devolver información no autorizada. No fijar respuesta final ni resolver asignaciones ambiguas. B1 con doble; integración condicionada a T-06/Q-006–008. |
| FR-003 | Sin AC específico | UC-004 extensiones 3a/3b | Solo comentarios Gap | **P-07:** empty/loading/error de UI con dobles; respuesta final, recuperación, ausencia de asignaciones frente a ausencia de pendientes y mensajes pendientes. No contarlos como aceptación integrada. |
| FR-003 | AC-LAB-F004-01; consulta de solo lectura | UC-004 limita consulta sin administrar/decidir | Comprobación técnica del primer escenario | **P-08:** consultar no escribe ni cambia estados/asignaciones. Releer fixtures no pendientes los excluye, sin ejecutar F005/006/007. B1/B2/B4. |

La configuración R1/R2 sirve para demostrar aislamiento, no fija que un empleado tenga exactamente un
responsable o que los ámbitos sean siempre disjuntos. No se diseñan comportamientos ante relaciones
compartidas, delegaciones o cambios de equipo mientras Q-006/Q-007 sigan abiertas.

## 4. Componentes y flujo propuesto, backend primero

Todas las rutas siguientes son **propuestas no generadas**, derivadas de las áreas de F001/F003. La
reutilización se realizará sobre lo que se implemente y revise de esa base; no se afirma código existente.

| Área | Ruta propuesta | Reutilización y responsabilidad |
| --- | --- | --- |
| Consulta de pendientes asignadas | `src/backend/VacationManagement.Application/VacationRequests/ReadAssignedPending/` | Especialización de las fronteras de lectura/acceso de F003: actor responsable, ámbito asignado y Pendiente. No llamar al caso ReadOwn para simular que responsable = propietario. |
| Lectura compartida / adaptación | `src/backend/VacationManagement.Infrastructure/VacationRequests/` | Reutilizar el registro F001 y el adaptador de lectura de F003 con T-03; nueva condición lógica, no nuevo almacén/ORM. |
| Frontera de asignación | Área de aplicación de lectura anterior | Entrada de solo lectura al dato de ámbito, pendiente de T-06. No se define implementación, entidad, tabla o servicio de administración. |
| Entrada de consulta | `src/backend/VacationManagement.Api/` | Reutilizar mecanismo de contexto/acceso de F003 y exponer consulta propia de bandeja/detalle según T-02, sin rutas ni códigos elegidos aquí. |
| Frontera Angular | `src/frontend/src/app/vacation-requests/data-access/` | Compartida con F003, pero consume exclusivamente pendientes autorizadas; sin datos de otros ámbitos para filtrar localmente. |
| Bandeja y detalle | `src/frontend/src/app/vacation-requests/assigned-pending/` | Reutilizar patrones/componentes de lista/detalle de F003 cuando no impongan sus campos/semántica de acceso. No duplicar shell ni forzar una abstracción común nueva. |
| Pruebas | `tests/VacationManagement.UnitTests/`, `tests/VacationManagement.IntegrationTests/`, `tests/Architecture.Tests/`, `src/frontend/e2e/` | Ampliar áreas comunes con fixtures de responsables/empleados/asignaciones/estados, sin escoger herramientas nuevas ni crear código ahora. |

### Flujo lógico

1. Resolver actor y capacidad de responsable mediante la infraestructura que acuerde T-04. No usar
   un selector editable de responsable o lista de empleados enviada por navegador como autorización.
2. Consumir el ámbito asignado como dato a través de la frontera que concrete T-06. Mientras no haya
   fuente definida, usar únicamente dobles en pruebas; no dar acceso más amplio por falta de datos.
3. Aplicar conjuntamente ámbito asignado y estado Pendiente en backend, antes de proyectar/devolver
   lista o detalle. El criterio fijo no es un filtro configurable ni permite consultar otros estados.
4. Al abrir un detalle, volver a comprobar rol, asignación y estado según el valor leído. No asumir
   vigencia por haber visto la solicitud en la bandeja ni exponer datos de no asignadas/no pendientes.
5. Devolver únicamente información respaldada/acordada. UC-004 y los mockups dejan sin definir los
   campos de detalle; no se trasladan los de F003 como una decisión resuelta.

La respuesta si la solicitud dejó de estar Pendiente, no existe, el ámbito no puede determinarse o
falla la consulta permanece abierta. Se comprueba no exposición de datos, pero no se fija 403/404,
redirección, mensaje, timeout, caché ni política de concurrencia. No se reclama una garantía temporal
de actualización de permisos o estado que no esté especificada.

## 5. Referencias visuales: seis mockups leídos

Se han revisado el [README](../mockups/README.md), el [CHANGELOG](../mockups/CHANGELOG.md) y sus seis HTML.
Son referencias low-fi, no diseño aprobado ni contrato funcional. El CDN Tailwind del wireframe no
elige por sí mismo la tecnología de estilos de Angular.

| Mockup | Bolt que lo materializa | Soporte pendiente o limitado |
| --- | --- | --- |
| [Bandeja default](../mockups/assigned-pending-inbox-default.html) | F004-B3; integración B4 | Elemento ilustrativo y estado Pendiente; nombres, fechas, identificadores y campos del resumen no definidos. |
| [Bandeja empty](../mockups/assigned-pending-inbox-empty.html) | F004-B3 con doble; B4 condicionado | No distingue ausencia de asignaciones, asignación no disponible o inexistencia de pendientes. UC-004/Q-008/Q-012 no fijan respuesta ni acciones. |
| [Bandeja loading](../mockups/assigned-pending-inbox-loading.html) | F004-B3 con demora controlada; B4 | Estado de UI, sin duración, reintento ni estado de dominio nuevo. |
| [Bandeja error](../mockups/assigned-pending-inbox-error.html) | F004-B3 con doble; B4 condicionado | Consulta fallida citada en UC-004, sin mensaje/recuperación. El HTML contiene dos rótulos h2 para el mismo bloque: revisar como referencia provisional, no copiar ambos como copy decidido. No se modifica aquí. |
| [Detalle default](../mockups/assigned-request-detail-default.html) | F004-B3; integración B4 | Pendiente dentro del ámbito autorizado; datos de detalle como placeholder. No completar campos por analogía con F003. |
| [Detalle error](../mockups/assigned-request-detail-error.html) | F004-B3 para UI; acceso B1/B2 y E2E B4 | No asignada: denegación sin datos. Código/texto, equivalencia con inexistente y comportamiento para no Pendiente siguen abiertos. |

No hay pantalla con comportamiento definido para falta/ambigüedad de asignación, Empleado sin rol,
detalle inexistente o detalle que ya no está Pendiente. No devolver datos es comprobable; las
respuestas visibles requieren aclaración. No se añaden mockups ni estados como solución a esos gaps.

## 6. Bolts revisables

Secuencia principal: F004-B1 → F004-B2 → F004-B3 → F004-B4. Con F001-B4 o T-06 bloqueadas,
F004-B1 puede comprobar reglas con asignaciones controladas. F004-B3 puede revisarse de forma
aislada **después** de esas reglas/fronteras backend probadas, reutilizando la base frontend; no
constituye integración ni cierra B2/B4. No se crean ramas, issues de Bolt ni tareas en esta entrega.

### F004-B1 — Ámbito asignado, rol y Pendiente en consulta aislada

- **Objetivo:** comprobar las tres condiciones de acceso/selección antes que la UI.
- **Dependencias:** base backend F001-B1 y revisión/reutilización de las fronteras de consulta/acceso
  F003-B1. T-04 y T-06 permanecen pendientes: responsables, capacidades, relaciones y registros se
  suministran como datos controlados en pruebas, sin resolver fuente ni cardinalidad real.
- **Componentes/rutas propuestas:** `src/backend/VacationManagement.Application/VacationRequests/ReadAssignedPending/`
  y pruebas unitarias comunes; utilizar la frontera de lectura existente/propuesta de F003.
- **Entregables:** consulta aislada de bandeja/detalle y condición conjunta responsable/asignado/Pendiente,
  frontera de consumo de asignación sin implementación elegida; sin escritura de estados/relaciones.
- **Pruebas:** P-01–P-06/P-08 con dos responsables, empleados/relaciones conocidos y cuatro estados
  de fixture. Quitar cada condición válida por separado debe impedir devolver la solicitud. Incluir
  Empleado sin rol aunque sea propietario; no emitir una política para asignación compartida o ambigua.
- **Documentación:** tabla fuente/prueba y límites de datos controlados; diferencia entre reutilizar
  evaluación de acceso de F003 y preservar sus condiciones propias.
- **Salida:** matriz de aislamiento backend comprobada sin tecnología real; solicitudes no asignadas
  o no Pendiente excluidas de lista y detalle; sin afirmar que T-04/T-06 se hayan resuelto.
- **Quality gates:** G, sección 7: build/lint, unitarias ≥80 %, mutación ≥60 %, arquitectura y scans
  aplicables. Integración real documentada como pendiente de B2, no como pasada con dobles.
- **Estimación inicial orientativa:** complejidad media, sin compromiso temporal.

### F004-B2 — Consultas reales con dato de asignación acreditado

- **Objetivo:** integrar la bandeja/detalle con solicitudes registradas y ámbito del responsable real.
- **Dependencias:** F004-B1, **F001-B4**, T-02/T-03/T-04 y **T-06** concretadas para este flujo;
  reutilizar adaptador de lectura F003-B2 cuando exista, sin rehacerlo ni exigir el cierre de su UI.
  T-05 solo aplica si se acuerda exponer datos de fecha. Si faltan fuente de asignación/actor/registro,
  solo son revisables fronteras con dobles; el Bolt no puede cerrarse como integrado.
- **Componentes/rutas propuestas:** entrada común `src/backend/VacationManagement.Api/`, aplicación
  `ReadAssignedPending/` y adaptación `src/backend/VacationManagement.Infrastructure/VacationRequests/`;
  conexión al dato de asignación únicamente como se decida en T-06, no un sistema nuevo impuesto.
- **Entregables:** lectura autorizada por responsable y estado; detalle con verificación reiterada al
  seleccionar; reutilización de representación de datos y componentes de acceso comunes.
- **Pruebas:** P-01–P-06/P-08 contra entradas/adaptadores reales con relaciones de prueba autorizadas
  en la fuente acordada: dos responsables, ningún cruce de ámbito, exclusión de no Pendiente,
  acceso directo fuera de ámbito bloqueado y Empleado sin rol sin acceso. F001 aporta Pendiente
  real; los demás estados se cargan como fixtures, no ejecutando F005/006/007.
- **Documentación:** evidencia del origen/acceso a asignación cuando se decida, integración con
  F001/F003 y preguntas no resueltas; condiciones locales Podman sin repetir setup ni T-01–T-05.
- **Salida:** reglas verificadas con actor/registro/fuente de asignación reales y consultas sin datos
  ajenos/no pendientes. Si Q-006/Q-013 o T-06 siguen abiertas para la integración, continúa bloqueado;
  no usar archivo de asignaciones o seed fijo como implementación real sin una decisión explícita.
- **Quality gates:** G completo backend: build/lint, unitarias ≥80 %, mutación ≥60 %, integración,
  arquitectura y scans sin críticos; container build/scan cuando exista imagen.
- **Estimación inicial orientativa:** complejidad alta por dependencias y decisiones, no por una base de datos elegida.

### F004-B3 — Bandeja y detalle de revisión, sin acciones de decisión

- **Objetivo:** materializar los seis HTML de sección 5 como vistas de solo lectura.
- **Dependencias:** base frontend F001-B1/T-01, fronteras/regla backend F004-B1 comprobadas y
  patrones de UI/cliente de F003 aplicables. Integración real requiere F004-B2; con T-06 pendiente
  solo se revisa presentación con dobles claramente identificados, sin asumir un proveedor de asignación.
- **Componentes/rutas propuestas:** `src/frontend/src/app/vacation-requests/assigned-pending/` y
  `src/frontend/src/app/vacation-requests/data-access/`, compartiendo shell/patrones de F003 donde apliquen.
- **Entregables:** bandeja Pendiente, selección de detalle y representaciones default/loading/empty/error
  conforme a seis referencias. Sin columnas no definidas, acciones aprobar/rechazar/retirar o datos
  del empleado inventados. La regla de seguridad no depende de la visibilidad de controles de UI.
- **Pruebas:** componentes con pendientes autorizadas y resultados controlados; navegación/selección
  de detalle; error de acceso sin datos previos visibles; cambio de contexto R1/R2 sin conservar datos
  del otro; layout móvil/escritorio, teclado/foco y jerarquía. Empty/error son shells con contenido
  pendiente, no resultados funcionales definidos. UI nunca filtra un payload que contenga otros ámbitos.
- **Documentación:** correspondencia HTML/componente y TODO(content), doble frente a respuesta real,
  estados sin soporte y revisión de campos/respuestas (Q-005/Q-008/Q-012/Q-021/Q-024).
- **Salida:** seis referencias cubiertas o limitadas explícitamente; ninguna prueba de placeholder
  se considera aceptación. Si B2/T-06 faltan, solo puede darse revisión de presentación aislada.
- **Quality gates:** G frontend: build/lint, unitarias ≥80 %, mutación ≥60 %, componente/arquitectura
  aplicables y scans sin críticos. E2E integrado queda condicionado a B4.
- **Estimación inicial orientativa:** complejidad media; campos/copy pendientes pueden condicionar cierre.

### F004-B4 — Aceptación técnica con dos responsables y negativos

- **Objetivo:** verificar los dos Gherkin y los negativos de rol/estado de este encargo, de extremo a extremo.
- **Dependencias:** F004-B1/B2/B3, F001-B4, T-04 y T-06 operativas; puertas comunes aplicables
  concretadas y respuestas/proyección aclaradas para los caminos que se evalúen. F005/006/007 no
  son prerrequisitos: la exclusión de sus estados se prueba con fixtures.
- **Componentes/rutas propuestas:** suites comunes de integración/arquitectura y `src/frontend/e2e/`;
  sin endpoints, transiciones ni módulo de administración creados solo para generar datos de prueba.
- **Entregables:** trazabilidad de los dos escenarios actuales a pruebas ejecutables y matriz negativa
  complementaria, evidencia de aislamiento entre dos responsables y reporte de gates/gaps.
- **Pruebas:** P-01–P-05/P-08 integradas: crear Pendiente con F001, leer por R1/R2, acceder directamente
  a detalle de no asignado y no Pendiente, y probar Empleado sin rol. Verificar backend/payload/DOM,
  no solo botones ocultos. Reread con fixture Retirada no debe incluirlo, sin ejecutar la retirada.
  P-06/P-07 solo tienen aceptación completa cuando su resultado/respuesta estén definidos; no
  afirmar cobertura de fallo, asignación ambigua o inexistencia a partir de respuestas fake.
- **Documentación:** comandos realmente ejecutados, matriz de resultados y gaps, revisión personal
  de aprendizaje; no sign-off de negocio, conformidad regulatoria ni SLO no definidos.
- **Salida:** ambas AC y los negativos verificables pasan con datos/actor/fuente reales; gates
  aplicables satisfechos. Toda exclusión por pregunta abierta queda visible y evita declarar UC-004
  completo. Un actor o asignación fake no acredita cierre de la puerta real.
- **Quality gates:** G íntegro: build/lint, unitarias ≥80 %, mutación ≥60 %, integración/E2E,
  arquitectura y scans sin críticos, con alcance/limitaciones reportados.
- **Estimación inicial orientativa:** complejidad media/alta; condicionada a integración y aclaraciones.

## 7. Gates comunes (G), seguridad y observabilidad

- Build y lint/format; cobertura unitaria ≥80 % y mutación ≥60 % sobre código afectado/alcance
  acordado de aplicación. No sustituir pruebas negativas por un porcentaje global ni elevar el mínimo
  por usar un valor genérico de la skill.
- Integración y arquitectura en las fronteras afectadas; B1 aislado no demuestra asignación/actor
  reales. B2/B4 necesitan integración real, no solo dobles que devuelvan datos ya filtrados.
- Security/dependency scans sin críticos; construir/escanear imagen cuando exista. Si un gate no
  está disponible, registrar el bloqueo o no aplicabilidad con motivo, nunca declararlo pasado.
- Reutilizar ejecución Podman/GitHub Actions y boundaries de F001/F003. Verificar no regresión:
  F003 sigue consultando propias de cualquier estado respaldado; F004 solo asignadas Pendiente.
- Negativos mínimos: no asignada, estado distinto de Pendiente, detalle directo/manipulado y actor
  Empleado sin capacidad de responsable. Verificar que la denegación no arrastre datos del recurso.
- Propuesta: correlacionar lecturas y evaluación de acceso con OpenTelemetry hacia Azure sin
  contenido de solicitudes o relaciones personales en logs. Retención, exporter, alertas y clasificación
  PII siguen abiertos; no se inventan objetivos operativos ni cumplimiento GDPR/HIPAA.

## 8. Preguntas abiertas y riesgos

| Referencia | Pregunta o riesgo sin resolver | Efecto / tratamiento propuesto |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-014 | Origen, propietario, mantenimiento, cardinalidad y vigencia de asignación; sustituciones/cambios | T-06 bloquea integración real B2/B4. Dobles controlados para B1/B3; no inventar administración, delegación o sistema externo. |
| LAB-OQ-008; Q-013 | Identidad, capacidad de responsable y autorización concreta | T-04 heredada; no confundir rol funcional con modelo tecnológico elegido. El negativo de Empleado sin rol sigue obligatorio. |
| Q-005/Q-021 | Campos y evidencia de lista/detalle, filtros/orden/paginación no definidos | No completar desde F003; mantener placeholders y proyección pendiente. |
| Q-008/Q-012 | Sin asignaciones frente a sin pendientes; asignación desconocida/ambigua | No equiparar estas situaciones a una misma respuesta final. UC-004 prohíbe inferir/ampliar ámbito, pero deja abierta la resolución/presentación. |
| Q-012/Q-024 | Consulta fallida, inexistencia, cambio de estado/asignación durante lectura y reintentos | No prescribir timeout, caché, retry, código HTTP ni resultado. Comprobar límites de acceso para datos conocidos; garantías concurrentes pendientes. |
| LAB-OQ-010; Q-019/Q-022 | Rendimiento, disponibilidad, capacidad, accesibilidad y frescura | No fijar SLO, carga, polling, push o plazo para desaparecer tras una decisión/retirada. |
| LAB-OQ-008; Q-015/Q-016 | Privacidad, retención y auditoría | No introducir historial ni política legal. Sin datos reales hasta clasificar/protegerlos según decisiones aplicables. |
| Q-025 | Autoridad de aceptación | Revisión personal y evidencia técnica, sin aprobación ficticia de negocio. |
| F001-B4/T-04 bloqueadas | No existen condiciones acreditadas de registro/actor para consultar | Revisar aislados B1/B3; no cerrar B2/B4 hasta que existan sus prerrequisitos. |
| Reutilización de F003 | Aplicar accidentalmente propiedad o mostrar no pendientes | Pruebas de no regresión separadas; reutilizar mecanismos, no confundir ámbitos de autorización. |
| Mockups estáticos / copy provisional | Copiar campos o mensajes no definidos como contrato | Revisar seis referencias sin modificarlas; distinguir UI representativa de estados funcionalmente comprobables. |

## 9. Fuentes y seguimiento

- [Constitución: digest](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md) y [clarificaciones](../../clarification-summary.md).
- [Requisitos F004](../requirements/requirements.md), [UC-004](../requirements/use-cases/UC-004.md), [Gherkin F004](../tests/view-assigned-pending-requests.feature), [mockups](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md).
- [F001: plan](../../lab-001-submit-vacation-request/planning/plan.md) y [puertas compartidas](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: plan de consulta/acceso](../../lab-003-view-own-vacation-requests/planning/plan.md) y [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [Dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md), [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md) y [T-06 de F004](research.md).

Se solicita añadir un comentario en #3, no sustituir su cuerpo ni cerrarlo. El comentario preparado
figura en research.md. Sin commit/push, sus enlaces remotos son referencias previstas, no publicación
confirmada. Si no se dispone de una herramienta autenticada de escritura, el comentario permanece
pendiente y se comunica esa limitación. No se crea ningún otro work item ni se usa Azure DevOps.