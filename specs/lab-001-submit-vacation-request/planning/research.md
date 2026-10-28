# Registro técnico: LAB-F001 — Presentar una solicitud de vacaciones

**Estado:** Draft / LAB-HYP. Laboratorio personal; sin aprobación de negocio.  
**Issue:** [#1](https://github.com/jCabreraMartin/vacation-management/issues/1).  
**Plan relacionado:** [plan.md](plan.md).

## Resultado de la revisión necesaria para planificar

Se ha revisado evidencia local, no se ha ejecutado investigación externa ni experimento de código.
Para escribir este plan basta con separar capacidades probables de decisiones pendientes: no hay
necesidad de elegir tecnología ahora. Las decisiones siguientes sí condicionan la futura ejecución
del Bolt indicado, pero se registran como **pendientes**, no como soluciones investigadas o acordadas.

| ID | Decisión técnica necesaria | Evidencia / estado | Momento y comprobación necesaria antes de ejecutar |
| --- | --- | --- | --- |
| T-01 | Versión Angular y herramientas compatibles con .NET 8/entorno local | Angular sin versión en constitución; `src/frontend/` vacío. Pendiente. | Antes de B1 frontend: comprobar versiones de herramientas realmente disponibles, compatibilidad del conjunto Angular/Node/TypeScript y runner de pruebas. No se ha hecho esa comprobación; no seleccionar versiones por inferencia. |
| T-02 | API style/protocolo y representación de entrada/salida de presentación | Constitución sin selección; arquitectura propone frontera de entrada, no contrato. Pendiente. | Antes de B4: acordar cómo comunicar campos y resultado con Angular y cómo distinguir validación de registro confirmado. Evaluar solo esa operación, sin diseñar CRUD extra, códigos definitivos ni OpenAPI aquí. |
| T-03 | Medio de registro y mecanismo de acceso a datos | FR-001 requiere registrar, DDD no confirma repositorio/agregado ni identidad técnica; sin motor seleccionado. Pendiente. | Antes de B4: decidir almacenamiento y comprobar registro/lectura de evidencia de prueba con la tecnología aceptada, conservación de comentario/estado y garantías ante resultado no confirmado. No se elige motor, ORM, esquema o migración. |
| T-04 | Contexto de empleado y vinculación de propiedad; mecanismo de autorización aplicable | SEC-001; LAB-OQ-008, Q-013/014. Proveedor y modelo no elegidos. Pendiente. | Antes de B4: aclarar la semántica con el autor y después evaluar cómo obtener/verificar el actor sin un propietario editable por el cliente. B2 puede probarse con contexto controlado, que no valida autenticación real. |
| T-05 | Representación de fechas entre UI/backend/registro | LAB-OQ-002/004; Q-002/020. La semántica de negocio está incompleta. Pendiente. | Antes de concretar B2/B3: aclarar tipo de dato/semántica temporal y después comprobar transporte y comparación sin pérdida. No elegir DateOnly, timestamp, zona horaria o formato como respuesta a la pregunta funcional. |

T-01–T-05 son puertas de decisión, no un catálogo de tecnologías adoptadas. Si al ejecutarlas se necesita
investigación, acotarla al Bolt afectado, documentar evidencia y alternativas antes de acordar una
elección. No se registra ningún estado `NEEDS RESEARCH` como investigación realizada ni se crea un issue
adicional para preguntas que aún requieren una decisión del autor.

## Preguntas funcionales que no resuelve la investigación técnica

| Pregunta fuente | Efecto para el plan | Límite |
| --- | --- | --- |
| LAB-OQ-002/004; Q-002/020 | Conjunto de entradas aceptadas y semántica temporal incompletos | No buscar una librería para decidir política de calendario, mismo día, fechas pasadas o solapamientos. |
| Q-009/010 | Error comprensible y confirmación sin contenido/canal cerrado | Mantener placeholders como deuda de contenido, no dar por aceptado el resultado final. |
| Q-011 | Reglas de comentario adicionales no definidas | Es opcional según FR-001; no imponer límite, obligatoriedad o normalización nuevos. |
| Q-013/014 | Identidad, autorización y propietario/fuente de datos | La tecnología no puede definir qué actor tiene derecho ni quién mantiene los datos. Aclarar antes de T-04. |
| Q-024 | Resultado ante fallo de registro, reintento o envío duplicado | No deducir rollback, reintento automático, idempotencia ni mensaje de error del stack. |

## Investigación que no hace falta todavía

- Asignaciones de responsables, “En revisión”, reapertura, motivos y transiciones posteriores: pertenecen
  a otros flujos y preguntas abiertas; no bloquean la presentación aislada de F001.
- Saldo de días (LAB-OQ-005): fuera de esta iteración; no seleccionar servicio ni política de saldo.
- Integraciones de negocio/broker/jobs: ninguna está evidenciada para este flujo; no se investiga ni incorpora una.
- CQRS, event sourcing o agregado formal: no son necesarios para comprobar FR-006 y orquestación
  aislada; la arquitectura solo contiene propuestas y el modelo DDD los deja indeterminados.
- Plataforma Azure, Terraform, networking y trigger de CD: siguen pendientes para despliegue; no
  bloquean B2/B3 aislados. Respetar restricciones constitucionales sin provisionar ni decidir plataforma.
- OpenTelemetry/exporter, políticas de telemetría y health checks concretos: confirmar con la base
  técnica cuando llegue la integración; no investigar retención/alertas sin objetivos o datos definidos.
- Normativa y NFR: no hay metas medibles ni contexto legal verificado. Mantener LAB-OQ-008/010 y
  Q-015/016/019 abiertos; no aplicar valores de ejemplo de plantillas.

## Fuentes de esta revisión

- [Constitución canónica](../../../.boltf/memory/constitution.md) y [digest](../../../.boltf/memory/constitution.digest.md).
- [Roadmap](../../../docs/roadmap/implementation-roadmap.md), [dominio conceptual](../../../docs/design/ddd/vacation-management/domain-model.md) y [arquitectura propuesta](../../../docs/design/architecture/architecture-overview.md).
- [Requisitos F001](../requirements/requirements.md), [UC-001](../requirements/use-cases/UC-001.md), [Gherkin F001](../tests/submit-vacation-request.feature).
- [Requisitos F002](../../lab-002-validate-vacation-date-range/requirements/requirements.md), [UC-002](../../lab-002-validate-vacation-date-range/requirements/use-cases/UC-002.md), [Gherkin F002](../../lab-002-validate-vacation-date-range/tests/validate-vacation-date-range.feature).
- [Baseline](../../lab/requirements-baseline.md), [aclaraciones](../../clarification-summary.md) y [mockups de F001](../mockups/README.md).

No se han cerrado decisiones técnicas, respondido preguntas de negocio, aprobado requisitos ni generado
código, tareas o contratos como resultado de esta revisión.