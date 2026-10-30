# Feature F-006: Rechazo de solicitudes

## Metadatos

| Propiedad | Valor |
| --- | --- |
| ID de Feature | F-006 |
| Issue | [#13](https://github.com/jCabreraMartin/vacation-management/issues/13) |
| Estado | Draft |
| Prioridad | Pendiente de priorización |
| Aprobación funcional | Pendiente |
| Escenario | fullstack |

## Contexto de negocio

Las fuentes mencionan que un responsable puede rechazar solicitudes y que no se propondrán
alternativas. «Valorar» y «cerrar» no tienen significado confirmado.

## Historia candidata

### US-001: Rechazar una solicitud

**Como** responsable, **quiero** rechazar una solicitud, **para** aplicar el resultado de rechazo citado
en las fuentes sin proponer alternativas.

**Trazabilidad:** BL-RF-006, BL-RF-014, BL-RF-016, BL-RF-046, BL-RF-048.
**Criterio de aceptación:** TBD; actor autorizado, resultado y semántica de «valorar/cerrar» pendientes
(PA-06, PA-14). No se inventa motivo de rechazo.

## Alcance y dependencias

- **Incluye:** registrar la capacidad de rechazo citada, pendiente de aclaración.
- **Excluye por ahora:** motivo, reversión, estados y acción de cierre no confirmados.
- **Dependencias:** relación propuesta con el flujo de F-005, pendiente de PA-05.
- **Preguntas abiertas:** PA-06 y PA-14 del [RFP](../../../origin/RFP-Vacation-Management.md).

## Requisitos no funcionales

No se añaden métricas ni controles de autorización no documentados.

## Evidencia y notas

Fuente de verdad: [baseline](../../../origin/Requirements-Baseline-Vacation-Management.md).

## Decisiones del laboratorio · Paso 16.2, Bolt 1

> Confirmadas por el usuario el 2026-10-30 para avanzar el laboratorio ([#74](https://github.com/jCabreraMartin/vacation-management/issues/74)).
> **No son aprobación del cliente** ni respuesta a PA-06, PA-14 o PA-26, que siguen abiertas. La
> Feature continúa Draft. Las secciones anteriores conservan lo que dicen las fuentes.

| ID | Decisión de laboratorio | Relación con fuentes |
| --- | --- | --- |
| DL-B1-02 | Sin autenticación; actor único «responsable» implícito. Autorización fuera de alcance. | BL-RF-016 cita al responsable; rol y autoridad siguen pendientes (PA-26). |
| DL-B1-03 | Solo una solicitud «Pendiente» puede rechazarse; pasa a «Rechazada», estado terminal. Sin motivo ni reversión. Rechazar una solicitud no pendiente es un error. | Rechazo respaldado por BL-RF-006/016. Estados, terminalidad y error son del laboratorio (PA-14). |
| DL-B1-04 | Solicitudes semilla ficticias con identificador, persona ficticia, fecha de inicio, fecha de fin y estado. | No responde a PA-16 (campos de alta); son datos de laboratorio, no integración. |
| DL-B1-06 | Consultar una solicitud por identificador y rechazarla; sin listado. | Mockups Draft F-006. |

«Valorar» (BL-RF-046) y «cerrar» (BL-RF-048) quedan **fuera** de este Bolt: no se implementan ni se
consideran sinónimos de rechazar (PA-06).

### Criterios de aceptación del laboratorio

1. **AC-LAB-01:** dada una solicitud «Pendiente», el responsable la rechaza y queda «Rechazada».
2. **AC-LAB-02:** una solicitud ya «Rechazada» no puede rechazarse otra vez; se informa del error y no cambia.
3. **AC-LAB-03:** consultar o rechazar un identificador inexistente informa de que no existe.
4. **AC-LAB-04:** al rechazar no se proponen fechas alternativas ni se pide motivo (BL-RF-014; DL-B1-03).
5. **AC-LAB-05:** la interfaz muestra la solicitud, el progreso de la operación, el error y el resultado.

Gherkin: [rechazo-solicitud.feature](../tests/rechazo-solicitud.feature).

Las correcciones A-01…A-05 de [#74](https://github.com/jCabreraMartin/vacation-management/issues/74)
precisan estos AC del laboratorio: rechazo atómico ante concurrencia (AC-LAB-02), protección del uso
local sin identidad corporativa y errores de lectura recuperables con resultado POST desconocido
(AC-LAB-05). No añaden estados, motivo, reversión ni integraciones y no cierran PA-06/14/26.
