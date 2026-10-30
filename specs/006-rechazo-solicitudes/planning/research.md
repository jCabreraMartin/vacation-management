# Research de preparación: F-006 Rechazo de solicitudes

| Propiedad | Estado |
| --- | --- |
| Estado | Feature Draft; preparación histórica del cliente bloqueada; excepción del laboratorio implementada |
| Escenario | `fullstack`; C#/.NET 8; Vue 3 elegido únicamente para el laboratorio |

## Preparación histórica del Paso 13

Las secciones siguientes describen el estado anterior al Bolt de laboratorio. No afirman que hoy
falten código o Gherkin del laboratorio; sus bloqueos siguen vigentes para el alcance del cliente.

### Evidencia

BL-RF-006/014/016 respaldan rechazo/no proponer alternativas; BL-RF-046 y RF-048 contienen «valorar» y
«cerrar» sin interpretación confirmada. US-001 y UC-008 son Draft; state-model bloqueado. PA-06/14/26
siguen abiertas.

### Investigación necesaria tras aclaración del cliente

| Pregunta | Efecto si queda sin resolver |
| --- | --- |
| ¿Qué distingue rechazar, cerrar y cancelar? PA-06/14 | No se puede definir el resultado o estado elegible. |
| ¿Quién está autorizado y qué registra/ve el responsable? PA-26 | No se puede establecer alcance de UI o autorización. |
| ¿Hay motivo, reversión o aviso? | No añadir tales comportamientos sin evidencia; PA-17 si se requiere notificación. |

### Resultado de la preparación histórica

No procede investigar una implementación de workflow, estado, API o seguridad antes de las respuestas.
Los mockups son ilustrativos y no resuelven la semántica. **BLOCKED** hasta requisitos/AC aprobados; no
se generan Issues, contratos o decisiones técnicas.

## Excepción del laboratorio · Bolt 1

El usuario autorizó DL-B1-01…09 exclusivamente para el laboratorio ([#74](https://github.com/jCabreraMartin/vacation-management/issues/74)).
F-006 sigue Draft; PA-06/14/26 siguen abiertas ante el cliente. No se sustituyen las fuentes originales.

Existe un incremento local: Minimal API .NET 8, Vue 3 y repositorio en memoria con datos ficticios;
solo consulta por id y transición Pendiente → Rechazada, sin motivo ni reversión. El
[Gherkin](../tests/rechazo-solicitud.feature) y las pruebas verifican los AC del laboratorio.

La corrección A-01 a A-05 conserva ese alcance: guardado condicional por solicitud, escucha loopback,
escrituras protegidas frente a orígenes ajenos y recuperación explícita de respuestas inciertas sin
reintentar el POST. CI de aplicación preparada con gates 80 %/60 %, sin despliegue. Su validación
local e inspección del workflow no equivalen a ejecución remota de GitHub Actions.

Evidencia actual: [tasks](tasks.md). Auditoría original y seguimiento:
[informe](../../../docs/work-management/f006-bolt-1-audit.md).
