# Registro técnico: LAB-F003 — Consultar solicitudes propias

**Estado:** Draft / LAB-HYP. Laboratorio personal; no hay requisitos aprobados por un negocio real.  
**Issue:** [#2](https://github.com/jCabreraMartin/vacation-management/issues/2).  
**Plan:** [plan.md](plan.md).

## 1. Reutilización de la base y puertas existentes

La base técnica se consume desde [F001-B1](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo).
No se repite el trabajo de foundation ni se da por implementado por tener un plan validado.

T-01–T-05 se definen y mantienen exclusivamente en
[research.md de LAB-F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar).
Este registro no copia sus decisiones, las resuelve ni abre investigaciones equivalentes.

| Referencia a la puerta compartida | Dónde se consume en F003 |
| --- | --- |
| T-01 | Base y pruebas frontend de F003-B3, heredadas de F001-B1. |
| T-02 | Exposición real de lista/detalle en F003-B2 y conexión de UI en B4, usando la elección común cuando exista. |
| T-03 | Adaptación de lectura de registros creados por F001-B4, sin base de datos/ORM nuevo. |
| T-04 | Identidad y pertenencia en B2/B4. B1 solo prueba reglas con actores controlados; no valida un proveedor real. |
| T-05 | Representación de las fechas que ya existen en el registro, si se incluyen en la proyección acordada. |

Todas se mantienen pendientes según el registro de F001; la lectura de su plan no las cierra. F003-B2
requiere además F001-B4 como dependencia funcional/técnica concreta, no una nueva puerta renumerada.

## 2. Decisiones técnicas propias

**No se identifican nuevas puertas T-06… necesarias para redactar este plan.** El aislamiento de la
consulta es una aplicación de SEC-001 y de las fronteras ya propuestas; el motor, API y mecanismo de
identidad se resuelven a través de las puertas compartidas, no con decisiones paralelas de F003.

Se propone una consulta restringida al empleado actual y una salida de detalle sometida a la misma
regla, sin descargar solicitudes ajenas para filtrarlas en navegador. Esta propuesta podrá comprobarse
con pruebas aisladas antes de elegir tecnología. No determina un nuevo servicio de dominio, CQRS,
repositorio, agregado, esquema, caché, índice o protocolo.

No se han realizado investigaciones externas, pruebas ejecutables ni selección de paquetes en esta
entrega. Si al implementar el adaptador elegido surge un problema técnico propio que impida demostrar
aislamiento, se podrá registrar una investigación acotada con evidencia entonces; no es necesario
investigar tecnologías posibles por anticipado.

## 3. Aclaraciones que no puede cerrar la investigación técnica

| Fuente | Cuestión sin resolver | Momento / alcance que limita |
| --- | --- | --- |
| LAB-OQ-002; Q-005 | Campos del resumen/detalle y opciones de consulta | Proyección final en F003-B2/B3. No elegir columnas, filtros, periodo, orden, búsqueda ni paginación por disponibilidad de una biblioteca. |
| LAB-OQ-008; Q-013/Q-014 | Identidad y pertenencia, propietario/fuente de datos | Acceso real en B2/B4 mediante T-04; dobles en B1 no validan derechos del usuario real. |
| Q-012/Q-021 | Denegación ajena frente a solicitud inexistente | La denegación sin datos está respaldada; respuesta externa/código/contenido y no revelación de existencia en el diseño final requieren clarificación. No resolver el gap con un 403/404 elegido por convención. |
| Q-012/Q-024 | Estado vacío y fallo de consulta | Representables con placeholders en B3; resultados de aceptación, recuperación y reintentos no definidos para integración. |
| LAB-OQ-009 citado por F003/UC-003; Q-015 | Retención: la cita LAB-OQ-009 de la feature no coincide con el ID de integración en baseline | Mantener el desajuste visible. No inferir conservación, borrado o periodo histórico; LAB-OQ-008/Q-015 recogen el tema en baseline/resumen. |
| LAB-OQ-010; Q-019/Q-022 | NFR y frescura del estado | No elegir caching/polling/eventos ni umbrales como solución implícita. Mostrar el valor leído, sin prometer cuándo se propagó una decisión de otra feature. |
| Q-025 | Evidencia y autoridad de aceptación | Las pruebas del laboratorio no equivalen a aprobación de negocio. |

## 4. Qué puede avanzar sin registro real

- Tras reutilizar F001-B1, F003-B1 puede comprobar lectura por propietario y denegación mediante
  actores y registros de prueba; no necesita esperar a F001-B4 para esa evidencia aislada.
- Después de revisar la regla backend, F003-B3 puede representar sus seis estados con dobles. No
  simula una integración terminada ni decide los resultados abiertos de empty/error/inexistencia.
- F003-B2/B4 requieren registros reales de F001-B4 y T-04 resuelta para demostrar pertenencia real.
  Las demás puertas compartidas deben estar concretadas en el punto donde se consuman.
- Fixtures de Aprobada/Rechazada/Retirada solo prueban lectura. No se investiga ni implementa
  aprobación, rechazo, retirada o un estado En revisión para obtener esos datos.

## 5. Investigación no necesaria en este paso

No hace falta investigar nuevas bases de datos, ORM, estilos API, IdP, modelos de autorización,
plataformas cloud, eventos o motores de búsqueda. Tampoco se investiga asignación de responsables,
saldo, calendario laboral, motivos de decisión, integraciones o retención para responder reglas de
negocio que siguen abiertas. Las obligaciones constitucionales permanecen vigentes; nada de ello
habilita a declarar cumplimiento, rendimiento o despliegue validados.

## 6. Fuentes

- [Plan F003](plan.md), con trazabilidad de FR-002/SEC-001, AC, UC, Gherkin y pruebas propuestas.
- [F001: plan base](../../lab-001-submit-vacation-request/planning/plan.md), [puertas técnicas compartidas](../../lab-001-submit-vacation-request/planning/research.md).
- [Requisitos F003](../requirements/requirements.md), [UC-003](../requirements/use-cases/UC-003.md), [Gherkin](../tests/view-own-vacation-requests.feature), [mockups](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md).
- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md), [clarificaciones](../../clarification-summary.md).
- [Modelo conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).

Los artefactos fuente permanecen sin cambios y en Draft. No se han cerrado puertas compartidas,
respondido preguntas abiertas ni producido código, tareas de ejecución, contratos o modelo de datos.