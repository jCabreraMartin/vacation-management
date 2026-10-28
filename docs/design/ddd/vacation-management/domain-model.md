# Modelo de dominio conceptual: Gestión de vacaciones

> **Estado:** Draft / LAB-HYP. Modelo hipotético de laboratorio; no aprobado para el producto.
>
> **Alcance:** modelo conceptual de laboratorio a partir de las siete features LAB-HYP, sus casos de
> uso, la [baseline didáctica](../../../../specs/lab/requirements-baseline.md), el
> [resumen de aclaraciones](../../../../specs/clarification-summary.md) y el
> [modelo de estados](../../../../specs/lab-005-approve-vacation-request/requirements/state-model.md).
> No es el modelo completo, una decisión de diseño ni comportamiento aprobado para el producto.

## Contexto delimitado

**Contexto candidato:** Gestión de solicitudes de vacaciones. La evidencia LAB-HYP cubre presentar
una solicitud, validar sus fechas, consultar solicitudes propias, consultar pendientes asignadas,
registrar aprobación o rechazo y retirar una solicitud pendiente (BR-001, FR-001–FR-006, SEC-001).

**Límites del contexto:** Not determinable from the current LAB-HYP evidence; keep as an open question.
Las fuentes no establecen límites frente a otros dominios, equipos responsables ni relaciones
upstream/downstream. La baseline excluye integraciones del ejercicio actual, pero deja abierta su
existencia para el producto real (LAB-OQ-009).

## Conceptos y clasificación DDD

| Área | Resultado respaldado | Aspectos no determinables |
| --- | --- | --- |
| Agregado y raíz | `Solicitud de vacaciones` tiene un ciclo de estado expresado por las reglas del laboratorio. | Not determinable from the current LAB-HYP evidence; keep as an open question. No se especifica límite de consistencia/transacción ni responsabilidad agregada. |
| Entidades e identidad | La solicitud tiene fecha inicial, fecha final, comentario opcional y estado. Empleado y Responsable aprobador son actores/roles. | Not determinable from the current LAB-HYP evidence; keep as an open question. No se define identidad única de solicitud ni identidad/atributos de empleado o responsable; por ello no se afirma qué conceptos son entidades DDD. |
| Value objects | La baseline define una comprobación conjunta: ambas fechas presentes y fecha final no anterior a la inicial. | Not determinable from the current LAB-HYP evidence; keep as an open question. No se definen tipos, igualdad por valor, formato, zona horaria ni reglas completas suficientes para declarar value objects. |
| Servicios de dominio | Las operaciones conocidas son presentar, consultar, aprobar, rechazar y retirar. | Not determinable from the current LAB-HYP evidence; keep as an open question. Ninguna fuente establece una regla que requiera un servicio de dominio separado. |
| Eventos de dominio | El sistema registra el estado resultante de una decisión. | Not determinable from the current LAB-HYP evidence; keep as an open question. No se nombran hechos del dominio como eventos ni consumidores. |
| Puertos de repositorio | Las features requieren registrar y consultar solicitudes en términos funcionales. | Not determinable from the current LAB-HYP evidence; keep as an open question. No se establece una necesidad de abstracción de repositorio ni se prescribe persistencia. |
| Puertos de integración externa | La baseline excluye integraciones del escenario de laboratorio. | No hay integraciones externas evidenciadas para LAB-HYP; no se modelan puertos externos. Para el producto, la cuestión continúa abierta (LAB-OQ-009, Q-017, Q-018). |

La asignación empleado–responsable solo aparece como relación funcional. Su propiedad, origen,
cardinalidad, vigencia y mantenimiento no están definidos (LAB-OQ-003, Q-006, Q-007, Q-014). No se
crea una entidad `Asignación`.

## Relaciones respaldadas

- El Empleado presenta solicitudes, consulta las propias y puede retirar una propia pendiente.
- El Responsable aprobador consulta solicitudes pendientes de empleados asignados y puede aprobar o
  rechazar las que continúan pendientes, si está autorizado.
- La solicitud se relaciona con uno de los estados indicados en el modelo de estados.
- No se representa la decisión como entidad separada: los artefactos solo requieren registrar el
  estado resultante y no definen datos propios de la decisión.
- Las asociaciones no expresan cardinalidades: la asignación y el número de solicitudes/personas no
  están determinados por los artefactos.

## Diagrama conceptual

```mermaid
---
config:
  theme: base
  look: classic
  themeVariables:
    primaryColor: "#e6f4f1"
    primaryTextColor: "#18332d"
    primaryBorderColor: "#52796f"
    lineColor: "#5c6770"
    secondaryColor: "#f1f3f5"
    tertiaryColor: "#fff4e5"
    background: "#ffffff"
    fontSize: "14px"
---
classDiagram
    class "Empleado (rol de actor)" as Empleado
    class "Responsable aprobador (rol de actor)" as ResponsableAprobador
    class "Solicitud de vacaciones" as SolicitudVacaciones {
      fechaInicial
      fechaFinal
      comentarioOpcional
      estado
    }
    class EstadoSolicitud {
        <<enumeration>>
        Pendiente
        Aprobada
        Rechazada
        Retirada
    }

    Empleado --> SolicitudVacaciones : presenta, consulta propias y puede retirar pendientes
    Empleado -- ResponsableAprobador : asignacion mencionada; cardinalidad no definida
    ResponsableAprobador --> SolicitudVacaciones : consulta, aprueba o rechaza pendientes asignadas
    SolicitudVacaciones --> EstadoSolicitud : estado actual

    note for SolicitudVacaciones "Identidad, tipos de datos, igualdad y atributos adicionales no definidos. Agregado o entidad no confirmados."
```

  El diagrama es conceptual: los actores se muestran como roles, no como entidades persistentes. No
  atribuye identidad, límites transaccionales ni multiplicidades.

## Invariantes y reglas LAB-HYP respaldadas

- Una solicitud aceptada contiene fecha inicial y final y comienza en `Pendiente`; el comentario es
  opcional (FR-001, LAB-F001, UC-001).
- Si falta cualquiera de las fechas, o la fecha final es anterior a la inicial, no se crea una
  solicitud pendiente (FR-006, LAB-F002, UC-002).
- Solo una solicitud pendiente puede pasar a `Aprobada` o `Rechazada`, por decisión de un responsable
  autorizado y asignado al empleado (FR-004, SEC-001, LAB-F005/006, UC-005/006).
- Solo el empleado propietario puede retirar una solicitud que sigue `Pendiente`; entonces pasa a
  `Retirada` y deja de aparecer en la consulta de pendientes del responsable (FR-005, SEC-001,
  LAB-F007, UC-007).
- El modelo de estados de laboratorio contempla `Pendiente` → `Aprobada`, `Rechazada` o `Retirada`.
  No se proponen transiciones de salida de esos estados en la baseline; esto no resuelve la política
  del producto (state-model.md, LAB-OQ-006).

Todas son restricciones hipotéticas `Draft / LAB-HYP`, no invariantes aprobadas del producto.

## Glosario ubicuo LAB-HYP

| Término | Uso respaldado en el laboratorio | Estado de definición |
| --- | --- | --- |
| Solicitud de vacaciones | Elemento que el empleado presenta, consulta y cuyo estado decide el responsable. | Campos respaldados: fecha inicial, fecha final, comentario opcional, estado. Identidad y campos adicionales pendientes. |
| Empleado | Actor que presenta y consulta sus solicitudes; puede retirar una propia pendiente. | Rol hipotético; identidad y modelo de usuario no definidos. |
| Responsable aprobador | Actor que consulta pendientes asignadas y aprueba o rechaza solicitudes autorizadas. | Rol hipotético; identidad, autoridad y asignación pendientes. |
| Pendiente | Estado inicial y único estado origen explícito para decisión o retirada. | LAB-HYP; relación con “En revisión” sin resolver. |
| Aprobada / Rechazada / Retirada | Outcomes de aprobación, rechazo y retirada. | Estados finales del ciclo mínimo de laboratorio. Reapertura y edición no propuestas; política real no aprobada. |
| Asignado | Relación que delimita solicitudes visibles y decidibles por responsable. | Propietario, fuente, cardinalidad, vigencia y cambios pendientes. |
| En revisión | Expresión usada al excluir retirar durante una revisión en curso. | No se define como estado ni se aclara si equivale a `Pendiente`. |
| Comentario / motivo de rechazo | Comentario de solicitud opcional; motivo de rechazo no determinado. | Longitud, contenido, obligatoriedad y conservación pendientes. |

## Puertos de dominio

| Tipo de puerto | Resultado |
| --- | --- |
| Repositorio | Not determinable from the current LAB-HYP evidence; keep as an open question. Los casos de uso requieren registrar y consultar solicitudes, pero no justifican una abstracción de repositorio ni definen necesidades de acceso del dominio. No se diseña persistencia. |
| Integración externa | No hay puertos de integración externa evidenciados para el laboratorio. La necesidad del producto permanece abierta (LAB-OQ-009, Q-017, Q-018). |

## Preguntas abiertas

- **Contexto:** ¿qué límites funcionales y relaciones con otros dominios, equipos o sistemas tendría el contexto en el producto? (LAB-OQ-001, Q-001)
- **Agregado/raíz:** Not determinable from the current LAB-HYP evidence; keep as an open question. ¿Qué límite de consistencia y transacción, si alguno, debe proteger las reglas de la solicitud?
- **Entidad/identidad:** Not determinable from the current LAB-HYP evidence; keep as an open question. ¿Qué identificador distingue una solicitud, y qué identidad/datos de empleado y responsable se reconocen? (LAB-OQ-008, Q-013, Q-014)
- **Value objects:** Not determinable from the current LAB-HYP evidence; keep as an open question. ¿Qué tipos, formatos, zona horaria, igualdad y validaciones completas se aplican a fechas y comentario? (LAB-OQ-002, LAB-OQ-004, Q-002)
- **Servicios/eventos:** Not determinable from the current LAB-HYP evidence; keep as an open question. ¿Existen reglas que deban coordinarse fuera de la solicitud o hechos de dominio que deban publicarse? Las fuentes actuales no los establecen.
- **Asignación:** ¿Quién determina y mantiene la relación empleado–responsable, cuál es la fuente de verdad, qué cardinalidades admite y cómo se resuelven sustituciones o cambios de equipo? (LAB-OQ-003, Q-006, Q-007, Q-014)
- **En revisión y ciclo de vida:** ¿“En revisión” es estado distinto de `Pendiente`? ¿Qué permite retirar durante esa situación y qué pasa con solicitudes aprobadas? ¿Se permiten edición, reapertura o reversión, y cómo se conserva el historial de decisiones? (LAB-OQ-006, Q-003, Q-004, Q-016, Q-023)
- **Autorización:** ¿Cómo se identifican los actores y cómo se demuestra que el responsable está asignado y autorizado, o que el empleado es propietario? (SEC-001, LAB-OQ-008, Q-013)
- **Comentarios e historial:** ¿Es obligatorio el motivo de rechazo, qué contenido admite y qué datos de quién/cuándo se conservan para aprobación, rechazo o retirada? (LAB-OQ-007, LAB-OQ-008, Q-011, Q-015, Q-016)
- **Fallo y concurrencia:** ¿Qué comportamiento se espera ante fallo de persistencia, consulta temporalmente no disponible, cambio de estado concurrente o resultado no confirmado? (UC-001, UC-003–UC-007, Q-024)
- **Notificaciones:** ¿Qué canal/contenido tienen las confirmaciones mencionadas por los casos de uso? ¿Se requieren notificaciones de dominio o externas? No están definidas en la baseline (Q-010, Q-017, Q-018).
- **Integraciones:** No hay integraciones externas evidenciadas para LAB-HYP. ¿Hay integraciones para el producto y qué datos, dirección, protocolo y gestión de fallos requerirían? (LAB-OQ-009, Q-017, Q-018)
- **Saldo:** ¿Se debe mostrar o reservar saldo de días, y qué política/fuente lo determinaría? LAB-OQ-005 permanece expresamente abierta y fuera de esta iteración.
- **NFR y aceptación:** ¿Qué umbrales de disponibilidad, rendimiento, capacidad, accesibilidad y frescura de estado se necesitan, y quién valida las reglas y sus pruebas? (LAB-OQ-010, Q-019, Q-020–Q-025)

## Trazabilidad de conceptos y reglas

| Concepto o regla del modelo | Evidencia | Interpretación limitada en este modelo |
| --- | --- | --- |
| Contexto candidato y alcance | BR-001; baseline, sección 1; LAB-F001–F007; UC-001–UC-007 | Agrupación hipotética del flujo de solicitud. Sus límites DDD no están establecidos. |
| Solicitud, fechas y comentario opcional | FR-001; LAB-F001 / US-LAB-F001-01; UC-001 | Datos explícitos; no se añaden tipos ni un identificador. |
| Validación de fechas | FR-006; LAB-F002 / US-LAB-F002-01; UC-002 | Faltante o fin anterior al inicio impide crear estado `Pendiente`; no se modelan otras reglas de calendario. |
| Propiedad y consulta del empleado | FR-002, SEC-001; LAB-F003 / US-LAB-F003-01; UC-003 | El empleado consulta sus propias solicitudes; detalles de identidad no definidos. |
| Asignación y bandeja del responsable | FR-003, SEC-001; LAB-F004 / US-LAB-F004-01; UC-004 | Consultar solo solicitudes pendientes de empleados asignados; no se infieren cardinalidades ni administración de la asignación. |
| Aprobación | FR-004; LAB-F005 / US-LAB-F005-01; UC-005; state-model `Pendiente → Aprobada` | Responsable asignado y autorizado decide una solicitud que continúa pendiente. |
| Rechazo | FR-004; LAB-F006 / US-LAB-F006-01; UC-006; state-model `Pendiente → Rechazada` | Mismas condiciones expresas de estado y autorización; motivo no definido. |
| Retirada | FR-005, FR-002 (parcial), SEC-001; LAB-F007 / US-LAB-F007-01; UC-007; state-model `Pendiente → Retirada` | El empleado propietario retira solo si sigue pendiente; deja de aparecer en la bandeja y puede consultar `Retirada`. |
| Estados y transiciones | Baseline, sección 4; state-model; FR-001, FR-004, FR-005 | Solo `Pendiente`, `Aprobada`, `Rechazada`, `Retirada` aparecen en el ciclo mínimo. “En revisión” no se eleva a estado. |
| Ausencia de integraciones en el modelo LAB-HYP | Baseline, secciones 5–6; LAB-OQ-009; Q-017/Q-018 | No se modelan puertos externos; esto no resuelve necesidades del producto. |

## Fuentes

- [Baseline didáctica](../../../../specs/lab/requirements-baseline.md)
- [LAB-F001 — Presentar solicitud](../../../../specs/lab-001-submit-vacation-request/requirements/requirements.md) y [UC-001](../../../../specs/lab-001-submit-vacation-request/requirements/use-cases/UC-001.md)
- [LAB-F002 — Validar fechas](../../../../specs/lab-002-validate-vacation-date-range/requirements/requirements.md) y [UC-002](../../../../specs/lab-002-validate-vacation-date-range/requirements/use-cases/UC-002.md)
- [LAB-F003 — Consultar solicitudes propias](../../../../specs/lab-003-view-own-vacation-requests/requirements/requirements.md) y [UC-003](../../../../specs/lab-003-view-own-vacation-requests/requirements/use-cases/UC-003.md)
- [LAB-F004 — Consultar pendientes asignadas](../../../../specs/lab-004-view-assigned-pending-requests/requirements/requirements.md) y [UC-004](../../../../specs/lab-004-view-assigned-pending-requests/requirements/use-cases/UC-004.md)
- [LAB-F005 — Aprobar solicitud](../../../../specs/lab-005-approve-vacation-request/requirements/requirements.md) y [UC-005](../../../../specs/lab-005-approve-vacation-request/requirements/use-cases/UC-005.md)
- [LAB-F006 — Rechazar solicitud](../../../../specs/lab-006-reject-vacation-request/requirements/requirements.md) y [UC-006](../../../../specs/lab-006-reject-vacation-request/requirements/use-cases/UC-006.md)
- [LAB-F007 — Retirar solicitud pendiente](../../../../specs/lab-007-withdraw-pending-vacation-request/requirements/requirements.md) y [UC-007](../../../../specs/lab-007-withdraw-pending-vacation-request/requirements/use-cases/UC-007.md)
- [Resumen de aclaraciones](../../../../specs/clarification-summary.md)