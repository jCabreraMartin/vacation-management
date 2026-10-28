# Registro técnico: LAB-F004 — Consultar pendientes asignadas

**Estado:** Draft / LAB-HYP. Laboratorio personal; sin validación de negocio ni producción.  
**Issue:** [#3](https://github.com/jCabreraMartin/vacation-management/issues/3).  
**Plan:** [plan.md](plan.md).

## 1. Base y puertas heredadas

Se reutilizan [F001-B1](../../lab-001-submit-vacation-request/planning/plan.md#b1--base-mínima-para-el-flujo)
y [T-01–T-05 de F001](../../lab-001-submit-vacation-request/planning/research.md#resultado-de-la-revisión-necesaria-para-planificar)
por referencia, sin copiar sus definiciones, escoger tecnologías ni resolverlas. Su aplicación a F004
se recoge en el plan: herramientas de UI, entrada, almacenamiento, identidad/autorización y, solo si se
acuerda mostrar fechas, representación temporal.

El [registro de F003](../../lab-003-view-own-vacation-requests/planning/research.md#2-decisiones-técnicas-propias)
no añadió puertas. Sus [fronteras de consulta/acceso](../../lab-003-view-own-vacation-requests/planning/plan.md#4-responsabilidades-y-áreas-propuestas)
se consumen sin rediseño: el mecanismo de contexto y la verificación previa a devolver datos se
reutilizan, pero la condición de propiedad del empleado no sustituye el ámbito del responsable.

F001-B4 es el prerrequisito de registro real; tener su plan no acredita que esté implementado.
F004-B1/B3 pueden revisarse con datos controlados; F004-B2/B4 no se cierran con esos dobles.

## 2. T-06 — Disponibilidad del dato de asignación

**Estado:** pendiente de aclaración funcional y concreción técnica; bloqueante para integrar F004-B2/B4.
No es una decisión resuelta ni una investigación externa ya realizada.

**Evidencia:** LAB-OQ-003, Q-006/Q-007/Q-014; FR-003, SEC-001, dependencias de LAB-F004 y
UC-004 precondiciones/extensión 2a. Las fuentes presuponen una relación responsable–empleado para
practicar el flujo, pero no especifican origen, propietario, cardinalidad, mantenimiento o vigencia.

### Pregunta funcional antes de investigar tecnología

¿Qué dato permite acreditar que el empleado está asignado al responsable que consulta, quién lo
mantiene y cuál es su fuente de verdad? ¿Cómo se determina su vigencia y qué significa que no esté
disponible o sea ambiguo? Sustituciones, delegaciones, varios responsables y cambios de equipo siguen
abiertos; no se fija ninguna política o cardinalidad en este registro.

### Límite técnico y vínculo con T-04

T-04 resuelve el contexto de identidad/capacidad; T-06 debe permitir consumir el ámbito de asignación
que se aclare. Son entradas distintas de la comprobación conjunta. No se renombra T-04 ni se elige IdP,
RBAC/ABAC/claims/policies. No se decide tabla, base de datos, archivo, seed de desarrollo, servicio de
RR. HH. o sincronización como fuente de asignación.

Se propone una frontera de solo lectura al dato de ámbito, dentro del caso de consulta. Esto no es un
servicio de dominio confirmado ni entidad de asignación. Con asignación no acreditable, UC-004 indica
no inferir/ampliar el ámbito; la respuesta y recuperación para ese caso siguen pendientes, no se eligen
como «lista vacía», «denegado» o un error concreto por defecto.

### Investigación mínima futura y criterio de desbloqueo

Una vez aclarados origen y semántica, comprobar únicamente si el mecanismo acordado aporta el dato
necesario para restringir bandeja y detalle sin devolver solicitudes fuera de ámbito, y si permite
identificar la falta/ambigüedad que se haya definido. Evaluar las garantías reales de lectura junto a
T-02/T-03/T-04, sin inventar caché, SLA, sincronización o NFR.

T-06 se desbloqueará para integración solo con una definición explícita de fuente/responsabilidad y
semántica necesaria para ese alcance, mecanismo aceptado para consumirla y evidencia reproducible con
dos responsables. Un doble con ámbitos conocidos demuestra la regla aislada, no cierra T-06 ni
resuelve políticas de asignación no especificadas. Si falta una de esas condiciones, F004-B2/B4
permanecen bloqueados. No se ejecuta investigación externa ni experimento en esta entrega.

## 3. Aclaraciones que no puede responder la tecnología

| Fuente | Cuestión sin resolver | Límite del plan |
| --- | --- | --- |
| LAB-OQ-003; Q-006/Q-007/Q-014 | Propietario, fuente, cardinalidad, mantenimiento, vigencia y sustituciones | T-06; no desarrollar asignaciones, delegaciones o cambios de equipo por anticipado. |
| LAB-OQ-008; Q-013 | Capacidad de responsable y autorización concreta | T-04 compartida. Empleado sin capacidad de responsable no accede; no elegir cómo lo expresa un IdP/modelo de autorización. |
| Q-005/Q-021 | Campos/evidencia de bandeja y detalle | No heredar campos de F003 ni añadir identificadores, filtros, orden, búsqueda o paginación. |
| Q-008/Q-012 | Sin pendientes, sin asignación o asignación no disponible/ambigua | La equivalencia de respuestas no está definida; el mockup empty no la resuelve. |
| Q-012/Q-024 | Recurso inexistente, fallo de consulta, cambio concurrente y respuesta visible | No elegir mensaje, código HTTP, retry, actualización automática ni garantía de coherencia temporal. |
| LAB-OQ-010; Q-019/Q-022 | Rendimiento, disponibilidad, capacidad, accesibilidad y frescura | Sin objetivos medibles no se eligen umbrales, polling, push ni caché. |
| Q-015/Q-016/Q-025 | Privacidad, conservación, auditoría y autoridad de aceptación | Sin políticas legales, historial o sign-off ficticios. |

## 4. Qué puede avanzar con asignaciones controladas

- F004-B1, tras reutilizar la base y las fronteras revisadas de F003: regla de acceso con actor,
  asignación y estado controlados; comparación de resultados de dos responsables, sin fijar cardinalidad.
- F004-B3, solo después de comprobar el backend aislado: presentación de seis mockups con dobles,
  sin integrar acceso real ni convertir placeholders de empty/error/detalle en criterios finales.
- F004-B2/B4 necesitan F001-B4, T-04 y T-06 concretadas, además de las puertas compartidas que
  consuman. No se puede considerar operación real una fuente de asignación fake sin acuerdo explícito.
- Se prueban con fixtures solicitudes Aprobada/Rechazada/Retirada para demostrar su exclusión. No
  se necesita implementar F005/F006/F007 ni introducir un estado En revisión para probar el criterio.

## 5. Investigación no necesaria ahora

No se investigan otras bases de datos, ORM, APIs, proveedores de identidad, frameworks de autorización,
broker, motor de búsqueda o plataforma cloud para volver a resolver T-01–T-05. Tampoco se investiga
qué política de negocio «conviene» para asignaciones, textos, campos, saldo o calendario: debe
aclararse con el autor del ejercicio, no obtenerse por selección técnica. No se han ejecutado pruebas
ni elegido paquetes. Este registro mantiene Draft y no declara gates de implementación superados.

## 6. Comentario preparado para el issue #3

**Estado de publicación:** preparado; no debe interpretarse como comentario enviado. Los enlaces a
la rama son previstos hasta publicar los documentos mediante una operación de Git autorizada.

> Plan técnico de LAB-F004 preparado en Draft / LAB-HYP, sin implementación ni aprobación de negocio.
>
> Bolts propuestos: F004-B1 regla backend de rol/asignación/Pendiente con datos controlados;
> F004-B2 integración real de bandeja/detalle; F004-B3 UI de los seis mockups; F004-B4 verificación
> integrada con dos responsables y negativos de acceso.
>
> Se reutilizan F001-B1, T-01–T-05 y las fronteras de consulta/acceso de F003. F003 no añadió puertas.
> Nueva T-06 pendiente: origen/propietario/mantenimiento del dato de asignación (LAB-OQ-003,
> Q-006/Q-007/Q-014). No se fija cardinalidad, delegación ni fuente externa.
>
> F001-B4, T-04 y T-06 son prerrequisitos de integración real; B1 y UI aislada pueden revisarse con
> dobles después de la base/reglas compartidas. Pruebas clave: cada responsable ve solo pendientes
> de sus asignados; no asignadas/no pendientes no se exponen; un Empleado sin capacidad de
> responsable no accede a esta bandeja. No se implementan acciones F005/F006/F007.
>
> Gates previstos: build/lint, cobertura unitaria ≥80 %, mutación ≥60 %, integración, arquitectura
> y scans sin críticos. Campos, empty/error, inexistencia y respuestas siguen abiertos donde falta evidencia.
>
> [Plan](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-004-view-assigned-pending-requests/planning/plan.md)
> y [registro técnico](https://github.com/jCabreraMartin/vacation-management/blob/feature/vacation-management-lab-catalog/specs/lab-004-view-assigned-pending-requests/planning/research.md).
> Documentos generados localmente; su disponibilidad remota queda pendiente de publicación, sin commit/push solicitado en este paso.

## 7. Fuentes

- [Plan F004](plan.md), [requisitos](../requirements/requirements.md), [UC-004](../requirements/use-cases/UC-004.md), [dos Gherkin](../tests/view-assigned-pending-requests.feature), [mockups](../mockups/README.md) y [CHANGELOG](../mockups/CHANGELOG.md).
- [F001: base y Bolts](../../lab-001-submit-vacation-request/planning/plan.md), [T-01–T-05](../../lab-001-submit-vacation-request/planning/research.md).
- [F003: consulta/acceso](../../lab-003-view-own-vacation-requests/planning/plan.md), [registro técnico](../../lab-003-view-own-vacation-requests/planning/research.md).
- [Constitución resumida](../../../.boltf/memory/constitution.digest.md), [roadmap](../../../docs/roadmap/implementation-roadmap.md), [baseline](../../lab/requirements-baseline.md), [clarificaciones](../../clarification-summary.md).
- [Dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md), [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).