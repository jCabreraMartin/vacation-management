# Baseline de requisitos: Gestión y aprobación de vacaciones

| Propiedad | Valor |
| --- | --- |
| Identificador documental | Requirements-Baseline-Vacation-Management |
| Fecha de elaboración | 2026-10-29 |
| Estado del documento | Draft; pendiente de revisión y aprobación formal |
| Entrada principal | [RFP-Vacation-Management.md](RFP-Vacation-Management.md), versión disponible en la fecha del análisis |
| Alcance | Clasificación trazable de requisitos y pendientes; no diseño, priorización, planificación o aceptación |

## 1. Criterios de extracción y estados

Esta baseline deriva del RFP actual, no del ejercicio hipotético archivado. No utiliza `specs/`,
`docs/design/` ni `docs/roadmap/` como evidencia. Las fuentes originales se referencian para localizar
el contenido recogido por el RFP, no para incorporar nuevas interpretaciones de arquitectura o mockups.
No se modifica el RFP ni las fuentes originales.

### Tipos

| Tipo | Significado y criterio aplicado |
| --- | --- |
| BR | Requisito de negocio: objetivo de aplicación o delimitación de población/alcance. |
| FR | Requisito funcional: capacidad o regla de comportamiento/organización funcional. |
| NFR | Requisito no funcional: cualidad, patrón de uso o exigencia de capacidad. |
| TC | Restricción técnica: condicionante de ejecución o elección tecnológica ya registrada. |
| INT | Requisito de integración: intercambio, dato externo, canal o condición de ese intercambio. |
| SEC | Requisito de seguridad o cumplimiento respaldado por una fuente; no se deduce de un diagrama o configuración. |

El tipo de baseline no depende del prefijo original: RF-008/RF-052 expresan un objetivo general BR;
RNF-009 delimita población BR, no concurrencia; RT-002 expresa estructura funcional FR; RT-005
delimita alcance BR. Los intercambios se clasifican INT aunque procedan de un RF o RT. Esta
clasificación no fusiona entradas ni resuelve la semántica pendiente de su contenido.

### Estados

| Estado literal | Uso |
| --- | --- |
| Draft | Enunciado conservado sin aprobación formal identificada; no necesita resolver una contradicción o significado subjetivo para expresar su núcleo. No significa implementado o aceptado. |
| Clarification needed | Enunciado con ambigüedad, contradicción, subjetividad o relación de solapamiento pendiente de aclaración. Remite a PA-* del RFP. |
| Confirmed | Solo si existe evidencia de aprobación del ítem por una persona con autoridad identificada. No basta su aparición en Discovery, la palabra «confirmados» de S2 o el RFP en borrador. |

**Ningún ítem se marca Confirmed.** El RFP no aporta una aprobación formal de estos requisitos por
una persona cuya autoridad esté acreditada. La selección de Vue.js ya figura como decisión técnica
aceptada G1 en el RFP; el estado Draft de su fila de baseline no revoca ese ADR ni reabre la elección.
Solo evita atribuir a esta baseline una aprobación formal que no consta en su entrada principal.

### Identificadores, evidencia y dependencias

- `BL-RF-nnn`, `BL-RNF-nnn` y `BL-RT-nnn` identifican una fila por cada ID original. Su prefijo
  conserva la trazabilidad; la columna Tipo es la clasificación de baseline. `BL-G1-001` identifica
  separadamente la selección tecnológica que el RFP recoge de G1, fuera de los 67 IDs de S2.
- **TBD** en Evidencia de aceptación significa que las fuentes no definen una evidencia de aceptación
  suficientemente especificada para esa fila. No se inventan casos de prueba, métricas, umbrales o
  muestras. Aunque un enunciado tenga un resultado observable, no se transforma aquí en un criterio
  de aceptación nuevo ni se afirma que exista evidencia obtenida o aceptada.
- **No declaradas** en Dependencias significa que no consta una dependencia explícita para el ítem.
  No significa independencia técnica. Solo se registran condiciones expresas como aprobación antes
  de envío; los solapamientos y contextos no se convierten en prerrequisitos de implementación.
- Las justificaciones explican la finalidad ya expresada en el RFP; no añaden beneficios, obligaciones
  o prioridades. Las relaciones de duplicidad no eliminan ninguna fila.

## 2. Fuentes y localizadores

| Clave | Fuente y localizador resoluble |
| --- | --- |
| RFP | [Informe principal](RFP-Vacation-Management.md). §3.1 necesidades; §3.2 RF; §3.3 RNF; §3.4 restricciones; §3.5 integraciones; §3.7 PA-*; §7 propuestas; anexo C citas T-*; anexos D/E errores y ejemplos. |
| S1 | [RecordedTranscription.txt](discovery/RecordedTranscription.txt). Las citas T-01–T-19 son localizadores del anexo C del RFP que contienen fragmentos literales de S1, no IDs originales del audio. |
| S2 | [Documento Funcional de Requisitos.html](business-notes/Documento%20Funcional%20de%20Requisitos.html), versión interna 1.0, 07/07/2026. §2 RF-001–RF-052, §3 RNF-001–RNF-010, §4 RT-001–RT-005. Cada fila indica el ID exacto. |
| S3 | [Arquitectura.png](reference-images/Arquitectura.png), interpretada por RFP §7 como propuesta, no requisito aprobado. |
| S4 | [mockup web.png](reference-images/mockup%20web.png), valores y etiquetas visuales analizados en RFP anexo E. |
| S5 | [Mockup Web.html](reference-images/Mockup%20Web.html), secciones/JS localizados en RFP §2 y anexo E; prototipo ilustrativo, con posible incompletitud. |
| G1 | Selección Vue.js recogida por RFP §3.4/§7, referencia a [ADR-0004](../docs/adr/ADR-0004-replace-angular-with-vue-frontend.md), apartados Estado y Decisión; versión sin fijar. No fuente nueva de necesidades de negocio. |

Cada fila de las siguientes matrices conserva entrada principal RFP, fuente original y localizador.
Los enlaces PA-* llevan a [RFP §3.7: Preguntas abiertas][preguntas-rfp], donde se identifica la pregunta
por su ID exacto; no se suponen anclas individuales inexistentes para las filas del RFP.

## 3. Matriz de los 52 RF de origen

| Identificador baseline | Tipo | Enunciado del requisito | Fuente e identificador/localizador exacto | Justificación | Evidencia de aceptación | Dependencias | Ambigüedades o conflictos | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BL-RF-001 | FR | Devolver cuántas personas hay en un periodo de tiempo. | RFP §3.2; S2 §2 RF-001; S1 T-03. | Permitir el recuento por periodo solicitado. | TBD | No declaradas. | Población y significado del recuento sin definir; relación RF-041. [PA-08][preguntas-rfp], [PA-04][preguntas-rfp]. | Clarification needed |
| BL-RF-002 | FR | Acceder a una jerarquía organizativa con varios niveles de profundidad. | RFP §3.2; S2 §2 RF-002; S1 T-04. | Consultar la organización que describe la fuente. | TBD | No declaradas. | Fuente/acceso abiertos; contradicción con RF-043 y RT-002. [PA-01][preguntas-rfp], [PA-02][preguntas-rfp]. | Clarification needed |
| BL-RF-003 | FR | Permitir seleccionar un nivel de la jerarquía según la necesidad. | RFP §3.2; S2 §2 RF-003; S1 T-04. | Seleccionar ámbito de consulta. | TBD | No declaradas. | Actor, finalidad y criterio de selección abiertos; relación RF-040. [PA-01][preguntas-rfp], [PA-04][preguntas-rfp]. | Clarification needed |
| BL-RF-004 | FR | Estructurar la población por departamentos. | RFP §3.2; S2 §2 RF-004; S1 T-04/T-05. | Representar la agrupación departamental citada. | TBD | No declaradas. | Duplicado conceptual probable RF-042; profundidad pendiente. [PA-03][preguntas-rfp], [PA-01][preguntas-rfp]. | Clarification needed |
| BL-RF-005 | FR | Poder configurar el periodo en semanas o días. | RFP §3.2; S2 §2 RF-005; S1 T-03. | Expresar las unidades temporales citadas. | TBD | No declaradas. | Contexto/periodo sin concretar; relación RF-044 y diferencia «debe»/«puede». [PA-03][preguntas-rfp], [PA-09][preguntas-rfp]. | Clarification needed |
| BL-RF-006 | FR | Permitir rechazar solicitudes de vacaciones. | RFP §3.2; S2 §2 RF-006; S1 T-11/T-16. | Representar el rechazo citado en el proceso. | TBD | No declaradas. | Actor/condiciones de esta entrada sin definir; solapa RF-016 y parte de RF-048. [PA-04][preguntas-rfp], [PA-06][preguntas-rfp], [PA-14][preguntas-rfp]. | Clarification needed |
| BL-RF-007 | FR | Gestionar cuántas personas pueden estar de vacaciones simultáneamente en un periodo. | RFP §3.2; S2 §2 RF-007; S1 T-03. | Conocer y gestionar concentración de vacaciones. | TBD | No declaradas. | Quién configura, cálculo, límite y efecto no definidos. No se deriva rechazo automático. [PA-08][preguntas-rfp], [PA-10][preguntas-rfp]. | Clarification needed |
| BL-RF-008 | BR | Disponer de una aplicación de aprobación de turnos de vacaciones. | RFP §3.1/§3.2; S2 §2 RF-008; S1 T-01. | Recoger el objetivo de aplicación expresado. | TBD | No declaradas. | Repetición probable RF-052; no descompone datos o reglas. [PA-04][preguntas-rfp], [PA-16][preguntas-rfp]. | Clarification needed |
| BL-RF-009 | FR | Visualizar las semanas de julio con solicitudes del equipo superiores al 70 %, conservando su carácter de ejemplo por validar. | RFP §3.2/anexo E; S2 §2 RF-009; S1 T-12. | Hacer visible la sobresolicitación ejemplificada. | TBD | No declaradas. | Fórmula, ámbito y presentación sin cerrar; no cupo global ni rechazo automático. [PA-08][preguntas-rfp], [PA-09][preguntas-rfp], [PA-21][preguntas-rfp]. | Clarification needed |
| BL-RF-010 | FR | Permitir a responsables ver las vacaciones solicitadas por cada usuario. | RFP §3.2; S2 §2 RF-010; S1 T-12. | Facilitar la consulta por responsables citada. | TBD | No declaradas. | Ámbito/permisos sin concretar; relación con RF-045, no acceso universal. [PA-16][preguntas-rfp], [PA-26][preguntas-rfp]. | Clarification needed |
| BL-RF-011 | FR | Consultar cuándo un empleado ha ido de vacaciones. | RFP §3.2; S2 §2 RF-011; S1 T-12. | Recoger consulta de vacaciones disfrutadas. | TBD | No declaradas. | Actor y periodo histórico sin definir; no equivale a aprobación futura. [PA-16][preguntas-rfp]. | Clarification needed |
| BL-RF-012 | FR | Consultar vacaciones aprobadas de un empleado. | RFP §3.2; S2 §2 RF-012; S1 T-12. | Consultar el resultado de aprobación mencionado. | TBD | No declaradas. | Actor y alcance temporal sin definir; relación con RF-011/RF-013, sin fusión. [PA-16][preguntas-rfp]. | Clarification needed |
| BL-RF-013 | FR | Consultar vacaciones no aprobadas de un empleado. | RFP §3.2; S2 §2 RF-013; S1 T-12. | Consultar la categoría «no aprobadas» citada. | TBD | No declaradas. | No define inclusión de pendientes, rechazadas o canceladas; actor/periodo abiertos. [PA-16][preguntas-rfp]. | Clarification needed |
| BL-RF-014 | FR | No proponer alternativas en el proceso de aceptación/rechazo. | RFP §3.2/§3.4; S2 §2 RF-014; S1 T-11. | Conservar el límite funcional expresado. | TBD | No declaradas. | Qué alternativas y contexto operativo sin cerrar; no afecta a evaluar tecnologías. [PA-14][preguntas-rfp]. | Clarification needed |
| BL-RF-015 | FR | Permitir al usuario cancelar sus solicitudes. | RFP §3.2; S2 §2 RF-015; S1 T-11. | Recoger la capacidad de cancelación del usuario. | TBD | No declaradas. | Estados, plazos y efecto posterior a aprobación abiertos; no inventar flujo de modificación. [PA-14][preguntas-rfp], [PA-15][preguntas-rfp]. | Clarification needed |
| BL-RF-016 | FR | Permitir al responsable rechazar solicitudes. | RFP §3.2; S2 §2 RF-016; S1 T-11. | Recoger el actor de rechazo citado. | TBD | No declaradas. | Condiciones y relación RF-006/RF-048 sin cerrar. [PA-04][preguntas-rfp], [PA-06][preguntas-rfp], [PA-14][preguntas-rfp]. | Clarification needed |
| BL-RF-017 | FR | Notificar a usuarios cuando se aprueban sus solicitudes. | RFP §3.2; S2 §2 RF-017; S1 T-11. | Comunicar el evento de aprobación citado. | TBD | Evento aprobación, expresado en RF-017; no dependencia de entrega declarada. | Aprobación parcial/final, contenido y canal por evento abiertos. [PA-05][preguntas-rfp], [PA-17][preguntas-rfp]. | Clarification needed |
| BL-RF-018 | FR | Notificar a usuarios cuando se cancelan sus solicitudes. | RFP §3.2; S2 §2 RF-018; S1 T-11. | Comunicar el evento de cancelación citado. | TBD | Evento cancelación, expresado en RF-018; no dependencia de entrega declarada. | Contenido/canal abiertos; no equiparar cancelación con rechazo. [PA-14][preguntas-rfp], [PA-17][preguntas-rfp]. | Clarification needed |
| BL-RF-019 | FR | Disponer de un proceso de cancelación. | RFP §3.2; S2 §2 RF-019; S1 T-11. | Recoger el proceso expresamente pedido. | TBD | No declaradas. | Entidad y funcionamiento sin definir; relación RF-015/RF-018. [PA-14][preguntas-rfp], [PA-15][preguntas-rfp]. | Clarification needed |
| BL-RF-020 | INT | Realizar descarga nocturna de actualizaciones. | RFP §3.2/§3.5; S2 §2 RF-020; S1 T-10. | Recoger la actualización periódica citada. | TBD | No declaradas. | Hora, alcance y frecuencia detallada por intercambio abiertos; no extender a todos los flujos. [PA-18][preguntas-rfp]. | Clarification needed |
| BL-RF-021 | INT | Enviar a ServiceNow un listado de vacaciones aprobadas. | RFP §3.2/§3.5; S2 §2 RF-021; S1 T-10. | Trasladar el listado aprobado al sistema citado. | TBD | Aprobaciones previas exigidas expresamente por RF-023. | Momento, frecuencia, formato y mecanismo sin definir. [PA-05][preguntas-rfp], [PA-18][preguntas-rfp]. | Clarification needed |
| BL-RF-022 | INT | Incluir únicamente vacaciones aprobadas en el listado enviado a ServiceNow. | RFP §3.2/§3.5; S2 §2 RF-022; S1 T-10. | Delimitar el contenido del intercambio citado. | TBD | Listado de envío descrito por RF-021, al que RF-022 se refiere. | Aprobación completa y efecto de cambios posteriores abiertos; no implica regla local de estados. [PA-05][preguntas-rfp], [PA-18][preguntas-rfp]. | Clarification needed |
| BL-RF-023 | FR | Obtener aprobación de cada responsable requerido antes del envío a ServiceNow. | RFP §3.2/§3.5; S2 §2 RF-023; S1 T-02/T-10. | Conservar la condición de aprobación previa al envío. | TBD | Aprobaciones antes de enviar: condición expresa de RF-023; orden entre responsables no declarado. | Quiénes, cuántos, orden/paralelismo y relación con alarma abiertos. [PA-05][preguntas-rfp]. | Clarification needed |
| BL-RF-024 | FR | Permitir probar la aplicación mediante un enlace en una primera etapa. | RFP §3.2/§7; S2 §2 RF-024; S1 T-09. | Facilitar la prueba inicial por enlace mencionada. | TBD | No declaradas. | Funcionalidad, destinatarios y acceso no definidos; no implica acceso anónimo. [PA-22][preguntas-rfp]. | Clarification needed |
| BL-RF-025 | FR | Incorporar tarjetas adaptativas en una etapa posterior. | RFP §3.2/§7; S2 §2 RF-025; S1 T-09. | Conservar la evolución posterior mencionada. | TBD | Etapa posterior, sin prerrequisito técnico o fecha declarados. | Alcance/propósito/momento abiertos; no se impone primera entrega ni implementación concreta. [PA-22][preguntas-rfp]. | Clarification needed |
| BL-RF-026 | FR | Disponer de un enlace que permita navegar a la aplicación. | RFP §3.2; S2 §2 RF-026; S1 T-09. | Facilitar la navegación expresamente solicitada. | TBD | No declaradas. | No se fija URL ni autenticación. [PA-22][preguntas-rfp] trata acceso/prueba; no altera el núcleo de enlace navegable. | Draft |
| BL-RF-027 | INT | Enviar información por correo electrónico. | RFP §3.2/§3.5; S2 §2 RF-027; S1 T-08. | Conservar el canal priorizado en Discovery. | TBD | No declaradas. | Información/eventos/destinatarios sin definir; no aporta retención o auditoría. [PA-17][preguntas-rfp]. | Clarification needed |
| BL-RF-028 | INT | Poder enviar información opcionalmente por Teams. | RFP §3.2/§3.5; S2 §2 RF-028; S1 T-08/T-09. | Conservar la opcionalidad de canal citada. | TBD | No declaradas. | Qué información, cuándo, destinatarios y activación de opción abiertos. [PA-17][preguntas-rfp], [PA-22][preguntas-rfp]. | Clarification needed |
| BL-RF-029 | INT | Contemplar la preferencia de enviar alarmas por correo o Teams, expresada como «debería». | RFP §3.2/§3.5; S2 §2 RF-029; S1 T-08. | Conservar la modalidad de la fuente sin endurecerla. | TBD | No declaradas. | No define uno/ambos canales; correo primero y Teams opcional no completan matriz de eventos. [PA-17][preguntas-rfp]. | Clarification needed |
| BL-RF-030 | FR | Permitir al responsable departamental aprobar solicitudes. | RFP §3.2; S2 §2 RF-030; S1 T-02/T-07. | Recoger la intervención departamental citada. | TBD | No declaradas. | Relación con aprobación de proyecto y alarma por demora abierta. [PA-05][preguntas-rfp], [PA-13][preguntas-rfp]. | Clarification needed |
| BL-RF-031 | FR | Permitir delegar aprobación en otras personas del mismo proyecto. | RFP §3.2; S2 §2 RF-031; S1 T-07. | Conservar la delegación dentro del proyecto expresada. | TBD | No declaradas. | Quién delega, condiciones, duración, revocación y alcance abiertos; relación RF-035. [PA-12][preguntas-rfp], [PA-04][preguntas-rfp]. | Clarification needed |
| BL-RF-032 | FR | Generar alarma al responsable departamental si una solicitud no se aprueba en un tiempo determinado. | RFP §3.2; S2 §2 RF-032; S1 T-07/T-08. | Recoger el aviso por demora pedido. | TBD | Solicitud sin aprobar durante un plazo sin definir: condición expresa de RF-032. | Tiempo, origen del cómputo, calendario y comportamiento/canal abiertos; sin SLA o aprobación automática. [PA-13][preguntas-rfp], [PA-17][preguntas-rfp]. | Clarification needed |
| BL-RF-033 | FR | Contemplar un aprobador de proyecto para solicitudes. | RFP §3.2; S2 §2 RF-033; S1 T-07. | Recoger la función de aprobación de proyecto citada. | TBD | No declaradas. | Acciones y flujo exacto sin definir; relación RF-047/RF-050. [PA-05][preguntas-rfp]. | Clarification needed |
| BL-RF-034 | FR | Contemplar al menos un aprobador en departamentos grandes, de aproximadamente 50 personas, según el enunciado pendiente de validar. | RFP §3.2; S2 §2 RF-034; S1 T-14. | Preservar el contenido sin convertir una pregunta en umbral. | TBD | No declaradas. | «Grandes» subjetivo y 50 como ejemplo/regla no aclarado; S1 es dubitativa. [PA-11][preguntas-rfp]. | Clarification needed |
| BL-RF-035 | FR | Permitir delegación del aprobador de vacaciones. | RFP §3.2; S2 §2 RF-035; S1 T-07. | Recoger la capacidad de delegación enumerada. | TBD | No declaradas. | Condiciones/alcance abiertos; posible solapamiento con RF-031, sin fusionar. [PA-04][preguntas-rfp], [PA-12][preguntas-rfp]. | Clarification needed |
| BL-RF-036 | INT | Obtener de ServiceNow qué personas pertenecen al departamento. | RFP §3.2/§3.5; S2 §2 RF-036; S1 T-06. | Obtener la pertenencia departamental citada. | TBD | No declaradas. | Condiciones/ámbito y fuente de verdad frente a RF-037 abiertos. [PA-02][preguntas-rfp], [PA-18][preguntas-rfp]. | Clarification needed |
| BL-RF-037 | INT | Obtener de Active Directory qué personas pertenecen al departamento, según el enunciado en conflicto. | RFP §3.2/§3.5; S2 §2 RF-037; contraste S1 T-06. | Preservar la alternativa de fuente sin decidirla. | TBD | No declaradas. | S1 atribuye pertenencia a ServiceNow; no elegir origen ni sincronización cruzada. [PA-02][preguntas-rfp]. | Clarification needed |
| BL-RF-038 | INT | Obtener quién es responsable de cada proyecto. | RFP §3.2/§3.5; S2 §2 RF-038; S1 T-06. | Obtener la relación organizativa solicitada. | TBD | No declaradas. | Fuente/alcance sin definir en RF-038; S1 cita AD, sin cerrar contrato ni cantidad de proyectos. [PA-02][preguntas-rfp], [PA-07][preguntas-rfp]. | Clarification needed |
| BL-RF-039 | INT | Obtener quiénes están bajo responsabilidad de cada responsable de proyecto. | RFP §3.2/§3.5; S2 §2 RF-039; S1 T-06. | Obtener la relación con responsables citada. | TBD | No declaradas. | Relación jerárquica/fuente imprecisas; no implica pertenencia única a proyecto. [PA-02][preguntas-rfp], [PA-07][preguntas-rfp]. | Clarification needed |
| BL-RF-040 | FR | Seleccionar un nivel de estructura organizativa según interés del usuario. | RFP §3.2; S2 §2 RF-040; S1 T-04. | Seleccionar ámbito organizativo de consulta. | TBD | No declaradas. | Niveles/representación abiertos; relación RF-003 y conflicto de profundidad. [PA-01][preguntas-rfp], [PA-04][preguntas-rfp]. | Clarification needed |
| BL-RF-041 | FR | Devolver cuántas personas corresponden al nivel seleccionado en un periodo concreto. | RFP §3.2; S2 §2 RF-041; S1 T-03/T-04. | Recoger el recuento por nivel expresado. | TBD | No declaradas. | Qué personas corresponden y cálculo del periodo abiertos; relación RF-001. [PA-08][preguntas-rfp], [PA-04][preguntas-rfp]. | Clarification needed |
| BL-RF-042 | FR | Organizar la estructura de población por departamentos. | RFP §3.2; S2 §2 RF-042; contexto S1 T-04/T-05. | Preservar la agrupación de esta entrada original. | TBD | No declaradas. | Duplicado conceptual probable RF-004; sin consolidación aprobada. [PA-03][preguntas-rfp], [PA-01][preguntas-rfp]. | Clarification needed |
| BL-RF-043 | FR | Tener un solo nivel de estructura organizativa, según el enunciado cuestionado. | RFP §3.2; S2 §2 RF-043; S1 T-04. | Conservar el supuesto estructural para revisión. | TBD | No declaradas. | «Se supone» y pregunta de S1 no confirman un nivel; contradicción RF-002/RT-002. [PA-01][preguntas-rfp]. | Clarification needed |
| BL-RF-044 | FR | Poder configurar el periodo en semanas o días. | RFP §3.2; S2 §2 RF-044; S1 T-03. | Conservar esta entrada de unidades temporales. | TBD | No declaradas. | Contexto/condiciones abiertos y duplicado probable RF-005 con distinta modalidad. [PA-03][preguntas-rfp], [PA-09][preguntas-rfp]. | Clarification needed |
| BL-RF-045 | FR | Permitir al responsable de proyecto ver solicitudes de vacaciones. | RFP §3.2; S2 §2 RF-045; S1 T-03/T-12. | Facilitar la consulta del responsable citado. | TBD | No declaradas. | Relación RF-010 y ámbito de consulta sin cerrar; no acceso global. [PA-16][preguntas-rfp], [PA-26][preguntas-rfp]. | Clarification needed |
| BL-RF-046 | FR | Permitir al responsable de proyecto valorar solicitudes de vacaciones. | RFP §3.2; S2 §2 RF-046; S1 T-16. | Preservar la acción denominada «valorar». | TBD | No declaradas. | Término subjetivo/impreciso; no decidir puntuación, comentario o validación. [PA-06][preguntas-rfp]. | Clarification needed |
| BL-RF-047 | FR | Permitir al responsable de proyecto aprobar solicitudes de vacaciones. | RFP §3.2; S2 §2 RF-047; S1 T-02/T-03. | Recoger aprobación del responsable de proyecto. | TBD | No declaradas. | Relación RF-050; orden y responsables necesarios abiertos. [PA-05][preguntas-rfp]. | Clarification needed |
| BL-RF-048 | FR | Permitir al responsable de proyecto rechazar o cerrar solicitudes, manteniendo «cerrar» como interpretación no confirmada. | RFP §3.2/anexo D; S2 §2 RF-048; S1 T-16/T-11. | Preservar el contenido y su duda de transcripción. | TBD | No declaradas. | «Echa cerrar colecciones» no identifica acción de cierre; rechazo tiene respaldo independiente. [PA-06][preguntas-rfp], [PA-14][preguntas-rfp]. | Clarification needed |
| BL-RF-049 | FR | Permitir al responsable departamental conocer cuánta gente está de vacaciones en todo el departamento. | RFP §3.2; S2 §2 RF-049; S1 T-03. | Conocer concentración departamental citada. | TBD | No declaradas. | Periodo/reporte sin definir; distinguir solicitadas, aprobadas y disfrutadas. [PA-08][preguntas-rfp], [PA-18][preguntas-rfp]. | Clarification needed |
| BL-RF-050 | FR | Aprobar solicitudes a nivel de proyecto. | RFP §3.2; S2 §2 RF-050; S1 T-02. | Preservar el ámbito de aprobación pedido. | TBD | No declaradas. | Relación RF-033/RF-047 y precedencia con departamento abiertas. [PA-05][preguntas-rfp]. | Clarification needed |
| BL-RF-051 | FR | Aprobar solicitudes a nivel departamental. | RFP §3.2; S2 §2 RF-051; S1 T-02. | Preservar el ámbito departamental de aprobación. | TBD | No declaradas. | Relación RF-030 y condición RF-023; número/orden abiertos. [PA-05][preguntas-rfp]. | Clarification needed |
| BL-RF-052 | BR | Disponer de una aplicación de aprobación de turnos de vacaciones. | RFP §3.1/§3.2; S2 §2 RF-052; S1 T-01. | Conservar el objetivo repetido sin eliminar su ID. | TBD | No declaradas. | Repetición probable RF-008, pendiente consolidación; no capacidad adicional decidida. [PA-04][preguntas-rfp]. | Clarification needed |

## 4. Matriz de los 10 RNF de origen

| Identificador baseline | Tipo | Enunciado del requisito | Fuente e identificador/localizador exacto | Justificación | Evidencia de aceptación | Dependencias | Ambigüedades o conflictos | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BL-RNF-001 | NFR | Soportar 500 usuarios a la vez, como exigencia separada pendiente de validación. | RFP §3.3/PA-19; S2 §3 RNF-001; contraste S1 T-01. | Conservar la exigencia de capacidad de S2 sin derivarla de población. | TBD | No declaradas. | S1 cita 500 personas, no concurrencia. Carga, operaciones, duración y rendimiento abiertos. [PA-19][preguntas-rfp]. | Clarification needed |
| BL-RNF-002 | NFR | Mostrar «de manera muy visual» cuándo un periodo está sobresolicitado. | RFP §3.3; S2 §3 RNF-002; S1 T-12. | Conservar la intención de reconocimiento visual. | TBD | No declaradas. | Subjetividad y fórmula sin criterio medible; RF-009 no fija cap global. [PA-21][preguntas-rfp], [PA-08][preguntas-rfp], [PA-09][preguntas-rfp]. | Clarification needed |
| BL-RNF-003 | NFR | Permitir a responsables ver «de manera sencilla» vacaciones solicitadas por usuario. | RFP §3.3; S2 §3 RNF-003; S1 T-12. | Conservar la intención de facilidad de consulta. | TBD | No declaradas. | «Sencilla» carece de criterio medible; no inventar clics o tiempos. [PA-21][preguntas-rfp]. | Clarification needed |
| BL-RNF-004 | NFR | Permitir al usuario ver calendarios «fácilmente». | RFP §3.3; S2 §3 RNF-004; S1 T-12. | Conservar la intención de facilidad al consultar calendarios. | TBD | No declaradas. | Tareas y medidas de facilidad sin definir. [PA-21][preguntas-rfp]. | Clarification needed |
| BL-RNF-005 | NFR | Ser «fácil de ver». | RFP §3.3; S2 §3 RNF-005; S1 T-12. | Conservar la intención de legibilidad y percepción visual. | TBD | No declaradas. | Subjetivo; no define accesibilidad, contraste, fuente o dispositivo. [PA-21][preguntas-rfp]. | Clarification needed |
| BL-RNF-006 | NFR | No exigir sincronización en tiempo real. | RFP §3.3/§3.5; S2 §3 RNF-006; S1 T-10. | Conservar la ausencia explícita de exigencia de tiempo real. | TBD | No declaradas. | El núcleo no exige tiempo real; [PA-18][preguntas-rfp] mantiene cadencia/alcance de cada intercambio abiertos. No prohíbe interacción inmediata en la aplicación. | Draft |
| BL-RNF-007 | NFR | Ajustar capacidad a demanda estacional, con temporadas de poco uso y picos como Navidad. | RFP §3.3; S2 §3 RNF-007; S1 T-13. | Recoger la variación estacional de uso citada. | TBD | No declaradas. | Sin carga, latencia o calendario cuantificados; relación RNF-010. [PA-20][preguntas-rfp], [PA-19][preguntas-rfp]. | Clarification needed |
| BL-RNF-008 | NFR | Optimizar costes operativos para evitar pagos innecesarios. | RFP §3.3; S2 §3 RNF-008; S1 T-13. | Conservar la intención de coste expresada. | TBD | No declaradas. | Sin presupuesto, ahorro objetivo o medida de éxito; no inventar infraestructura. [PA-20][preguntas-rfp]. | Clarification needed |
| BL-RNF-009 | BR | Contemplar una población departamental de aproximadamente 500 personas. | RFP §3.1/§3.3; S2 §3 RNF-009; S1 T-01. | Delimitar la población a la que se refiere el negocio. | TBD | No declaradas. | La fuente RNF mezcla posibles modelos de uso; solo población respaldada por S1, distinta de RNF-001. [PA-19][preguntas-rfp]. | Clarification needed |
| BL-RNF-010 | NFR | Contemplar un patrón estacional de uso del sistema. | RFP §3.3; S2 §3 RNF-010; S1 T-13. | Conservar el patrón de uso enumerado, sin fusionarlo con RNF-007. | TBD | No declaradas. | Periodos e impacto sin cuantificar; solapamiento RNF-007. [PA-20][preguntas-rfp]. | Clarification needed |

## 5. Matriz de los 5 RT de origen y referencia tecnológica G1

| Identificador baseline | Tipo | Enunciado del requisito | Fuente e identificador/localizador exacto | Justificación | Evidencia de aceptación | Dependencias | Ambigüedades o conflictos | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BL-RT-001 | INT | Acceder a información organizativa de Active Directory para obtener estructura. | RFP §3.4/§3.5; S2 §4 RT-001; S1 T-06. | Obtener datos organizativos de la fuente citada. | TBD | No declaradas. | Atributos/acceso y relación con ServiceNow abiertos; no elige IdP o login. [PA-02][preguntas-rfp], [PA-24][preguntas-rfp]. | Clarification needed |
| BL-RT-002 | FR | Tener un único nivel de estructura para la población, como enunciado en conflicto. | RFP §3.4; S2 §4 RT-002; S1 T-04. | Preservar la restricción organizativa para revisión, no decidir arquitectura. | TBD | No declaradas. | Contradice RF-002 y repite supuesto RF-043. Tipo FR por estructura funcional, significado pendiente. [PA-01][preguntas-rfp]. | Clarification needed |
| BL-RT-003 | TC | Desplegar en infraestructura cloud existente, citándose Azure o Amazon. | RFP §3.4/§4; S2 §4 RT-003; S1 T-13. | Conservar el condicionante de infraestructura de la fuente. | TBD | Infraestructura existente mencionada por RT-003, sin plataforma/servicio concreto. | Azure disponible y propuesto no es nueva selección en baseline; destino/topología abiertos. [PA-24][preguntas-rfp]. | Clarification needed |
| BL-RT-004 | INT | Integrar la nueva aplicación con sistemas o infraestructura existente. | RFP §3.4/§3.5; S2 §4 RT-004; S1 T-06/T-10. | Conservar el condicionante general de integración. | TBD | Sistemas existentes, sin prerrequisitos concretos declarados en RT-004. | Enunciado genérico; contratos/direcciones/cadencias sin cerrar. [PA-02][preguntas-rfp], [PA-18][preguntas-rfp], [PA-24][preguntas-rfp]. | Clarification needed |
| BL-RT-005 | BR | Limitar el uso de la aplicación a un departamento. | RFP §3.1/§3.4; S2 §4 RT-005; S1 T-05. | Conservar el alcance departamental expresado. | TBD | No declaradas. | Selector multidepartamento de S5 es ilustrativo, no ampliación de alcance; [PA-25][preguntas-rfp]. | Draft |
| BL-G1-001 | TC | Usar Vue.js en frontend, sin fijar versión en esta baseline. | RFP §3.4/§7, G1; ADR-0004, Estado y Decisión. | Registrar la elección técnica ya recogida por el RFP, no inferirla de un mockup. | TBD | No declaradas. | Versión pendiente [PA-27][preguntas-rfp]. Draft es estado de esta fila de baseline, no revocación de la decisión G1; no nueva elección técnica. | Draft |

## 6. Seguridad, propuestas y exclusiones de evidencia

**SEC: 0 ítems.** El RFP no respalda un requisito de seguridad o cumplimiento específico que pueda
incorporarse sin inferencia. Acceso organizativo a AD no selecciona autenticación. Roles, autenticación,
logs, alertas y trazabilidad que aparecen en S2 §5/S3 son propuesta, no obligaciones de seguridad
aprobadas o controles deducibles. No se añaden GDPR, HIPAA, RBAC, MFA, cifrado, retención, niveles
de acceso o pruebas negativas de seguridad desde configuración o material archivado.

La mención de correo como medio que «permite auditoría» y la desaparición de Teams «al cabo de x días»
se conservan como explicación del interlocutor, no política de conservación ni SEC. Véanse RFP anexo D
y [PA-17][preguntas-rfp]/[PA-24][preguntas-rfp]. Los actores citados en requisitos funcionales no
constituyen por sí mismos una matriz completa de permisos.

No se elevan a baseline las capas, monolito modular, base de datos transaccional, procesos concretos,
reintentos, herramientas o servicios propuestos por S2 §5/S3. G1 está separado por ser una selección
que el propio RFP identifica como ya tomada, no por la propuesta visual.

Los valores 12 personas, 38/50, 65 % y 80 %, horarios 02:00/02:15/02:30, nombres/proyectos, botones,
motivo visible y simulaciones JavaScript de S4/S5 no aportan nuevos ítems. El 70 % tiene respaldo
como ejemplo de julio en RF-009, no como cupo global o rechazo automático. Las cifras de ejemplo
600/1000/cuatro personas no sustituyen al departamento de 500 personas ni a la demanda concurrente
separada de RNF-001. Fuente: RFP anexos D/E y [PA-08][preguntas-rfp], [PA-09][preguntas-rfp],
[PA-19][preguntas-rfp], [PA-25][preguntas-rfp].

## 7. Comprobaciones finales

### 7.1. Cobertura de los identificadores originales

| Conjunto de origen S2 | IDs esperados | Filas baseline | Representados | Omitidos |
| --- | --- | --- | --- | --- |
| RF | RF-001–RF-052, 52 entradas | BL-RF-001–BL-RF-052 | 52, una fila por ID | Ninguno |
| RNF | RNF-001–RNF-010, 10 entradas | BL-RNF-001–BL-RNF-010 | 10, una fila por ID | Ninguno |
| RT | RT-001–RT-005, 5 entradas | BL-RT-001–BL-RT-005 | 5, una fila por ID | Ninguno |
| Total S2 | 67 IDs | 67 filas | 67 | Ninguno |
| Referencia adicional del RFP | G1, selección Vue.js | BL-G1-001 | 1 | No pertenece a los 67 IDs S2 |

Hay **68 ítems de baseline**, no 68 necesidades independientes ni 68 capacidades aprobadas.
Los duplicados de fuente están representados intencionadamente en filas distintas, sin doble conteo
como requisitos nuevos al consolidar en el futuro. No se ha eliminado ni renumerado ningún ID original.

### 7.2. Duplicados y solapamientos para revisión

| Grupo de origen | Relación probable, sin consolidación silenciosa | Pregunta/localizador RFP |
| --- | --- | --- |
| RF-004 / RF-042 | Agrupación por departamentos repetida. | [PA-03][preguntas-rfp]. |
| RF-005 / RF-044 | Periodos en semanas/días repetidos, con diferencia de modalidad «debe»/«puede». | [PA-03][preguntas-rfp], [PA-09][preguntas-rfp]. |
| RF-008 / RF-052 | Objetivo de aplicación de aprobación repetido; ambas filas BR conservadas. | [PA-04][preguntas-rfp]. |
| RF-003 / RF-040 | Selección de nivel organizativo, ámbitos por aclarar. | [PA-04][preguntas-rfp], [PA-01][preguntas-rfp]. |
| RF-001 / RF-041 | Recuento genérico frente a recuento por nivel; posible especialización. | [PA-04][preguntas-rfp], [PA-08][preguntas-rfp]. |
| RF-006 / RF-016 / RF-048 | Rechazo genérico/por responsable; RF-048 contiene además cierre no confirmado. | [PA-04][preguntas-rfp], [PA-06][preguntas-rfp], [PA-14][preguntas-rfp]. |
| RF-031 / RF-035 | Delegación específica de proyecto frente a delegación genérica. | [PA-04][preguntas-rfp], [PA-12][preguntas-rfp]. |
| RF-010 / RF-045 | Consulta por responsables frente a responsable de proyecto; no permisos equivalentes asumidos. | RFP §3.2, [PA-16][preguntas-rfp], [PA-26][preguntas-rfp]. |
| RF-011 / RF-012 / RF-013 | Consulta de vacaciones pasadas, aprobadas y no aprobadas; no se unifican estados o histórico. | RFP §3.2, [PA-16][preguntas-rfp]. |
| RF-023 / RF-030 / RF-033 / RF-047 / RF-050 / RF-051 | Condición de aprobación completa, actores y niveles relacionados; no capacidades o aprobadores adicionales inferidos. | [PA-05][preguntas-rfp]. |
| RF-015 / RF-018 / RF-019 | Acción, evento notificado y proceso de cancelación relacionados, no duplicados exactos. | [PA-14][preguntas-rfp], [PA-17][preguntas-rfp]. |
| RF-017 / RF-018 / RF-027 / RF-028 / RF-029 / RF-032 | Eventos, canales y alarma: matriz aún incompleta, no una obligación multicanal por cada evento. | [PA-13][preguntas-rfp], [PA-17][preguntas-rfp]. |
| RF-036 / RF-037 / RF-038 / RF-039 / RT-001 / RT-004 | Datos organizativos e integración genérica; relación y posible conflicto de fuentes, no nueva sincronización cruzada. | [PA-02][preguntas-rfp], [PA-18][preguntas-rfp], [PA-24][preguntas-rfp]. |
| RF-043 / RT-002 | Nivel único repetido bajo distinta categoría original; ambas filas FR conservadas. | [PA-01][preguntas-rfp]. |
| RNF-007 / RNF-010 | Escalabilidad estacional y patrón estacional relacionados, sin borrar entradas. | RFP §3.3, [PA-20][preguntas-rfp]. |
| RF-020 / RNF-006 | Descarga nocturna y ausencia de tiempo real son compatibles; faltan contratos por intercambio, no es contradicción demostrada. | [PA-18][preguntas-rfp]. |

### 7.3. Contradicciones y discrepancias no resueltas

| Contenido en conflicto o discrepancia | Ítems afectados / tratamiento | Pregunta RFP |
| --- | --- | --- |
| Varios niveles frente a nivel único supuesto | BL-RF-002 frente a BL-RF-043/BL-RT-002; selección BL-RF-003/BL-RF-040 y recuento BL-RF-041 afectados. No elegir una estructura. | [PA-01][preguntas-rfp]. |
| ServiceNow frente a AD como fuente de pertenencia departamental | BL-RF-036/BL-RF-037 y contexto BL-RT-001: S1 T-06 asigna pertenencia a ServiceNow; RF-037 la atribuye a AD. No decidir precedencia de datos. | [PA-02][preguntas-rfp]. |
| 500 personas frente a afirmación de 500 concurrentes | BL-RNF-009, población BR, y BL-RNF-001, capacidad NFR, permanecen separados. Pueden ser compatibles, pero una cifra no demuestra la otra. | [PA-19][preguntas-rfp]. |
| Todos los responsables antes del envío frente a posible sustitución por alarma | BL-RF-023/BL-RF-030/BL-RF-032/BL-RF-050/BL-RF-051; no resolver orden, sustitución o acumulación de aprobaciones. Es ambigüedad de flujo, no contradicción resuelta. | [PA-05][preguntas-rfp], [PA-13][preguntas-rfp]. |
| Uso departamental frente a selector multidepartamento del mockup | BL-RT-005 mantiene alcance de S1/RT-005; S5 es ilustración, no requisito competidor aprobado. | [PA-25][preguntas-rfp]. |
| Julio y 70 % frente a periodos configurables | BL-RF-005/BL-RF-009/BL-RF-044: aclarar si regla, configuración o ejemplo; no convertir el caso de julio en límite universal. | [PA-08][preguntas-rfp], [PA-09][preguntas-rfp]. |

### 7.4. Totales por tipo y estado

Conteo de **filas**, incluidos los duplicados documentales conservados y BL-G1-001. No equivale a
prioridades, esfuerzo, número de features o aprobación de capacidades.

| Tipo | Draft | Clarification needed | Confirmed | Total |
| --- | --- | --- | --- | --- |
| BR | 1 | 3 | 0 | 4 |
| FR | 1 | 40 | 0 | 41 |
| NFR | 1 | 8 | 0 | 9 |
| TC | 1 | 1 | 0 | 2 |
| INT | 0 | 12 | 0 | 12 |
| SEC | 0 | 0 | 0 | 0 |
| Total | 4 | 64 | 0 | 68 |

Las cuatro filas Draft son BL-RF-026, BL-RNF-006, BL-RT-005 y BL-G1-001. Todas las evidencias de
aceptación permanecen TBD. Ningún estado reconoce aprobación formal por autoridad no identificada.

### 7.5. Contenido que no admite clasificación como requisito sin aclaración

Los 67 IDs originales sí reciben un tipo de trabajo. Esto no resuelve los enunciados ambiguos:
BL-RF-046/BL-RF-048 son FR por la intención de acción descrita, pero no permiten definir qué es
«valorar» o «cerrar». BL-RNF-009 y BL-RT-002 tienen clasificación razonada, distinta de su categoría
original, y permanecen Clarification needed. No se crean filas de requisito para términos sin contenido
suficiente; se conserva a continuación su trazabilidad para revisión.

| Fragmento/elemento de fuente | Por qué no se incorpora como requisito adicional clasificado | Localizador y pregunta RFP |
| --- | --- | --- |
| «Google» | No se identifica si es sistema real o error; no permite afirmar una integración INT. | RFP anexo D; S1 T-04; [PA-23][preguntas-rfp]. |
| «myscaturing» / «refworkings» | Sistema/herramienta o término no identificado; no se define intercambio o capacidad. | RFP anexo D; S1 T-17 y pasaje de chat junto a T-09; [PA-23][preguntas-rfp]. |
| «envity» | No define MVP, entidad, requisito o entregable. | RFP anexo D; S1 T-19; [PA-22][preguntas-rfp], [PA-23][preguntas-rfp]. |
| «5040 proyectos» | Cantidad corrupta/no confirmada; no puede generar requisito de volumen, cardinalidad o capacidad. | RFP anexo D; S1 T-15; [PA-07][preguntas-rfp]. |
| «Echa cerrar colecciones» / «valorar» | La entrada RF-048/RF-046 se conserva como FR pendiente, pero una operación adicional de cierre o valoración definida no puede extraerse de esos términos. | RFP §3.2/anexo D; S1 T-16; [PA-06][preguntas-rfp]. |
| Pasaje de «Barcelona» / «Una nueva» | No permite reconstruir edición o nueva solicitud tras cancelación. | RFP anexo D; S1 T-18; [PA-15][preguntas-rfp]. |
| Correo «permite auditoría» y Teams desaparece «al cabo de x días» | Explicación del interlocutor sin política verificable; no permite crear un SEC o plazo de conservación. | RFP anexo D; S1 pasaje de canales junto a T-08; [PA-17][preguntas-rfp]. |
| Admin, Gerente, capas, controles y datos visuales | Son propuestas/ilustraciones o etiquetas, no requisitos confirmados que puedan clasificarse por simple presencia en S3/S4/S5. Se excluyen, no se convierten en roles o SEC nuevos. | RFP §7/anexo E; [PA-24][preguntas-rfp], [PA-25][preguntas-rfp]. |

La subjetividad de RNF-002–RNF-005 no impide reconocer su tipo NFR, pero sí concretar aceptación:
permanecen Clarification needed y TBD, enlazadas a PA-21. Las notas del RFP se mantienen abiertas;
esta baseline no responde preguntas ni modifica prioridades, actores, umbrales o decisiones.

[preguntas-rfp]: RFP-Vacation-Management.md#37-preguntas-abiertas