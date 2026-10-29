# Informe de análisis RFP: Gestión y aprobación de vacaciones

> Documento derivado de las fuentes de Discovery. Sigue la estructura de la
> [plantilla de análisis RFP aprobada](../.boltf/docs/templates/rfp-analysis-template.md).

| Propiedad | Valor |
| --- | --- |
| Identificador documental | RFP-Vacation-Management, identificador de este informe |
| Proyecto | Gestión y aprobación de vacaciones |
| Elaboración | GitHub Copilot; pendiente de revisión por las personas responsables del proyecto |
| Fecha del análisis | 2026-10-29 |
| Estado | Borrador para revisión; no constituye aceptación de requisitos, presupuesto o arquitectura |
| Evidencia de negocio | Exclusivamente las cinco fuentes de `origin/` inventariadas en la sección 2 |

## 1. Resumen ejecutivo

### Visión general

Se solicita una aplicación departamental para gestionar y aprobar turnos de vacaciones, conocer la
concentración de solicitudes por proyecto y departamento, facilitar su revisión y comunicar resultados.
Discovery menciona un departamento de 500 personas, aprobaciones en los ámbitos de proyecto y
departamento, delegación, alarmas por demora, cancelación por el usuario e intercambio con sistemas
corporativos. Fuentes: S1, citas T-01 a T-12 del anexo C; S2, RF-007–RF-023 y RF-030–RF-051.

«Necesidad confirmada» significa expresada de forma reconocible en Discovery, no aprobación formal de
cada detalle. S2 §1 califica sus requisitos como confirmados, pero sus propias notas de advertencia,
las contradicciones y S2 §6, «Una vez validados estos requisitos», impiden asumir aceptación completa.
Este informe no reutiliza el ejercicio hipotético archivado ni sus actores, reglas, estados o planes.

### Hallazgos principales

1. S2 contiene 52 RF, 10 RNF y 5 RT, conservados con sus identificadores originales. Son 67 entradas
   documentales, no necesariamente 67 capacidades independientes: hay duplicados y solapamientos.
2. No están resueltos la profundidad de la jerarquía, la fuente de pertenencia departamental, el flujo
   exacto de aprobación, la cancelación, la delegación ni los contratos de integración.
3. Las 500 personas de S1 no equivalen a los 500 usuarios simultáneos de S2 RNF-001. El 70 % aparece
   en S1 como ejemplo y en RF-009 como visualización de semanas de julio; no define un cupo global
   ni una regla de rechazo automático.
4. «5040 proyectos», «Google» y «envity» son expresiones dudosas de la transcripción. No se corrigen
   como hechos ni se convierten en dimensionamiento, integración o entregable.
5. S2 §5 y S3 son propuestas arquitectónicas. Vue.js está decidido por G1, ADR-0004; la versión y
   las demás elecciones técnicas no se fijan en este RFP. Los mockups no acreditan datos ni permisos.

### Recomendación

Continuar la aclaración con las preguntas de la sección 3, contrastar las fuentes y definir criterios
observables antes de cerrar alcance, estimación o diseño. No hay evidencia suficiente para emitir
una decisión Go/No-Go de inversión o una oferta vinculante.

## 2. Análisis de fuentes

### Inventario documental

| Clave | Archivo | Tipo y localizador | Relevancia y límites |
| --- | --- | --- | --- |
| S1 | [RecordedTranscription.txt](discovery/RecordedTranscription.txt) | Transcripción sin fecha de sesión identificada; citas T-01–T-19 en anexo C | Evidencia directa de necesidades; errores de transcripción, preguntas y ejemplos no son decisiones. Todas las intervenciones figuran como `[Cliente]`: no permite atribuir declaraciones inequívocamente a personas distintas. |
| S2 | [Documento Funcional de Requisitos.html](business-notes/Documento%20Funcional%20de%20Requisitos.html) | Fecha interna 07/07/2026, versión 1.0; §2 RF, §3 RNF, §4 RT, §5 propuesta arquitectónica, §6 próximos pasos | Extracción estructurada con advertencias explícitas. Se conserva cada ID y se señalan diferencias respecto a S1. |
| S3 | [Arquitectura.png](reference-images/Arquitectura.png) | Diagrama; bloques Frontend, Backend, Integraciones, Seguridad y Monitorización y Operación | Propuesta visual, no inventario de componentes implantados ni decisión técnica. |
| S4 | [mockup web.png](reference-images/mockup%20web.png) | Imagen; indicadores, solicitudes, calendario, navegación y perfil Admin | Referencia visual con datos ilustrativos; no demuestra roles, permisos, fórmulas o umbrales operativos. |
| S5 | [Mockup Web.html](reference-images/Mockup%20Web.html) | HTML y JavaScript; secciones `resumen`, `consulta`, `jerarquia`, `calendario`, `solicitudes`, `historial`, `notificaciones`, `enlace-app` | Prototipo con valores y comportamiento simulado. Fecha interna 07/07/2026. La lectura del archivo termina dentro del manejador `action-reject`, tras `const name = row.children[0].textContent;`: confirmar integridad de la entrega. |

Referencia de gobernanza solicitada, **no fuente adicional de necesidades de negocio**:
**G1**, [ADR-0004: sustituir Angular por Vue.js](../docs/adr/ADR-0004-replace-angular-with-vue-frontend.md),
aceptada el 2026-10-29. Solo se utiliza para registrar Vue.js como decisión ya tomada, sin fijar versión.
La plantilla es una referencia de estructura, no evidencia de requisitos o métricas.

No se consultan como evidencia `specs/`, `docs/design/` ni `docs/roadmap/`. Las fuentes originales no
se modifican. No se presupone que una imagen y un HTML de mockup representen exactamente la misma versión.
El número de páginas no resulta aplicable a estas fuentes digitales.

### Inventario del sistema existente

S1 menciona ServiceNow, Active Directory y una infraestructura cloud existente, indicando disponibilidad
de Azure. No aporta inventario de aplicaciones implantadas, versiones, antigüedad, código, volúmenes
de datos o contratos. S3 muestra una solución propuesta, no una arquitectura actual auditada.

## 3. Extracción y clasificación de requisitos

### 3.1. Necesidades de negocio expresadas en Discovery

| Necesidad respaldada | Evidencia y alcance confirmado | Detalle no confirmado |
| --- | --- | --- |
| Disponer de una aplicación de aprobación departamental de vacaciones | S1 T-01/T-05; S2 RF-008/RF-052, RT-005. Departamento declarado de 500 personas. | Catálogo definitivo de usuarios, datos y permisos; no implica 500 sesiones concurrentes. |
| Conocer concentración de solicitudes a nivel de proyecto y departamento | S1 T-02/T-03; S2 RF-001/RF-007/RF-041/RF-049. | Fórmula, población de referencia, estados incluidos y límites operativos. |
| Aprobar en los ámbitos de proyecto y departamento | S1 T-02; S2 RF-023/RF-030/RF-047/RF-050/RF-051. | Orden, paralelismo, número de aprobadores, excepciones y efecto de un rechazo. |
| Delegar aprobación dentro del proyecto y avisar al departamento si hay demora | S1 T-07; S2 RF-031/RF-032/RF-035. | Quién delega, duración, revocación, plazo de alarma y alcance del escalado. |
| Permitir cancelación por el usuario y rechazo por el responsable, sin propuestas alternativas | S1 T-11; S2 RF-006/RF-014/RF-015/RF-016/RF-019. | Estados en que puede cancelarse, efecto sobre aprobaciones y sistemas externos; significado de «cerrar». |
| Comunicar aprobaciones y cancelaciones y facilitar acceso por enlace | S1 T-08/T-09/T-11; S2 RF-017/RF-018/RF-024–RF-029. Correo primero, Teams opcional; tarjetas adaptativas después. | Matriz completa evento/destinatario/canal y condiciones de cada etapa. |
| Consultar calendarios, vacaciones pasadas y aprobadas o no aprobadas | S1 T-12; S2 RF-010–RF-013. | Quién consulta cada dato, periodo histórico, significado de no aprobadas y criterios medibles de facilidad. |
| Intercambiar datos corporativos y enviar a ServiceNow solo vacaciones aprobadas por los responsables | S1 T-06/T-10; S2 RF-020–RF-023/RF-036–RF-039, RT-001/RT-004. No se exige sincronización en tiempo real; descarga nocturna considerada suficiente. | Fuente de verdad de cada dato, dirección y cadencia de cada intercambio, formato y tratamiento de fallos. |
| Ajustar capacidad y coste a uso estacional | S1 T-13; S2 RNF-007–RNF-010. Picos citados antes de verano, Semana Santa y Navidad. | Carga simultánea, calendario de campañas, rendimiento y presupuesto objetivo. |

Actores expresos: usuario/empleado solicitante, responsable o jefe de proyecto, responsable departamental
y personas del mismo proyecto en las que se delega aprobación (S1 T-02/T-07/T-11; S2 RF-015/RF-030/RF-031/
RF-033/RF-045–RF-051). No se deduce una matriz completa de permisos. «Gerente» solo aparece en S3 y
«Admin» en S4: no se incorporan como roles de negocio confirmados ni se les conceden permisos.

### 3.2. Requisitos funcionales

Se conservan los **52 identificadores RF originales**, incluidos duplicados probables. Cada fila remite
al requisito con ese mismo ID en **[S2 §2: Requisitos Funcionales](business-notes/Documento%20Funcional%20de%20Requisitos.html#requisitos)**.
Las citas T-* remiten adicionalmente a S1, anexo C. La columna de observaciones recoge las notas de
advertencia y los gaps del contraste, sin responderlos. Prioridad y complejidad no están asignadas
en las fuentes: se indica **ND** para ambas, sin convertir «debe» en una prioridad MoSCoW.

| ID de S2 §2 | Requisito extraído | Prioridad / complejidad | Trazabilidad adicional y observaciones abiertas |
| --- | --- | --- | --- |
| RF-001 | Devolver cuántas personas hay en un periodo de tiempo. | ND / ND | Advertencia: población, información exacta y definición del periodo sin concretar. S1 T-03; relación con RF-041. |
| RF-002 | Acceder a una jerarquía organizativa con varios niveles de profundidad. | ND / ND | Advertencia: fuente y acceso sin definir. Conflicto con RF-043/RT-002 y la expresión dubitativa de S1 T-04. |
| RF-003 | Permitir seleccionar un nivel de la jerarquía según la necesidad. | ND / ND | Advertencia: quién selecciona, finalidad y criterio no definidos. Posible solapamiento con RF-040; S1 T-04. |
| RF-004 | Estructurar la población por departamentos. | ND / ND | Probable duplicado conceptual de RF-042. No resuelve profundidad ni alcance departamental; S1 T-04/T-05. |
| RF-005 | Poder configurar el periodo en semanas o días. | ND / ND | Advertencia: periodo y contexto de configuración sin definir. Probable duplicado de RF-044, cuya modalidad dice «puede»; S1 T-03. |
| RF-006 | Permitir rechazar solicitudes de vacaciones. | ND / ND | Advertencia: actor y condiciones sin definir en esta entrada. RF-016 identifica al responsable; RF-048 añade un «cerrar» dudoso; S1 T-11/T-16. |
| RF-007 | Gestionar cuántas personas pueden estar de vacaciones simultáneamente en un periodo. | ND / ND | Advertencia: quién configura el límite y periodo no definidos. No implica rechazo automático ni adopción del 70 % como cupo; S1 T-03. |
| RF-008 | Disponer de una aplicación de aprobación de turnos de vacaciones. | ND / ND | Repetición probable en RF-052; S1 T-01. No descompone datos o reglas de alta. |
| RF-009 | Visualizar semanas de julio con solicitudes del equipo superiores al 70 %. | ND / ND | Advertencia: presentación y «fácil de ver» no definidos. S1 T-12 lo ejemplifica; falta fórmula y confirmar alcance del umbral/mes. |
| RF-010 | Permitir a responsables ver las vacaciones solicitadas por cada usuario. | ND / ND | Concretar ámbito y permisos. RF-045 especializa responsable de proyecto; S1 T-12. |
| RF-011 | Consultar cuándo un empleado ha ido de vacaciones. | ND / ND | Advertencia: actor y alcance temporal sin definir; S1 T-12. No equivale por sí solo a vacaciones aprobadas futuras. |
| RF-012 | Consultar vacaciones aprobadas de un empleado. | ND / ND | Advertencia: actor y alcance temporal sin definir; S1 T-12. |
| RF-013 | Consultar vacaciones no aprobadas de un empleado. | ND / ND | Advertencia: actor y alcance temporal sin definir. Aclarar si comprende pendientes, rechazadas y canceladas; S1 T-12. |
| RF-014 | No proponer alternativas en el proceso. | ND / ND | Advertencia: tipo y contexto de alternativas no definidos. S1 T-11 habla de aceptar o rechazar, sin contrapropuesta; no es prohibición de evaluar opciones técnicas. |
| RF-015 | Permitir al usuario cancelar sus solicitudes. | ND / ND | S1 T-11. Estados, plazos, nueva solicitud y efecto posterior a aprobación no definidos. No sustituir cancelar por un ciclo de retirada del ejercicio archivado. |
| RF-016 | Permitir al responsable rechazar solicitudes. | ND / ND | S1 T-11. Solapamiento con RF-006/RF-048; no define estados, motivo o precedencia. |
| RF-017 | Notificar a usuarios cuando se aprueban sus solicitudes. | ND / ND | S1 T-11. Falta precisar aprobación parcial/final, contenido y canal por evento. |
| RF-018 | Notificar a usuarios cuando se cancelan sus solicitudes. | ND / ND | S1 T-11. No presupone notificación de rechazo ni equipara rechazo y cancelación. |
| RF-019 | Disponer de un proceso de cancelación. | ND / ND | Advertencia: entidad y funcionamiento sin definir. Relación RF-015/RF-018; S1 T-11. |
| RF-020 | Realizar descarga nocturna de actualizaciones. | ND / ND | Advertencia: hora, frecuencia detallada y alcance sin definir; S1 T-10. No asignar automáticamente la misma cadencia a todas las integraciones. |
| RF-021 | Enviar a ServiceNow un listado de vacaciones aprobadas. | ND / ND | Advertencia: momento, frecuencia y mecanismo de envío sin definir. S1 T-10; la proximidad de la mención nocturna no cierra el contrato de exportación. |
| RF-022 | Incluir únicamente vacaciones aprobadas en ese listado. | ND / ND | S1 T-10. Falta significado exacto de aprobación completa y tratamiento de cambios posteriores. |
| RF-023 | Obtener aprobación de cada responsable antes de enviar a ServiceNow. | ND / ND | Advertencia: quiénes y cuántos responsables sin definir. S1 T-02/T-10; no impone orden secuencial. |
| RF-024 | Permitir probar mediante un enlace en una primera etapa. | ND / ND | Advertencia: funcionalidad y condiciones de acceso sin definir; S1 T-09. No implica acceso anónimo ni piloto con tamaño conocido. |
| RF-025 | Incorporar tarjetas adaptativas en una etapa posterior. | ND / ND | Advertencia: alcance, propósito y momento sin concretar. S1 T-09 lo pospone; no requisito de primera entrega por defecto. |
| RF-026 | Disponer de un enlace navegable a la aplicación. | ND / ND | S1 T-09. No define URL, autenticación ni navegación específica. |
| RF-027 | Enviar información por correo electrónico. | ND / ND | Advertencia: información, evento y destinatarios sin definir. S1 T-08 prioriza correo; no completa todos los eventos. |
| RF-028 | Poder enviar información opcionalmente por Teams. | ND / ND | Advertencia: información, evento, destinatarios y opcionalidad sin definir. S1 T-08/T-09. |
| RF-029 | Enviar, como preferencia expresada con «debería», alarmas por correo o Teams. | ND / ND | Advertencia: no fija uno o ambos canales. S1 T-08 dice correo primero y Teams opcional; no convertir la preferencia en obligación multicanal. |
| RF-030 | Permitir al responsable departamental aprobar solicitudes. | ND / ND | S1 T-02/T-07. Aclarar relación con aprobación de proyecto y escalado por demora. |
| RF-031 | Delegar aprobación en otras personas del mismo proyecto. | ND / ND | Advertencia: condiciones, alcance y reglas sin definir; S1 T-07. No ampliar delegación a otro proyecto. |
| RF-032 | Generar una alarma al responsable departamental si no se aprueba en un tiempo determinado. | ND / ND | Advertencia: límite temporal y comportamiento/canal sin definir; S1 T-07/T-08. No definir SLA, aprobación automática o cancelación por expiración. |
| RF-033 | Contemplar un aprobador de proyecto. | ND / ND | Advertencia: acciones y flujo exacto sin definir. S1 T-07 y RF-045–RF-050 aportan contexto, no matriz completa. |
| RF-034 | Contemplar al menos un aprobador en departamentos grandes, de aproximadamente 50 personas. | ND / ND | Advertencia: «grande» y 50 como ejemplo o regla sin definir. S1 T-14 es una pregunta dubitativa, no umbral operativo confirmado. |
| RF-035 | Permitir delegación del aprobador de vacaciones. | ND / ND | Advertencia: condiciones, alcance y reglas sin definir. Posible solapamiento con RF-031, no una segunda capacidad confirmada. |
| RF-036 | Obtener de ServiceNow pertenencia de personas al departamento. | ND / ND | Advertencia: departamento y condiciones sin concretar. Respaldado por S1 T-06; conflicto de fuente de verdad con RF-037. |
| RF-037 | Obtener de Active Directory pertenencia de personas al departamento. | ND / ND | Advertencia: departamento y condiciones sin concretar. S1 T-06 atribuye esa pertenencia a ServiceNow y a AD la relación con responsables; resolver discrepancia. |
| RF-038 | Obtener quién es responsable de cada proyecto. | ND / ND | Advertencia: fuente y proyectos considerados sin definir en esta entrada. S1 T-06 cita AD; no define contrato/atributos. |
| RF-039 | Obtener quiénes están bajo responsabilidad de cada responsable de proyecto. | ND / ND | Advertencia: relación jerárquica y fuente imprecisas. S1 T-06; no asumir que equivale a una única pertenencia de proyecto. |
| RF-040 | Seleccionar un nivel de estructura organizativa según interés del usuario. | ND / ND | Advertencia: niveles y representación sin definir; S1 T-04. Posible solapamiento con RF-003. |
| RF-041 | Devolver cuántas personas corresponden al nivel seleccionado en un periodo concreto. | ND / ND | Advertencia: significado de «corresponden» y periodo sin definir. S1 T-03/T-04; especialización posible de RF-001. |
| RF-042 | Organizar la estructura de población por departamentos. | ND / ND | Probable duplicado conceptual RF-004; conservar ambos IDs hasta acordar consolidación. |
| RF-043 | Tener un solo nivel de estructura organizativa. | ND / ND | Advertencia: «se supone» hace incierta la confirmación. Conflicto con RF-002; S1 T-04 contiene pregunta, no respuesta definitiva. |
| RF-044 | Poder configurar el periodo en semanas o días. | ND / ND | Advertencia: periodo y condiciones para usar semanas/días sin concretar. Duplicado probable RF-005, con modalidad diferente; S1 T-03. |
| RF-045 | Permitir al responsable de proyecto ver solicitudes. | ND / ND | S1 T-03/T-12; relación RF-010. No autoriza consulta de cualquier empleado fuera de su ámbito. |
| RF-046 | Permitir al responsable de proyecto valorar solicitudes. | ND / ND | Advertencia: «valorar» no concreta acción/criterio. S1 T-16; no inventar puntuación, comentario o validación automática. |
| RF-047 | Permitir al responsable de proyecto aprobar solicitudes. | ND / ND | S1 T-02/T-03; relación RF-050. No determina orden con departamento. |
| RF-048 | Permitir al responsable de proyecto rechazar o cerrar solicitudes. | ND / ND | Advertencia: deriva de «echa cerrar colecciones», interpretación no confirmada. S1 T-16; rechazo está respaldado por T-11, «cerrar» no tiene semántica definida. |
| RF-049 | Permitir al responsable departamental conocer cuánta gente está de vacaciones en todo el departamento. | ND / ND | Advertencia: no define tiempo real, periodo o reporte. S1 T-03. Distinguir vacaciones solicitadas de disfrutadas/aprobadas. |
| RF-050 | Aprobar solicitudes a nivel de proyecto. | ND / ND | S1 T-02; solapamiento de nivel/acción con RF-033/RF-047. |
| RF-051 | Aprobar solicitudes a nivel departamental. | ND / ND | S1 T-02; relación RF-030 y RF-023, sin precedencia definida. |
| RF-052 | Ser una aplicación de aprobación de turnos de vacaciones. | ND / ND | Repetición probable RF-008; S1 T-01. No contar como funcionalidad distinta sin aclaración. |

### 3.3. Requisitos no funcionales

Cada ID remite a **[S2 §3: Requisitos No Funcionales](business-notes/Documento%20Funcional%20de%20Requisitos.html#no-funcionales)**.
Se mantiene la diferencia entre un objetivo enunciado y un criterio de aceptación validado.

| ID de S2 §3 | Categoría | Requisito y objetivo expresado | Advertencias, contraste y criterio pendiente |
| --- | --- | --- | --- |
| RNF-001 | Capacidad | Soportar 500 usuarios a la vez. | Valor explícito en S2, no deducible de las 500 personas de S1 T-01. Confirmar concurrencia, operaciones, duración y criterio de rendimiento antes de diseñar una prueba. |
| RNF-002 | Usabilidad / visualización | Mostrar «de manera muy visual» periodos sobresolicitados. | Advertencia: términos sin criterios. S1 T-12; RF-009 cita 70 % en julio, sin definir fórmula ni estilo. Acordar tarea y medida de reconocimiento, no colores o umbrales nuevos. |
| RNF-003 | Usabilidad | Responsables ven «de manera sencilla» vacaciones solicitadas por usuario. | Advertencia: sin criterio medible. S1 T-12; acordar tarea, muestra de usuarios y medida de éxito/esfuerzo, sin asignar valores aquí. |
| RNF-004 | Usabilidad | Ver calendarios «fácilmente». | Advertencia: sin criterio medible. S1 T-12; definir tareas de consulta y condiciones de evaluación. |
| RNF-005 | Legibilidad / diseño | Ser «fácil de ver». | Advertencia: diseño, accesibilidad y legibilidad sin definir. No inventar nivel WCAG, tamaño de fuente, contraste o dispositivo obligatorio. |
| RNF-006 | Integración / actualización | No requerir sincronización en tiempo real. | S1 T-10 acepta descarga nocturna. No equivale a prohibir interacción inmediata en la aplicación ni a aceptar cualquier retraso de integración. |
| RNF-007 | Escalabilidad | Ajustarse a demanda estacional, con pocos usuarios y picos como Navidad. | Advertencia: sin carga, latencia o calendario cuantificados. S1 T-13 añade antes de verano y Semana Santa; no fija infraestructura de escalado. |
| RNF-008 | Coste | Optimizar costes para evitar pagos innecesarios. | Advertencia: sin presupuesto, ahorro objetivo o medida. S1 T-13 expresa intención; la frase corrupta sobre coste no aporta un valor. |
| RNF-009 | Volumen de uso | Contemplar aproximadamente 500 personas del departamento. | Advertencia: no precisa totales/concurrentes/activos. S1 T-01 respalda tamaño poblacional, no todos esos modelos; contrastar RNF-001. |
| RNF-010 | Patrón de uso | Uso estacional. | Advertencia: sin calendario detallado ni impacto cuantificado. Relación RNF-007; S1 T-13 es cualitativa. |

No se extraen objetivos de disponibilidad, recuperación, retención, latencia, seguridad o accesibilidad
que las fuentes no cuantifican. Autenticación, roles, logs y alertas aparecen como propuesta técnica
en S2 §5/S3, no como políticas o estándares aprobados. Tampoco se importan umbrales de cobertura,
mutación o cumplimiento de otros artefactos para convertirlos en RNF del cliente.

### 3.4. Restricciones

Los IDs RT conservan su localización en
**[S2 §4: Restricciones Técnicas](business-notes/Documento%20Funcional%20de%20Requisitos.html#restricciones)**.
Una restricción declarada en S2 puede requerir aclaración; no implica aprobación de toda su propuesta.

| ID / tipo | Restricción expresada | Impacto y trazabilidad / límite |
| --- | --- | --- |
| RT-001 / datos externos | Acceder a información organizativa de Active Directory. | S1 T-06 respalda uso organizativo; atributos y acceso pendientes. Consultar AD no selecciona proveedor o flujo de autenticación ni permite sustituirlo automáticamente por Microsoft Entra ID. |
| RT-002 / estructura | Un único nivel de estructura para la población. | Contradice RF-002; S1 T-04 dice «se supone» y pregunta por varios niveles. No aplicarla como decisión cerrada. |
| RT-003 / infraestructura | Despliegue en infraestructura cloud existente, como Azure o Amazon. | S1 T-13 menciona ambas y disponibilidad de Azure; S2 §5 propone Azure. Este RFP no selecciona proveedor, servicio de ejecución o topología. |
| RT-004 / integración | Integrar la nueva aplicación con sistemas o infraestructura existente. | S1 T-06/T-10; contratos y límites en sección 3.5. No obliga a un protocolo concreto. |
| RT-005 / alcance | Uso exclusivo de un departamento. | S1 T-05: se financia para ese departamento; otros departamentos se dejan para después. El selector multidepartamento de S5 no amplía el alcance. |
| RF-014 / proceso | No proponer alternativas en el proceso de aceptación/rechazo. | S1 T-11; significado operativo pendiente, no restricción sobre tecnologías a evaluar. |
| G1 / frontend decidido | Vue.js, versión no fijada. | ADR-0004 aceptada. No decide API, backend, persistencia, hosting, autenticación, enrutado, estado o biblioteca de componentes. |

### 3.5. Integraciones

| Intercambio / estado de evidencia | Información y dirección | Fuente | Por concretar antes de construir |
| --- | --- | --- | --- |
| ServiceNow, entrada organizativa citada | ServiceNow → aplicación: personas que pertenecen al departamento. | S1 T-06; S2 RF-036. | Fuente de verdad frente a RF-037, identificadores, atributos, ámbito y condiciones de carga. |
| Active Directory, entrada organizativa citada | AD → aplicación: responsable de proyecto y personas bajo su responsabilidad; S2 RF-037 añade pertenencia departamental. | S1 T-06; S2 RF-037–RF-039, RT-001. | Resolver el solapamiento con ServiceNow; no asumir que subordinación equivale a asignación única a proyecto. Protocolo y credenciales sin elegir. |
| ServiceNow, salida requerida | Aplicación → ServiceNow: listado de vacaciones aprobadas, solo tras aprobación por cada responsable requerido. | S1 T-10; S2 RF-021–RF-023. | Aprobación completa, formato, momento/cadencia, confirmación, duplicados, fallos y cambios/cancelaciones posteriores. |
| Actualizaciones nocturnas, requisito de cadencia general | Descarga nocturna sin sincronización en tiempo real; dirección y alcance por intercambio pendientes. | S1 T-10; S2 RF-020/RNF-006; S2 §5 propone extenderla a AD y ServiceNow. | No convertirlo en exportación diaria a hora fija, sincronización bidireccional o una tolerancia de retraso numérica no acordada. |
| Correo, canal priorizado | Información/avisos a destinatarios que se concreten; aprobación/cancelación al usuario y alarma al responsable departamental están citadas. | S1 T-07/T-08/T-11; S2 RF-017/RF-018/RF-027/RF-029/RF-032. | Matriz evento/destinatario/canal, contenidos, entrega y evidencia requerida. No fijar SMTP, API o política de conservación. |
| Teams, canal opcional | Avisos y enlace a aplicación; tarjetas adaptativas pospuestas. | S1 T-08/T-09; S2 RF-025/RF-028/RF-029. | Qué eventos, activación de la opción, destinatarios y fase; ni bot, webhook ni Microsoft Graph seleccionados. |
| Otras integraciones, solo mención dudosa | «sistemas tipo myscaturing o algo así» para precarga o validación. | S1 T-17. | Identificar sistema y necesidad; no se registra conector, contrato o validación automática obligatoria. «Google» tampoco se incorpora como integración. |

La transcripción contrapone descarga/extracción y sincronización en tiempo real. No prueba que
todos los flujos compartan el mismo horario ni que ServiceNow inicie otro proceso. S3 dibuja
conexiones, pero las flechas no establecen contratos de lectura/escritura, autorización o garantías.

### 3.6. Supuestos de análisis, no requisitos

| Supuesto explícito | Motivo / evidencia | Validación necesaria |
| --- | --- | --- |
| «Service Now», «service Now» y «ServiceNow» se referencian como ServiceNow para facilitar lectura. | Variantes literales en S1/S2. | Confirmar denominación e instancia; no supone equivalencia con otro sistema. |
| «Usuario» y «empleado» se agrupan como solicitante cuando se habla de pedir o cancelar vacaciones. | S1 T-11/T-12; S2 RF-015. | No define identidad, colectivos elegibles o permisos de consulta. |
| S2 es una elaboración de Discovery, contrastable con S1, no evidencia independiente de aprobación de cada detalle. | S2 §1 y §6, notas de advertencia y diferencias detectadas. | Revisar con quienes acepten el alcance; no hay firma o acta de aprobación en las fuentes. |
| S4/S5 son ilustrativos, no datos reales, configuración validada o especificación ejecutable del producto. | Valores de ejemplo, simulación JS y diferencias entre ambos. | Revisar cada regla/dato que se quiera adoptar antes de promoverlo a requisito. |

No se presupone jerarquía definitiva, un proyecto por persona, orden de aprobaciones, acceso global
de responsables, rol administrador, cálculo automático de cupos o catálogo de estados. Tampoco se
establecen políticas de saldo, calendario laboral, motivo o reversibilidad por ausencia de detalle.

### 3.7. Preguntas abiertas

Los IDs PA-* son localizadores **de este informe**, no requisitos nuevos ni preguntas ya respondidas.
Las personas responsables de responderlos están por identificar; no se asignan cargos nuevos.

| ID | Pregunta a resolver | Fuente / efecto |
| --- | --- | --- |
| PA-01 | ¿Hay un solo nivel o varios? ¿Se distingue estructura departamental de niveles de consulta y aprobación? | S1 T-04; S2 RF-002/RF-003/RF-040/RF-043, RT-002; S5 `jerarquia` presenta ambas vistas. Conflicto abierto, no resuelto mediante una interpretación conveniente. |
| PA-02 | ¿Qué sistema determina pertenencia departamental y qué aporta AD? ¿Hay datos solapados y cómo se resuelven diferencias? | S1 T-06 vs S2 RF-036/RF-037 y §5.2; fuente de verdad de integración pendiente. |
| PA-03 | ¿Se consolidan RF-005/RF-044 y RF-004/RF-042? ¿La diferencia «debe»/«puede» del periodo tiene efecto? | Duplicados probables de S2; mantener ambos IDs hasta acuerdo, sin contar doble alcance. |
| PA-04 | ¿Se consolidan RF-008/RF-052, RF-003/RF-040, RF-001/RF-041, RF-006/RF-016 y RF-031/RF-035, o hay diferencias de ámbito? | Solapamientos S2; no fusionarlos automáticamente ni borrar trazabilidad. |
| PA-05 | ¿Quiénes y cuántos aprueban, en qué orden o en paralelo? ¿La alarma permite sustituir aprobación de proyecto o añade otra? | S1 T-02/T-07/T-10; S2 RF-023/RF-030/RF-033/RF-047/RF-050/RF-051. Dos ámbitos no implican dos personas ni secuencia fija. |
| PA-06 | ¿Qué significa «valorar» y qué acción pretendía «echa cerrar colecciones»? ¿Existe cierre distinto de rechazo? | S1 T-16; S2 RF-046/RF-048. No añadir una transición por interpretación de transcripción. |
| PA-07 | ¿Cuántos proyectos hay realmente y cómo varía la relación persona/proyecto/responsable? | S1 «5040 proyectos» T-15; S2 RF-038/RF-039. No usar 5040 para cardinalidad o capacidad. |
| PA-08 | ¿Qué se cuenta en un periodo: personas solicitantes únicas, aprobadas, ausentes o disponibles? ¿Cómo se computan intervalos y denominador? | S1 T-03/T-12; S2 RF-001/RF-007/RF-009/RF-041/RF-049. Fórmula no establecida por los porcentajes del mockup. |
| PA-09 | ¿Semanas/días son configurables por quién, para qué consultas y con qué límites? ¿Julio y 70 % son regla fija, ejemplo o configuración? | S1 T-03/T-12; S2 RF-005/RF-009/RF-044. No extender el umbral a todos los meses o al rechazo automático. |
| PA-10 | ¿Cómo se define el cupo simultáneo, quién lo establece y qué efecto tiene superarlo? | S2 RF-007; S4/S5. Distinguir visualización de control/validación del flujo. |
| PA-11 | ¿50 personas es un ejemplo o umbral? ¿Cuántos aprobadores se necesitan y con qué ámbito? | S1 T-14; S2 RF-034. No fijar una regla poblacional a partir de una pregunta. |
| PA-12 | ¿Quién delega, en quién, durante cuánto tiempo y con qué revocación/alcance? | S1 T-07; S2 RF-031/RF-035. Mantener como dato citado «mismo proyecto», sin inventar el resto. |
| PA-13 | ¿Qué demora genera alarma, desde qué momento se cuenta, qué calendario usa y qué sucede después? | S1 T-07/T-08; S2 RF-032. Sin duración, repetición o escalado automático definidos. |
| PA-14 | ¿En qué estados puede cancelar el usuario y cómo afecta a aprobaciones y a ServiceNow? ¿Qué distingue cancelar, rechazar y cerrar? | S1 T-11; S2 RF-006/RF-015/RF-016/RF-019/RF-048. No importar estados/transiciones del ejercicio archivado. |
| PA-15 | ¿Se requiere una nueva solicitud tras cancelar? ¿Qué edición queda para después? | S1 T-11/T-18 contiene un pasaje corrupto y pospone edición. No inventar un flujo de modificación. |
| PA-16 | ¿Qué datos mínimos y reglas de alta se necesitan? ¿Quién puede consultar cada histórico y qué significa «no aprobadas»? | S1 T-12; S2 RF-011–RF-013 y §5.2. S5 no define por sí solo formularios, permisos o estados. |
| PA-17 | ¿Qué eventos notifican a quién, por correo, por Teams o por ambos? ¿Rechazo requiere aviso? ¿Qué significa auditar el aviso? | S1 T-08/T-11; S2 RF-017/RF-018/RF-027–RF-029. Rechazo no equivale automáticamente a cancelación; retención de Teams/correo no validada. |
| PA-18 | ¿Qué intercambios son nocturnos, cuándo y con qué tolerancia? ¿Cómo se confirma el envío a ServiceNow y se gestionan errores, repeticiones y cancelaciones posteriores? | S1 T-10; S2 RF-020–RF-023/RNF-006. No seleccionar sincronización bidireccional ni procesamiento de fallos por defecto. |
| PA-19 | ¿RNF-001 exige realmente 500 concurrentes o deriva de una población de 500? ¿Qué carga y rendimiento se aceptan? | S1 T-01 frente a S2 RNF-001/RNF-009 y §5.3. No dimensionar con equivalencia no probada. |
| PA-20 | ¿Qué campañas, demanda baja/alta y coste medido definen escalabilidad y ahorro satisfactorios? | S1 T-13; S2 RNF-007/RNF-008/RNF-010. Sin presupuesto, ahorro o configuración de escalado fijados. |
| PA-21 | ¿Qué tareas y medidas verifican «muy visual», «fácil de ver», «fácilmente» y «de manera sencilla»? | S1 T-12; S2 RNF-002–RNF-005. Acordar éxito, tiempo/esfuerzo y condiciones de prueba sin asignar umbrales arbitrarios. |
| PA-22 | ¿Quién accede al enlace inicial, qué se prueba y cuándo entran Teams/tarjetas adaptativas? | S1 T-09; S2 RF-024–RF-026/RF-028. No fijar un MVP por la palabra dudosa «envity». |
| PA-23 | ¿Qué quería decir «Google», «envity», «refworkings» y «myscaturing»? ¿Se confirma alguna necesidad adicional? | S1 T-04/T-09/T-17/T-19. No crear servicios o entregables desde nombres dudosos. |
| PA-24 | ¿Qué elecciones de la propuesta se aprueban, aparte de Vue.js decidido por G1? ¿Qué acceso, datos y controles necesitan los sistemas corporativos? | S2 §5/S3; G1. AD organizativo no decide autenticación; quedan abiertos API, datos, arquitectura y ejecución. |
| PA-25 | ¿Qué datos y comportamientos del mockup se quieren adoptar? ¿Se dispone del HTML completo? | S4/S5. Roles, cancelación por responsables, motivo visible, horas y fórmulas de simulación no están confirmados por su presencia visual. |
| PA-26 | ¿Quién valida requisitos, prioridades, criterios y duplicados, y con qué evidencia? | S2 §1/§6. No existe autoridad de aceptación identificada ni priorización detallada en las fuentes. |
| PA-27 | ¿Qué versión de Vue.js se utilizará? | G1 no fija versión; no seleccionar versiones o librerías desde el mockup. |

## 4. Evaluación técnica

### Arquitectura actual y stack

No se dispone de código ni descripción verificable de una aplicación anterior de vacaciones. Se
conocen sistemas corporativos mencionados, no su tecnología exacta, configuración o interfaces.
La arquitectura de S2 §5/S3 se evalúa como propuesta en la sección 7, no como estado actual.

| Componente | Evidencia actual | Estado de decisión / esfuerzo de migración |
| --- | --- | --- |
| Frontend | S2 §5/S3 proponen Vue; G1 lo acepta. | Vue.js decidido; versión abierta. Esfuerzo no estimable con estas fuentes. |
| Backend / API | S3 muestra API de negocio y lógica de vacaciones; S2 §5.2 describe responsabilidades. | Estilo, protocolo, lenguaje y framework no se seleccionan en este análisis. |
| Datos / persistencia | S3 muestra base de datos; S2 §5.2 propone persistencia transaccional. | Motor, esquema, acceso y alcance de trazabilidad abiertos. |
| Organización e identidad | S1/S2 citan AD y ServiceNow como datos organizativos. | No determina IdP, flujo de login o modelo de autorización. |
| Hosting | S1 T-13 cita infraestructura existente y Azure disponible; S2 RT-003 menciona Azure o Amazon, §5 propone Azure. | Sin selección adicional de nube, servicio o topología en este RFP. |
| Procesos programados / avisos | RF-020–RF-029, RNF-006 y propuesta S2 §5/S3. | Cadencia por integración, herramientas y garantías pendientes. |

### Calidad del código

No evaluada: las fuentes no incluyen código de producto, cobertura, deuda técnica, complejidad ni
historial de fallos. El JavaScript de S5 simula consultas/acciones, no acredita una implementación
productiva o sus garantías. Los valores orientativos de la plantilla no se convierten en mediciones.

### Migración y datos

No hay inventario de solicitudes existentes, volumen histórico, formato o necesidad de migración
confirmada. Obtener estructura organizativa o hacer una precarga no equivale automáticamente a una
migración. Quedan por concretar datasets, fuente, responsables, volumen, correspondencias y calidad
(S1 T-06/T-17; S2 RF-036–RF-039 y §5.4). No se elige ETL, CDC, carga manual o estrategia de transición.

## 5. Análisis de riesgos

Probabilidad y valoración cuantitativa no evaluadas. Los impactos siguientes son consecuencias del
contenido incompleto, no severidades o puntuaciones asignadas al proyecto.

### Riesgos técnicos

| Riesgo y fuente | Probabilidad | Impacto posible | Tratamiento propuesto para aclaración, no decisión técnica |
| --- | --- | --- | --- |
| Jerarquía y fuente de verdad incompatibles, PA-01/PA-02 | No evaluada | Datos y reglas de acceso incorrectos. | Acordar estructura y responsabilidad de datos antes de diseñar integración. |
| Intercambios sin contrato, RF-020–RF-023 y RF-036–RF-039 | No evaluada | Información desactualizada, duplicada o aprobaciones mal exportadas. | Concretar atributos, direcciones, cadencias y comportamiento de error; sin elegir mecanismo de recuperación. |
| Capacidad derivada erróneamente de población, RNF-001/RNF-009 | No evaluada | Dimensionamiento y costes sin base verificable. | Resolver PA-19 y caracterizar carga antes de estimar. |
| Propuesta visual tratada como producto, S3/S4/S5 | No evaluada | Permisos, fórmulas y garantías asumidos sin respaldo; HTML posiblemente incompleto. | Validar qué se adopta y confirmar integridad del prototipo. |

### Riesgos de negocio

| Riesgo y fuente | Probabilidad | Impacto posible | Tratamiento propuesto |
| --- | --- | --- | --- |
| Aprobación, delegación y cancelación incompletas, RF-015/RF-019/RF-023/RF-031–RF-035 | No evaluada | Resultados diferentes según la interpretación del flujo. | Aclarar actores por acción, reglas y ejemplos con resultados esperados. |
| Subjetividad y duplicados, RNF-002–RNF-005 y PA-03/PA-04 | No evaluada | Aceptación no reproducible y doble cómputo de alcance. | Acordar criterios y consolidación preservando IDs de origen. |
| Error de transcripción promovido a hecho, S1 T-15–T-19 | No evaluada | Alcance o capacidad basados en contenido corrupto. | Validar las expresiones con la fuente humana; no reconstruir supuestas palabras. |
| Expansión no aprobada, RT-005 frente a S5 `consulta`/`jerarquia` | No evaluada | Incluir otros departamentos o equipos por el diseño del mockup. | Mantener alcance departamental hasta decisión explícita. |

### Dependencias

| Dependencia | Tipo | Riesgo / titular |
| --- | --- | --- |
| Acceso y definición de datos de ServiceNow/AD | Sistemas existentes, S1 T-06 y RT-001/RT-004 | Valoración no realizada; titulares y condiciones por identificar. |
| Confirmación de flujo, datos y criterios de aceptación | Negocio, PA-05–PA-22/PA-26 | Personas con autoridad por identificar; no se asigna un rol nuevo. |
| Infraestructura existente y canales de correo/Teams | Técnica, S1 T-08/T-13 y RT-003 | Disponibilidad concreta, permisos y coste por confirmar. |

## 6. Estimación de esfuerzo

### Estimación de alto nivel

| Fase de la plantilla | Esfuerzo | Duración | Tamaño de equipo |
| --- | --- | --- | --- |
| Discovery / aclaración | No estimado | No definida | No definido |
| Diseño | No estimado | No definida | No definido |
| Desarrollo | No estimado | No definida | No definido |
| Pruebas | No estimado | No definida | No definido |
| Despliegue | No estimado | No definida | No definido |
| Total | No estimable con la evidencia actual | No definida | No definido |

No hay calendario, capacidad de equipo o productividad documentados. Antes de estimar se necesitan
alcance consolidado, flujo de aprobación, contratos de integración, modelo de carga y criterios
de aceptación (S2 §6 y preguntas de la sección 3). No se reutilizan estimaciones del ejercicio archivado.

### Coste

| Categoría de la plantilla | Estimación | Evidencia pendiente |
| --- | --- | --- |
| Desarrollo | No estimado | Alcance, esfuerzo y tarifas no aportados. |
| Infraestructura | No estimado | Plataforma y perfil de carga sin concretar; S1 T-13/RNF-008 expresan intención de ahorro. |
| Licencias | No estimado | Contratos y costes de acceso a sistemas/canales no aportados. |
| Formación | No estimado | Necesidad, usuarios y alcance no definidos. |
| Total | No estimable | No hay presupuesto o moneda acordados en las fuentes. |

## 7. Solución propuesta en las fuentes

### Visión arquitectónica, no decisión del análisis

**S2 §5.1–§5.3** recomienda una web en capas, monolito modular, frontend Vue, API de negocio e
integración con sistemas corporativos, desplegada en Azure. Propone persistencia transaccional,
procesos programados y separación de presentación, aplicación, dominio, integración y seguridad.
Su justificación de suficiencia para 500 concurrentes es una afirmación de la propuesta, no un
resultado de carga o viabilidad demostrado.

**S3** representa aplicación web Vue.js, API de negocio, lógica de vacaciones, persistencia/base de
datos, conectores AD/ServiceNow y notificaciones Email/Teams. Añade bloques de autenticación/roles,
logs/alertas y procesos batch nocturnos; muestra enlace web, correo y Teams como canales, y las
figuras Empleado, Jefe de Proyecto y Gerente. Esta representación no fija permisos, protocolos,
proveedor de identidad, bidireccionalidad de intercambios o productos concretos.

No se reproduce como arquitectura objetivo aprobada ni se rediseña en este informe. Reintentos,
flujo configurable, trazabilidad y parametrización sugeridos en S2 §5.4 son mitigaciones propuestas,
no requisitos o decisiones nuevas. No se deducen REST, GraphQL, SQL, ORM, microservicios, colas,
schedulers, contenedores o servicios Azure específicos.

### Selecciones y recomendaciones tecnológicas

| Componente | Estado | Acción de análisis propuesta |
| --- | --- | --- |
| Frontend | Vue.js decidido por G1; S2/S3 son su antecedente, no la aprobación por sí solos. | Confirmar versión antes de instalar o generar código, PA-27. |
| Arquitectura en capas / monolito modular | Propuesta S2 §5.1–§5.3. | Evaluar tras aclarar flujo, datos, carga y contratos; no ratificarla por este RFP. |
| Cloud / despliegue | S2 propone Azure; RT-003/S1 citan infraestructura existente. | Aclarar selección y restricciones de ejecución; sin nueva decisión. |
| API, backend, datos e identidad | No seleccionados por este informe. | Definir necesidades y evaluar alternativas solo cuando se autorice. |
| Integración, batch, correo y Teams | Necesidades y propuestas mezcladas en S1/S2/S3. | Separar contrato funcional de mecanismo técnico y cadencia por intercambio. |

### Estrategia de migración

No seleccionada. No hay evidencia para escoger Big Bang, incremental, Strangler Fig o ejecución
paralela. Su presencia en la plantilla no demuestra sistema previo o migración requerida.

### Etapas expresadas, no planificación de entrega

| Etapa citada | Alcance respaldado | Duración / dependencias |
| --- | --- | --- |
| Inicial | Probar/acceder mediante enlace; correo primero, Teams opcional. S1 T-08/T-09, S2 RF-024/RF-026–RF-028. | No definida; aclarar funcionalidad del piloto, acceso y aceptación. |
| Posterior | Tarjetas adaptativas. Edición se deja para después sin especificación. S1 T-09/T-18, S2 RF-025. | No definida; no compromiso de fecha o alcance adicional. |

No se generan features, tareas, contratos ni implementación a partir de estas etapas.

## 8. Recomendación Go/No-Go

### Cuadro de evaluación

| Criterio de la plantilla | Puntuación | Peso | Resultado ponderado |
| --- | --- | --- | --- |
| Viabilidad técnica | No evaluada | No acordado | No calculable |
| Valor de negocio | No evaluado económicamente | No acordado | No calculable |
| Nivel de riesgo | Sin valoración cuantitativa | No acordado | No calculable |
| Disponibilidad de recursos | No aportada | No acordado | No calculable |
| Alineación estratégica | Sin objetivos o indicadores aportados | No acordado | No calculable |
| Total | Sin decisión | Sin ponderación aprobada | No calculable |

No se aplican los pesos o puntuaciones de ejemplo de la plantilla como decisiones del proyecto.
La recomendación de este análisis es **seguir aclarando y validando**, no un GO o NO-GO de inversión.

### Próximos pasos propuestos

1. Resolver estructura, fuentes organizativas y expresiones dudosas con quienes puedan validarlas.
2. Consolidar duplicados conservando sus IDs y definir flujo de aprobaciones, delegación y cancelación.
3. Acordar fórmulas, criterios de usabilidad, concurrencia real y contratos de integración/canales.
4. Revisar qué adopta el proyecto del diagrama y de los mockups; mantener Vue.js como decisión ya tomada.
5. Solo después, priorizar y estimar con las personas responsables y criterios de aceptación explícitos.

Estos pasos son recomendaciones de análisis, no responsables asignados, plazos comprometidos o work items creados.

## 9. Anexos

### A. Glosario y términos por aclarar

| Término | Uso en las fuentes / límite |
| --- | --- |
| Solicitante / usuario / empleado | Persona que pide vacaciones y puede cancelar sus solicitudes; no define todo su ámbito de consulta. S1 T-11/T-12. |
| Responsable de proyecto | Ve, valora y aprueba/rechaza según S1/S2; ámbito y relaciones de aprobación pendientes. |
| Responsable departamental | Consulta conjunto del departamento, aprueba y recibe alarma por demora; precedencia pendiente. |
| Sobresolicitación | Concentración de solicitudes en un periodo; fórmula/cupo y tratamiento no definidos, aunque se ejemplifica 70 %. |
| No aprobadas | Expresión de consulta que no fija si incluye pendientes, rechazadas o canceladas. |
| Cancelar / rechazar / cerrar | Cancelar por usuario y rechazar por responsable están citados; cerrar deriva de transcripción dudosa. No equivalencia de estados. |
| Active Directory | Fuente organizativa citada; no selección automática de Microsoft Entra ID ni de login. |
| Gerente / Admin | Etiquetas del diagrama y mockup, respectivamente; no roles con permisos confirmados. |

### B. Referencias y mapa de cobertura

Las rutas S1–S5 y G1 están enlazadas en el inventario de la sección 2. Las tablas de la sección 3
conservan todos los IDs de S2: **RF-001–RF-052, RNF-001–RNF-010 y RT-001–RT-005**, sin suprimir
duplicados ni trasladar números del ejercicio archivado. Los apartados 4–8 remiten a esas evidencias
y a la propuesta S2 §5, no a hechos de implementación.

| Cobertura | Localizador en este informe |
| --- | --- |
| Necesidades expresadas en Discovery | §3.1 y citas T-* del anexo C. |
| 52 RF y sus advertencias | §3.2; origen S2 §2 e ID de cada fila. |
| 10 RNF y sus objetivos abiertos | §3.3; origen S2 §3 e ID de cada fila. |
| 5 RT y frontend decidido | §3.4; S2 §4 y G1, con estados diferenciados. |
| Integraciones y fuente de verdad | §3.5 y PA-02/PA-18/PA-23. |
| Duplicados y conflictos | PA-01–PA-06 y PA-19. No se consolidan automáticamente. |
| Propuesta arquitectónica | §7; S2 §5 y S3, no arquitectura aprobada. |
| Errores probables y ejemplos visuales | Anexos D/E; S1, S4 y S5. |

### C. Notas de entrevista y citas de trazabilidad

Origen de todas las citas: **[S1: RecordedTranscription.txt](discovery/RecordedTranscription.txt)**.
Se conservan literalmente los fragmentos citados, incluidos errores; no se atribuyen cargos nuevos a
los nombres mencionados. Fecha de entrevista no identificada. Las citas identifican el pasaje sin
depender de numeración aproximada de líneas.

| Cita | Fragmento literal de S1 | Utilización / cautela |
| --- | --- | --- |
| T-01 | «quiero que construyamos una aplicación de aprobación de turnos de vacaciones. Tenemos un departamento que son 500 personas.» | Objetivo y población, no 500 concurrentes. |
| T-02 | «tenemos que aprobar las vacaciones tanto a nivel de proyecto como a nivel departamental» | Dos ámbitos de aprobación, no orden ni número exacto de aprobadores. |
| T-03 | «El porcentaje de personas que están pidiéndose vacaciones a la vez en un mismo periodo de tiempo.» / «lo podemos dejar en en semanas o días o como veáis vosotros.» | Necesidad de concentración y opciones temporales, no fórmula o configuración cerrada. |
| T-04 | «deberíamos tenerla ya estructurada por departamentos y se supone que solo hay un nivel.» / «necesitamos acceso a Google, organización que nos diga» | Supuesto/pregunta sobre profundidad y término dudoso, no confirmación de Google o nivel único. |
| T-05 | «la aplicación es solo para un departamento, es es departamental, la pagamos nosotros.» | Alcance actual. La extensión a otros departamentos se pospone, no se autoriza por un selector. |
| T-06 | «Service Now nos dice quién está dentro del departamento y directorio Activo, nos dice el proyecto al que o sea mejor dicho quién es el responsable de proyecto y quiénes están bajo ese el orden de ser responsables.» | Distinción de fuentes, con relación jerárquica imprecisa; contraste con RF-037. |
| T-07 | «La aprobación en otras personas de su mismo proyecto, vale, pero si no aprueba en un determinado tiempo tiene que salir una alarma el responsable del departamento.» / «Para que el responsable del departamento apruebe.» | Delegación y alarma; sin duración, orden o sustitución definidos. |
| T-08 | «Pues pongamos primero por correo electrónico y opcionalmente por teams.» | Preferencia de canal; no garantiza retención ni auditoría por el mero uso de correo. |
| T-09 | «Además, hay un enlace que te permita navegar a la aplicación.» / «De momento empecemos con con un enlace y luego, ya que luego ya la tarjetas adaptativas.» | Acceso inicial y evolución posterior, no fecha. |
| T-10 | «Si en Service Now se tendrá que enviar el listado de vacaciones aprobadas, solo las aprobadas por el por el cada 1 de los responsables.» / «con con que haya una descarga de las actualizaciones, una descarga nocturna es más que suficiente.» | Filtro de exportación y aceptación de descarga nocturna; cadencia por intercambio sin cerrar. |
| T-11 | «si se aprueban o se cancelan, habrá que notificárselas también a los usuarios» / «el usuario tiene que poderlas cancelar y el responsable puede rechazarlas.» / «no vamos a proponer alternativas» | Acciones y eventos citados, sin reglas completas de estados o de cancelación. |
| T-12 | «¿Cuándo ha ido vacaciones, cuáles las tiene aprobadas y cuáles no?» / «de manera sencilla» / «de manera muy visual» / «esta semana de julio en la que mi equipo está pidiendo vacaciones más allá de un 70% que le sea fácil de ver» | Consulta y ejemplo visual; subjetividad y fórmula pendientes. |
| T-13 | «como azure o Amazon» / «tenemos en en azure» / «antes del verano» / «antes de Semana Santa o antes de Navidad» / «Tienes que escalar dependiendo de la estación, no queremos estar pagando.» | Infraestructura mencionada, estacionalidad e intención de coste; no servicio, presupuesto o configuración decididos. |
| T-14 | «por por ejemplo, de 50 personas va a haber solamente, o sea, solamente va a haber un aprobador de vacaciones o o se va a poder delegar» | Pregunta y ejemplo, no límite exacto de tamaño ni regla de aprobadores. |
| T-15 | «Tenemos aproximadamente unos.» / «5040 proyectos a la vez del número varia.» | Cantidad corrupta o ambigua; no convertir a 40, 50, 5040 u otra cifra validada. |
| T-16 | «verlo valorarlo, aprobar o el echa cerrar colecciones» | No establecer acción de cierre a partir de ese pasaje. |
| T-17 | «con sistemas tipo myscaturing o algo así para para hacer una precarga de vacaciones o o poder validar validaciones de de algún tipo.» | Mención indeterminada, no integración o validación automática confirmada. |
| T-18 | «Pues tiene que lidiar en otra predicción en Barcelona.» / «Una nueva.» / «Luego ya veremos lo de la edición.» | Pasaje corrupto alrededor de modificación/nueva solicitud; edición pospuesta, flujo no reconstruido. |
| T-19 | «Yo creo que con esto tendríamos un envity.» | Término dudoso al cierre, no definición de MVP, entidad o entregable. |

### D. Errores probables y expresiones no verificables

| Expresión / fuente | Clasificación | Tratamiento |
| --- | --- | --- |
| «5040 proyectos», S1 T-15 | Probable error de transcripción o concatenación no resoluble con estas fuentes. | Solicitar cifra correcta; no corregir o dimensionar a partir de ella. |
| «Google», S1 T-04 | Posible error de transcripción dentro de una pregunta sobre organización. | No crear integración Google/Workspace ni sustituir silenciosamente por AD; confirmar término. |
| «envity», S1 T-19 | Posible error de transcripción sin significado definido. | No traducir como MVP, entidad o producto mínimo. |
| «echa cerrar colecciones», S1 T-16 y advertencia RF-048 | Pasaje corrupto que afecta al significado funcional. | Rechazo está citado en otro pasaje; cierre sigue sin confirmar, PA-06. |
| «refworkings», S1 junto al aviso de chat y enlace | Término no identificado. | No seleccionar herramienta o workflow; aclarar término junto a PA-23. |
| «myscaturing», S1 T-17 | Nombre dudoso de posible sistema. | No seleccionar sistema, proveedor o conector. |
| «Una piedra en todo el tío.», S1 tras intención de coste | Probable corrupción de transcripción. | Conservar intención explícita de evitar gasto innecesario, sin inventar importe, plataforma o ahorro. |
| Pasaje de «Barcelona», S1 T-18 | Probable corrupción en conversación de edición/cancelación. | No inventar un nuevo flujo de solicitud a partir de ese texto. |
| «muy visual», «fácil de ver», «fácilmente», «de manera sencilla», S1 T-12 y S2 RNF-002–RNF-005 | Subjetividad, no error de transcripción. | Acordar tareas, condiciones y medidas de éxito/tiempo/esfuerzo/legibilidad; los umbrales permanecen sin definir. |

La afirmación de S1 de que Teams desaparece «al cabo de x días» y el correo «permite auditoría» se
registra como explicación del interlocutor, no como política corporativa o garantía técnica de
retención. Debe validarse si se usa para requisitos de evidencia o conservación (PA-17).

### E. Valores y comportamiento ilustrativos de los mockups

| Valor / comportamiento | Fuente concreta | Estado frente a Discovery |
| --- | --- | --- |
| 12 personas de vacaciones | S4, indicador «Personas de Vacaciones». | Ilustrativo; S1 no confirma ese recuento. No confundir con «12 minutos» al inicio de la reunión. |
| 38/50 disponibles | S4, indicador semanal. | Ilustrativo; S1 no confirma esos disponibles ni ese denominador. La pregunta sobre 50 personas de T-14 no valida este indicador. |
| 65 % y 80 % | S4, celdas del calendario. | Ilustrativos, no umbrales de capacidad o rechazo confirmados. |
| 70 % | S4, leyenda; S5 `calendario`; S2 RF-009; S1 T-12. | Tiene respaldo textual como ejemplo de solicitudes por encima del 70 % en julio. No se considera solo invención visual, pero tampoco regla global/cupo cerrado; PA-08/PA-09. |
| 500 personas | S1 T-01 y S2 RNF-009. | Población departamental declarada. No validar 500 concurrentes del pie de S5 sin contrastar RNF-001. |
| 600, 1000 y cuatro personas | S1, pregunta de jerarquía y ejemplos de tamaño. | Ejemplos, no población objetivo adicional. |
| 48, 14, 16, 5, 9 y demás indicadores, nombres, proyectos, equipos y fechas | S5 `resumen`, `consulta`, `jerarquia`, `calendario`, `solicitudes`, `historial`. | Datos ilustrativos. No catálogo organizativo, cupo, fecha de entrega o datos personales confirmados. |
| Horas 02:00, 02:15 y 02:30 | S5 `notificaciones`, trazabilidad operativa. | Ilustrativas; RF-020 no fija hora ni secuencia de jobs. |
| Admin, Gerente, selección de varios departamentos/equipos | S4 perfil; S3 actores; S5 `consulta`/`jerarquia`. | No roles, niveles o alcance autorizados. Contrastar RT-005 y PA-01/PA-25. |
| Motivo visible, cancelación desde tabla de responsables y aprobación conjunta con una acción | S5 `solicitudes` y manejadores JS. | No validan visibilidad de motivo, permiso de cancelar ajenas o resolución de todos los aprobadores. El prototipo no define seguridad ni flujo real. |
| Fórmulas y notificaciones simuladas | S5 `runQueryBtn`, `updateCounters` y manejador `action-approve`. | Cálculos con constantes y cambios del DOM; no fórmulas de negocio ni evidencia de correo/ServiceNow realmente enviados. |

No se usan estos ejemplos para inventar actores, umbrales, volumen de migración o criterios de
aceptación. Cualquier adopción posterior debe quedar respaldada por una respuesta trazable, no por
su mera presencia en la imagen o el HTML.