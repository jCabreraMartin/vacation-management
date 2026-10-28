# Hoja de ruta de implementación: Gestión de vacaciones

**Tipo:** hoja de ruta general para un proyecto personal de aprendizaje  
**Fecha:** 2026-10-28  
**Estado de planificación:** inicial; no es compromiso de calendario, presupuesto, capacidad ni entrega  
**Estado de requisitos:** las siete features, historias, criterios de aceptación y casos de uso disponibles siguen `Draft / LAB-HYP`. No se han validado con stakeholders de negocio reales.

## Cómo interpretar esta hoja de ruta

Esta hoja de ruta adapta un ciclo de entrega empresarial al ejercicio personal. No afirma que haya una organización, equipo contratado, usuario de negocio, ambiente productivo ni aprobación real. Las fases de UAT, go-live e hypercare se conservan para aprendizaje, pero su aplicación a un producto real es opcional y condicionada.

- **Hecho existente:** decisión constitucional vinculante o contenido que consta en los artefactos actuales.
- **Baseline del laboratorio:** comportamiento hipotético que puede usarse como base de trabajo del ejercicio, pero sigue en Draft.
- **Recomendación:** enfoque sugerido para aprender y construir; requiere aceptación antes de convertirse en decisión.
- **Abierto:** información o elección que las fuentes no resuelven. No se cubre con valores por defecto.
- **Complejidad inicial:** apreciación cualitativa de alcance e incertidumbre; no es duración ni compromiso.

La constitución canónica indica que solo las decisiones aprobadas en su resumen final son vinculantes. Las opciones sin marcar y los ejemplos de plantilla no se tratan como decisiones.

## Punto de partida

### Hechos del proyecto

- **Constitución:** greenfield y full-stack; backend C#/.NET 8; frontend Angular sin versión; Podman para desarrollo local; GitHub Actions; Terraform; entornos dev/uat/prod, con `pre` deshabilitado; rolling deploy; GitHub Flow; OpenTelemetry hacia Azure; VNet, Private Endpoints, WAF, TLS 1.2+, claves administradas por Azure y cifrado de PII; 80 % de cobertura unitaria, 60 % de mutación y cero críticos en los escaneos seleccionados.
- **Gestión de trabajo:** GitHub Projects está seleccionado en la constitución. Esta hoja de ruta no crea ni sincroniza elementos de trabajo.
- **Conflicto constitucional:** el trigger de dev indicado como commit en `develop` contradice GitHub Flow y debe confirmarse antes de automatizarlo.
- **Decisiones sin seleccionar:** estilo arquitectónico, estilo/protocolo de API, base de datos, patrón de acceso a datos, CQRS/event sourcing, comunicación síncrona/asíncrona, proveedor de identidad, modelo de autorización, API gateway, contenedores/orquestador y alcance de infraestructura.

### Baseline de aprendizaje

- La baseline describe el flujo hipotético de solicitud con los actores `Empleado` y `Responsable aprobador`.
- Hay siete features, siete historias y catorce criterios iniciales, todos en Draft/LAB-HYP: presentar (LAB-F001), validar fechas (LAB-F002), consultar propias (LAB-F003), consultar pendientes asignadas (LAB-F004), aprobar (LAB-F005), rechazar (LAB-F006) y retirar (LAB-F007).
- El ciclo de estados de laboratorio contempla `Pendiente → Aprobada | Rechazada | Retirada`. “En revisión” no está definido como estado.
- Los UCs y Gherkin documentan flujos principales, denegaciones y errores; también dejan sin resolver los mensajes exactos, fallos de persistencia, concurrencia, estado vacío y retraso de actualización.
- Hay mockups estáticos para LAB-F001 y LAB-F003 a LAB-F007. LAB-F002 no tiene mockup separado: sus errores se representan en el flujo de presentación de LAB-F001. Los mockups son referencias de aprendizaje, no diseños aprobados.
- No hay integraciones funcionales documentadas, modelo de datos completo, proveedor de identidad elegido, objetivos NFR ni reglas de saldo de días.

### Trazabilidad de las features de laboratorio

Todas las filas siguientes reflejan artefactos de trabajo `Draft / LAB-HYP`; no son requisitos aprobados. Los gaps se conservan como preguntas y no como tareas funcionales ya decididas.

| Feature y alcance de trabajo | Requisitos / historia / AC | UC y Gherkin | Referencia visual / límite principal |
| --- | --- | --- | --- |
| LAB-F001 — presentar solicitud | BR-001 (parcial), FR-001, SEC-001; US-LAB-F001-01; AC-LAB-F001-01/02 | [UC-001](../../specs/lab-001-submit-vacation-request/requirements/use-cases/UC-001.md); [Gherkin](../../specs/lab-001-submit-vacation-request/tests/submit-vacation-request.feature) | [Mockups](../../specs/lab-001-submit-vacation-request/mockups/README.md); intervalos completos, formato, zona horaria y confirmación siguen abiertos. |
| LAB-F002 — validar fechas | FR-006; US-LAB-F002-01; AC-LAB-F002-01/02 | [UC-002](../../specs/lab-002-validate-vacation-date-range/requirements/use-cases/UC-002.md); [Gherkin](../../specs/lab-002-validate-vacation-date-range/tests/validate-vacation-date-range.feature) | Sin mockup separado: los errores están en F001. No se añaden reglas de calendario ni copy definitivo. |
| LAB-F003 — consultar propias | FR-002, SEC-001; US-LAB-F003-01; AC-LAB-F003-01/02 | [UC-003](../../specs/lab-003-view-own-vacation-requests/requirements/use-cases/UC-003.md); [Gherkin](../../specs/lab-003-view-own-vacation-requests/tests/view-own-vacation-requests.feature) | [Mockups](../../specs/lab-003-view-own-vacation-requests/mockups/README.md); orden, filtros y estado vacío no definidos. |
| LAB-F004 — consultar pendientes asignadas | FR-003, SEC-001; US-LAB-F004-01; AC-LAB-F004-01/02 | [UC-004](../../specs/lab-004-view-assigned-pending-requests/requirements/use-cases/UC-004.md); [Gherkin](../../specs/lab-004-view-assigned-pending-requests/tests/view-assigned-pending-requests.feature) | [Mockups](../../specs/lab-004-view-assigned-pending-requests/mockups/README.md); asignación, cardinalidad, campos y orden no definidos. |
| LAB-F005 — aprobar | FR-004 (outcome aprobación), SEC-001; US-LAB-F005-01; AC-LAB-F005-01/02 | [UC-005](../../specs/lab-005-approve-vacation-request/requirements/use-cases/UC-005.md); [Gherkin](../../specs/lab-005-approve-vacation-request/tests/approve-vacation-request.feature) | [Mockups](../../specs/lab-005-approve-vacation-request/mockups/README.md); registro concurrente y respuesta ante fallos no definidos. |
| LAB-F006 — rechazar | FR-004 (outcome rechazo), SEC-001; US-LAB-F006-01; AC-LAB-F006-01/02 | [UC-006](../../specs/lab-006-reject-vacation-request/requirements/use-cases/UC-006.md); [Gherkin](../../specs/lab-006-reject-vacation-request/tests/reject-vacation-request.feature) | [Mockups](../../specs/lab-006-reject-vacation-request/mockups/README.md); motivo/comentario no decidido. |
| LAB-F007 — retirar pendiente propia | FR-005, FR-002 parcial, SEC-001; US-LAB-F007-01; AC-LAB-F007-01/02 | [UC-007](../../specs/lab-007-withdraw-pending-vacation-request/requirements/use-cases/UC-007.md); [Gherkin](../../specs/lab-007-withdraw-pending-vacation-request/tests/withdraw-pending-vacation-request.feature) | [Mockups](../../specs/lab-007-withdraw-pending-vacation-request/mockups/README.md); “En revisión”, confirmación previa y manejo de concurrencia siguen abiertos. |

## Fases de la hoja de ruta

### Phase 0 — Discovery & Inception

**Objetivo y alcance:** establecer el propósito del ejercicio, el límite de lo que se construirá y el carácter ficticio del conjunto de requisitos; separar el aprendizaje del producto real.

**Actividades:** revisar baseline, catálogo, aclaraciones, constitución y fuentes; registrar objetivos de aprendizaje; identificar los dos actores existentes sin crear personas adicionales; decidir qué partes del roadmap se ejecutarán realmente.

**Entregables:** D0.1 ficha de alcance del ejercicio; D0.2 inventario de fuentes y estado de evidencia. Ambos propuestos; la baseline y el resumen existentes son insumos.

**Dependencias:** inicio; acceso a los artefactos vigentes.

**Riesgos y mitigaciones:** confundir LAB-HYP con requisitos reales; conservar el estado Draft y marcar las propuestas. Complejidad de programa innecesaria; limitar el alcance al aprendizaje individual.

**Suposiciones y preguntas abiertas:** ¿se quiere únicamente una aplicación de práctica local o también aprender despliegue? ¿Qué resultados de aprendizaje son prioritarios? LAB-OQ-001/Q-001 sigue abierta para el producto real.

**Entrada:** constitución y baseline disponibles. **Salida:** alcance de aprendizaje y reglas de trazabilidad documentados, sin afirmar aprobación externa.

**Roles recomendados:** Product Owner, Business Analyst, Scrum Master.

**Complejidad estimada inicial:** Baja.

### Phase 1 — Requirements Analysis

**Objetivo y alcance:** ordenar los requisitos disponibles y convertir las dudas en trabajo explícito de clarificación. La baseline de planificación es la actual; no se le cambia el estado.

**Actividades por categoría:**

- **Business requirements:** BR-001 describe un flujo centralizado hipotético de presentar y registrar decisiones. Su relación con una necesidad real sigue sin confirmar (LAB-OQ-001/Q-001).
- **Functional requirements:** FR-001 presentar fechas y comentario opcional; FR-002 consultar lista/detalle/estado propios; FR-003 consultar pendientes asignadas; FR-004 aprobar o rechazar pendientes y consultar resultado; FR-005 retirar una pendiente; FR-006 rechazar fechas ausentes o intervalo invertido; SEC-001 limitar acceso por propiedad/asignación.
- **Non-functional requirements:** no hay objetivos funcionales cuantificados de rendimiento, disponibilidad, capacidad, accesibilidad, retención, recuperación ni frescura de estado (LAB-OQ-010/Q-019).
- **Technical constraints:** C#/.NET 8, Angular sin versión fijada, Podman local, GitHub Actions, Terraform, GitHub Flow, rolling y entornos dev/uat/prod con `pre` deshabilitado son constitucionales. API style, protocolo, base de datos y varios patrones no están seleccionados.
- **Security and compliance:** SEC-001 es una regla hipotética de acceso. La constitución tiene controles de red, cifrado y WAF; GDPR/HIPAA aparecen seleccionados por el asistente, pero aplicabilidad, obligaciones y evidencia de cumplimiento no están definidas.
- **User journeys:** presentar/validar; consultar solicitudes propias; consultar pendientes asignadas; aprobar; rechazar; retirar. Se trazan a UC-001–UC-007 y Gherkin.
- **Personas o actores:** solo `Empleado` y `Responsable aprobador` están en la baseline. No se crean personas ficticias adicionales. El `Sistema` en la validación es un participante, no un actor humano adicional.
- **Acceptance criteria:** 14 AC iniciales; no son aceptación aprobada. Los Gherkin los relacionan con escenarios, pero los resultados “error comprensible”, fallos, consultas vacías y concurrencia siguen incompletos.
- **Requirement prioritization:** prioridad y esfuerzo no están definidos en las features. Etiquetas `@smoke` de Gherkin son clasificación de pruebas, no prioridad de producto.

**Entregables:** D1.1 mapa de requisitos y trazabilidad (derivado de artifacts existentes); D1.2 registro de aclaraciones priorizable (el resumen existente sirve de base); D1.3 baseline de trabajo del ejercicio, con estado Draft preservado.

**Dependencias:** Phase 0; decisiones de propósito y alcance.

**Riesgos y mitigaciones:** falsa precisión en campos, reglas o AC; dejar “no definido” y abrir pregunta. Divergencia entre requisitos, UCs, Gherkin y mockups; mantener IDs y revisar cambios juntos.

**Suposiciones y preguntas abiertas:** LAB-OQ-001–010 y Q-001–025 siguen vigentes según el resumen. No responderlas en planificación.

**Entrada:** alcance de aprendizaje identificado. **Salida:** cada flujo puede trazarse a una fuente; gaps y criterios pendientes están visibles; no hace falta que estén aprobados por negocio para continuar con un prototipo didáctico.

**Roles recomendados:** Product Owner, Business Analyst, QA Engineer, UX/UI Designer.

**Complejidad estimada inicial:** Media, principalmente por la cantidad de preguntas sin resolver.

### Phase 2 — Solution Architecture & Design

**Objetivo y alcance:** convertir las restricciones constitucionales y el modelo conceptual en decisiones de arquitectura aptas para el ejercicio, sin elevar propuestas a decisiones vinculantes.

**Actividades:** revisar `architecture-overview.md` y `domain-model.md`; validar límites modulares, responsabilidades de UI/backend y casos de uso; elegir API, persistencia, identidad y autorización solo después de investigar/aceptar alternativas; resolver la contradicción del trigger dev; mantener fuera del diseño las integraciones no evidenciadas.

**Entregables:** D2.1 overview arquitectónico existente, hoy marcado como propuesta; D2.2 modelo de dominio conceptual existente, Draft/LAB-HYP; D2.3 decisiones técnicas revisadas, solo si se acuerdan. No crear ADR en esta hoja de ruta.

**Dependencias:** Phase 1; preguntas de alcance que afectan los límites funcionales.

**Riesgos y mitigaciones:** interpretar un modelo conceptual Draft como DDD aprobado; tratar el agregado, identidad o relaciones como preguntas. Elegir base de datos/API por plantilla; consultar la constitución, que las deja abiertas.

**Suposiciones y preguntas abiertas:** el monolito modular de `architecture-overview.md` es propuesta, no decisión constitucional. ¿Qué estilo de API, persistencia, identity provider, autorización, CQRS o comunicación se eligen?

**Entrada:** actores, flujos y restricciones están catalogados. **Salida:** límites y elecciones necesarias están revisados; las no elegidas permanecen etiquetadas como pendientes.

**Roles recomendados:** Solution Architect, Technical Lead, Backend Developer, Frontend Developer, Data Architect, Security Engineer.

**Complejidad estimada inicial:** Media.

### Phase 3 — UX/UI Design

**Objetivo y alcance:** revisar los flujos visuales de las features con interfaz y ajustar mockups antes de su consumo por implementación.

**Actividades:** revisar listas, detalles, formularios, acciones, estados empty/loading/error/success; validar placeholders y datos ilustrativos; corregir gaps de contenido; conservar responsive y accesibilidad básica.

**Entregables:** D3.1 mockups existentes de LAB-F001 y LAB-F003–F007 con sus README/CHANGELOG; D3.2 cambios de mockup como propuestas tras feedback. No hay mockup separado para LAB-F002 porque sus errores se muestran en LAB-F001.

**Dependencias:** Phase 1; el contenido de negocio de listas/detalles y mensajes se mantiene provisional.

**Riesgos y mitigaciones:** considerar los mockups aprobados; identificarlos como wireframes. Convertir placeholders en copy final sin evidencia; esperar aclaración.

**Suposiciones y preguntas abiertas:** ¿qué campos de detalle/lista mostrar, qué textos son adecuados y qué interacción se espera? LAB-OQ-002/009 y Q-005/Q-009–012 siguen abiertas.

**Entrada:** historias con UI identificadas. **Salida:** mockups revisados como referencia de aprendizaje; no se infiere aprobación de usuario final.

**Roles recomendados:** UX/UI Designer, Product Owner, Business Analyst, Frontend Developer.

**Complejidad estimada inicial:** Media.

### Phase 4 — Infrastructure & DevOps Setup

**Objetivo y alcance:** preparar herramientas locales y pipeline reproducible. El aprovisionamiento cloud y la plataforma de ejecución quedan fuera hasta tener alcance y decisiones.

**Actividades:** preparar solución compatible con Podman para desarrollo local; configurar GitHub Actions y GitHub Flow; validar gates constitucionales; preparar estructura Terraform solo cuando exista infraestructura acordada; resolver el trigger de dev contradictorio antes de automatizar.

**Entregables:** D4.1 entorno local Podman; D4.2 pipeline CI; D4.3 estructura IaC Terraform, condicionada a un objetivo de infraestructura; D4.4 estrategia de promoción/entornos.

**Dependencias:** Phase 2 para componentes y necesidades locales; decisiones pendientes sobre plataforma e infraestructura.

**Riesgos y mitigaciones:** desplegar a nube sin destino aprobado; dejar IaC y entornos cloud como opcionales. Activar pipelines con trigger incoherente; resolver primero la contradicción GitHub Flow/`develop`.

**Suposiciones y preguntas abiertas:** no asumir AKS, Container Apps, App Service, API Management, Aspire ni landing zone; sus selecciones están sin marcar. ¿El aprendizaje incluye Terraform contra un entorno Azure real o solo validación local?

**Entrada:** herramientas y alcance acordados. **Salida:** CI local/remoto ejecuta gates seleccionados; infraestructura no se provisiona hasta tener autorización y target.

**Roles recomendados:** DevOps Engineer, Platform Engineer, Technical Lead, Security Engineer.

**Complejidad estimada inicial:** Media; alta si incluye cloud no decidido.

### Phase 5 — Foundation Development

**Objetivo y alcance:** establecer los esqueletos de frontend/backend, configuración, límites de dependencias y telemetría mínima antes de las features.

**Actividades:** inicializar aplicación Angular y backend .NET 8; organizar módulos según arquitectura aceptada; preparar configuración y secretos de desarrollo según constitución; enlazar OpenTelemetry; establecer health checks del template constitucional; automatizar pruebas estructurales.

**Entregables:** D5.1 shell de aplicación; D5.2 skeleton modular backend; D5.3 configuración local sin secretos en repositorio; D5.4 health checks y trazabilidad base; D5.5 pruebas de arquitectura iniciales.

**Dependencias:** decisiones mínimas de Phase 2; entorno de Phase 4.

**Riesgos y mitigaciones:** construir abstracciones para decisiones no tomadas; limitar la fundación a fronteras aceptadas. Confundir muestra de constitución con arquitectura elegida; registrar solo selections confirmadas.

**Suposiciones y preguntas abiertas:** versión Angular, API style, estructura de solución y opciones de CQRS siguen abiertas; esta fase debe dejar puntos de extensión simples y reversibles.

**Entrada:** gates CI y elecciones esenciales están disponibles. **Salida:** shell ejecutable y comprobable, sin comportamiento de negocio añadido.

**Roles recomendados:** Technical Lead, Frontend Developers, Backend Developers, DevOps Engineer, QA Engineer.

**Complejidad estimada inicial:** Media.

### Phase 6 — Core Business Features Development

**Objetivo y alcance:** implementar progresivamente los siete flujos del laboratorio usando sus AC/Gherkin, sin incorporar reglas abiertas.

**Secuencia recomendada:**

1. LAB-F001 presentación junto con la capacidad de validación LAB-F002; LAB-F002 no es un prerrequisito independiente según UC-001.
2. LAB-F003 consulta propia y LAB-F004 bandeja asignada, después de resolver cómo representar identidad/propiedad/asignación en el entorno de aprendizaje.
3. LAB-F005 aprobación, LAB-F006 rechazo y LAB-F007 retirada usando el ciclo de estados documentado, manteniendo “En revisión” sin inventar semántica.

**Actividades:** convertir escenarios existentes en pruebas ejecutables; implementar por cortes pequeños; validar cada resultado y autorización; revisar actualizaciones de estado desde el flujo de consulta.

**Entregables:** D6.1 features implementadas por orden acordado; D6.2 pruebas unitarias/integración; D6.3 trazabilidad AC→Gherkin→tests; D6.4 evidencia de gates.

**Dependencias:** Phases 1–5; claridad suficiente de identidad, pertenencia y asignación para los flujos protegidos.

**Riesgos y mitigaciones:** resolver preguntas de negocio durante el código; dejar bloqueo/placeholder o excluirlo, no decidirlo. La asignación ambigua puede romper autorización; no ampliar el ámbito por defecto. Concurrencia y fallos de persistencia sin regla; registrar gaps y no anunciar garantía no probada.

**Suposiciones y preguntas abiertas:** LAB-OQ-002–008, Q-003–016 y Q-020–024 pueden afectar implementación; no agregar saldo, calendarios, motivo obligatorio, notificaciones ni historial de decisiones.

**Entrada:** foundation pasa gates y reglas implementables están identificadas. **Salida:** escenarios cubiertos que no dependen de respuestas pendientes; cualquier exclusión tiene trazabilidad y no se presenta como completa.

**Roles recomendados:** Backend Developers, Frontend Developers, Technical Lead, QA Engineers, Security Engineer, Product Owner.

**Complejidad estimada inicial:** Alta, por autorización/asignaciones y reglas de estado aún abiertas.

### Phase 7 — Integrations

**Objetivo y alcance:** decidir si existen integraciones requeridas; no construir conectores por anticipado.

**Actividades:** revisar LAB-OQ-009/Q-017–018; si aparece una fuente aprobada, identificar propietario, datos, dirección, protocolo, autenticación, fallo y aceptación antes del diseño.

**Entregables:** D7.1 decisión de aplicabilidad de integraciones; D7.2 inventario/contratos de integración solo si se confirman. No se producen contratos en esta hoja de ruta.

**Dependencias:** Phase 1 y aclaración de Q-017/Q-018; identidad/datos para delimitar responsabilidades.

**Riesgos y mitigaciones:** tratar Azure Observability como integración de negocio; mantenerla separada como destino técnico constitucional. Crear sincronización con RR. HH./nómina/calendario sin evidencia; ninguna está actualmente documentada.

**Suposiciones y preguntas abiertas:** no hay sistemas externos de negocio identificados. Si no se confirman necesidades, la fase queda no aplicable al laboratorio actual.

**Entrada:** pregunta de integraciones revisada. **Salida:** no aplica documentado, o alcance suficiente para planificar una integración aprobada.

**Roles recomendados:** Solution Architect, Business Analyst, Backend Developer, Security Engineer, DevOps Engineer.

**Complejidad estimada inicial:** Baja si no aplica; indeterminada si se confirma una integración.

### Phase 8 — Security & Compliance

**Objetivo y alcance:** aplicar controles constitucionales pertinentes y aclarar el modelo de identidad, autorización y tratamiento de datos; no afirmar certificación ni aplicabilidad regulatoria.

**Actividades:** mantener TLS 1.2+, cifrado/PII, VNet/Private Endpoints/WAF y escaneo 0 críticos en el diseño; revisar amenazas para lectura/escritura por propiedad/asignación; clasificar datos; decidir proveedor/flujo de identidad y autorización; determinar alcance de GDPR/HIPAA con evidencia.

**Entregables:** D8.1 evaluación de amenazas del ejercicio; D8.2 matriz de autorización basada en decisiones aclaradas; D8.3 evaluación de aplicabilidad/cumplimiento, solo cuando exista contexto verificable.

**Dependencias:** Phase 1; modelo de datos e identidad; Phase 2.

**Riesgos y mitigaciones:** afirmar que datos de vacaciones son PII sin clasificación; aplicar cifrado constitucional a los datos que sean PII y documentar clasificación como pendiente. Interpretar GDPR/HIPAA seleccionados como cumplimiento logrado; declararlos opciones seleccionadas que requieren aplicabilidad y evidencia.

**Suposiciones y preguntas abiertas:** LAB-OQ-008/Q-013–016; no se conocen jurisdicción, usuarios reales, retención, auditoría ni obligaciones regulatorias específicas.

**Entrada:** datos y flujos de identidad descritos suficientemente. **Salida:** controles constitucionales comprobables; decisiones no resueltas registradas sin declaración de conformidad.

**Roles recomendados:** Security Engineer, Solution Architect, Data Architect, Backend Developer, Product Owner.

**Complejidad estimada inicial:** Media; cumplimiento real queda indeterminado.

### Phase 9 — Testing & Quality Assurance

**Objetivo y alcance:** verificar requisitos implementados y los gates constitucionales; distinguir cobertura automatizada de aceptación de negocio.

**Actividades:** ejecutar Gherkin/Reqnroll según el stack elegido; unit/integration/E2E; validar autorización de SEC-001 y transiciones; aplicar 80 % cobertura unitaria, 60 % mutación y cero críticos en security/container scans; revisar accesibilidad sin inventar umbral.

**Entregables:** D9.1 estrategia de pruebas; D9.2 suites y resultados; D9.3 matriz AC/Gherkin/test; D9.4 informe de defectos y gaps; D9.5 evidencia de gates.

**Dependencias:** foundation y features; identidad/test data suficientemente definidos; pipeline disponible.

**Riesgos y mitigaciones:** escenarios aprobados no equivalen a sistema validado; reportar resultados solo para lo ejecutado. Gaps de fallo/concurrencia/empty state; enumerarlos como cobertura pendiente en vez de fabricar comportamiento esperado.

**Suposiciones y preguntas abiertas:** framework de BDD constitution enumera SpecFlow/Reqnroll sin una elección fina; usar Reqnroll solo tras confirmar disponibilidad. No hay threshold branch coverage en decisiones resumidas para este roadmap.

**Entrada:** artefactos aceptados como baseline de pruebas y build disponible. **Salida:** gates vinculantes aplicables pasan; fallos y escenarios bloqueados están registrados.

**Roles recomendados:** QA Engineers, Backend Developers, Frontend Developers, Technical Lead, Security Engineer.

**Complejidad estimada inicial:** Alta por cobertura de estados/authorization y gaps pendientes.

### Phase 10 — User Acceptance Testing

**Objetivo y alcance:** comprobar la experiencia contra el material Draft del laboratorio; no simular aprobación de stakeholders reales.

**Actividades:** recorrer los siete journeys con los mockups y escenarios; revisar errores, contenido y estados con el usuario del proyecto personal; anotar feedback separado de requisitos de producto.

**Entregables:** D10.1 registro de revisión personal/UAT simulada; D10.2 gaps y cambios propuestos; D10.3 actualización de baseline solo si el autor decide y documenta el cambio.

**Dependencias:** features integradas, QA de Phase 9, mockups revisados y ambientes de prueba si se decide usarlos.

**Riesgos y mitigaciones:** llamar “UAT aprobada” a una autoevaluación; etiquetarla como simulada/personal. Las decisiones no contestadas siguen abiertas.

**Suposiciones y preguntas abiertas:** Product Owner/persona real no está designado; Q-025 pregunta quién aceptará AC. No programar sesiones con usuarios imaginarios.

**Entrada:** flujo de aprendizaje ejecutable y criterios trazables. **Salida:** revisión documentada, con feedback/defectos y sin sign-off ficticio.

**Roles recomendados:** Product Owner, Business Analyst, QA Engineer, UX/UI Designer; participación de desarrolladores para observar.

**Complejidad estimada inicial:** Baja o media, según la amplitud del auto-recorrido.

### Phase 11 — Deployment & Go-Live

**Objetivo y alcance:** describir la opción de despliegue como fase condicional; no hay target de producción ni deployment platform seleccionados y no se asume go-live real.

**Actividades:** decidir si el ejercicio necesita despliegue; confirmar target, alcance Terraform, red/secretos, entorno, rollback, rolling y approvals; resolver trigger de dev frente a GitHub Flow; ejecutar revisión previa y validación posterior solo con entorno autorizado.

**Entregables:** D11.1 decisión de si se despliega; D11.2 runbook/checklist si se elige; D11.3 evidencia del despliegue de aprendizaje si se ejecuta. No crear infraestructura en este paso.

**Dependencias:** fases 4, 8 y 9; decisión de plataforma y autorización/costos.

**Riesgos y mitigaciones:** interpretar entorno `prod` de constitución como obligación de desplegar; distinguir configuración objetivo de alcance del ejercicio. Desplegar sobre recursos sin autorización; no ejecutar hasta confirmar suscripción, ownership y costo.

**Suposiciones y preguntas abiertas:** destino/orchestrator sin decidir; presupuesto, región, DNS, certificados, dominio, rollback, backup y RTO/RPO sin requisitos.

**Entrada:** artefacto validado, objetivo de entorno y autorización confirmados. **Salida:** solo si se ejecuta, smoke/health checks completados y resultado registrado; “go-live” real queda fuera si no hay servicio/usuarios objetivo.

**Roles recomendados:** DevOps Engineer, Platform Engineer, Solution Architect, Security Engineer, Technical Lead, Product Owner (decisión de despliegue).

**Complejidad estimada inicial:** No determinable hasta elegir destino; baja si no se despliega.

### Phase 12 — Hypercare

**Objetivo y alcance:** soporte cercano posterior a un despliegue, solo si Phase 11 ocurre en un entorno usado por personas distintas del autor.

**Actividades:** observar logs/traces/health, registrar problemas, diferenciar incidentes de preguntas de requisitos, establecer canal y período solo cuando haya participantes y expectativas reales.

**Entregables:** D12.1 registro temporal de observación/incidentes, condicional; D12.2 cierre de hypercare, condicional.

**Dependencias:** despliegue y usuarios/operación definidos.

**Riesgos y mitigaciones:** inventar SLA, guardias o severidades; no establecerlos para un ejercicio personal. Ausencia de usuarios: declarar fase no aplicable.

**Suposiciones y preguntas abiertas:** no hay producción ni modelo de soporte evidenciado; no hay objetivos de disponibilidad.

**Entrada:** un despliegue con usuarios/observabilidad acordados. **Salida:** issues trasladados a backlog de aprendizaje o continuidad operativa acordada; de lo contrario, fase no aplica.

**Roles recomendados:** Backend/Frontend Developers, DevOps Engineer, QA Engineer, Product Owner; Security Engineer si hay incidente de seguridad.

**Complejidad estimada inicial:** No aplicable sin despliegue/usuarios; indeterminada si se habilita.

### Phase 13 — Continuous Improvement

**Objetivo y alcance:** iterar el proyecto personal a partir de pruebas, feedback propio, riesgos y preguntas resueltas, sin tratarlo como servicio en producción.

**Actividades:** revisar calidad, defectos, documentación, gates, gaps de requisitos y valor de aprendizaje; escoger una mejora acotada; mantener GitHub Projects como gestión del trabajo según constitución si se decide registrar trabajo.

**Entregables:** D13.1 revisión de aprendizaje/mejora; D13.2 cambios priorizados para una iteración futura; D13.3 documentación actualizada.

**Dependencias:** al menos una revisión de Phase 9 o una entrega/experimento.

**Riesgos y mitigaciones:** ampliar el alcance sin clarificar reglas; mantener preguntas abiertas. Considerar métricas operativas sin servicio real; usar solo evidencia disponible, no SLO ficticios.

**Suposiciones y preguntas abiertas:** cadencia, objetivos de mejora y ownership no definidos. GitHub Projects está seleccionado; no se crean ni sincronizan tareas en esta hoja de ruta.

**Entrada:** evidencia de pruebas/uso y una pregunta de mejora. **Salida:** una mejora acordada o documentación de que no se continúa.

**Roles recomendados:** Product Owner, Scrum Master, Technical Lead, QA Engineer y perfiles implementadores pertinentes.

**Complejidad estimada inicial:** Baja para retrospectiva personal; variable según la mejora elegida.

## Actividades transversales por fase

**Claves:** `A` = aplicable; `O` = opcional/condicional; `ND` = no definido, requiere clarificación; `NA` = no aplicable al alcance actual. Cada celda incluye la justificación resumida.

| Fase | Arquitectura | Seguridad | DevOps | Testing | Documentación | Compliance | Rendimiento | Observabilidad |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0 Discovery & Inception | A: límite del ejercicio | O: revisar baseline | O: aclarar objetivo de despliegue | O: acordar evidencia | A: fuentes/alcance | ND: aplicabilidad | ND: objetivos | O: distinguir aprendizaje/operación |
| 1 Requirements Analysis | A: requisitos y constraints | A: SEC-001; identity abierta | O: restricciones pipeline | A: AC/Gherkin | A: trazabilidad | ND: obligaciones | ND: sin targets | O: identificar señales, sin umbrales |
| 2 Architecture & Design | A: decisiones propuestas | A: access/data boundaries | O: encaje de Terraform/Podman | A: testability | A: modelo y decisiones | ND: impacto no evaluado | ND: sin presupuesto objetivo | A: OTel constitucional |
| 3 UX/UI Design | O: frontera UI/backend | A: privacidad/errores | NA: no configura pipeline | A: revisar estados | A: mockups e index | ND: criterios no definidos | ND: no hay objetivos | O: estados de error sin telemetría definida |
| 4 Infrastructure & DevOps Setup | O: entorno local/cloud scope | A: red, secretos, scans | A: GH Actions/Terraform/Podman | A: gates CI | A: pipeline/runbook | O: validar políticas si infra elegida | O: coste/perf sin targets | A: destino OTel, alertas pendientes |
| 5 Foundation Development | A: límites modulares | A: identidad/config segura | A: config/build | A: smoke/architecture tests | A: setup local | O: clasificación PII | ND: no medir objetivo | A: instrumentación base |
| 6 Core Features | A: módulos por feature | A: propiedad/asignación | O: integración CI | A: Gherkin/unit/integration | A: trazabilidad AC | O: controles según datos | ND: no thresholds | O: traces de journey |
| 7 Integrations | O: solo si confirmadas | A: revisar trust boundary | O: conectividad/secrets | A: pruebas de contrato si aplica | A: catálogo/contrato condicional | ND: según integración | ND: sin SLA/throughput | O: telemetría de dependencia |
| 8 Security & Compliance | A: threat boundaries | A: controles constitución | O: pipeline/security scan | A: auth/security tests | A: evidencias/decisiones | ND: aplicabilidad GDPR/HIPAA | ND: sin targets | O: eventos de seguridad/telemetría sin policy |
| 9 Testing & QA | A: architecture tests | A: security scans/tests | A: CI gates | A: xUnit/Reqnroll/Playwright según elección | A: resultados/gaps | O: compliance testing si se define | O: performance tests sin target | A: validar exportación/health |
| 10 UAT | O: revisar coherencia | O: revisar permisos | O: ambiente de test si se usa | A: recorridos AC | A: registro de feedback | ND: no stakeholder/regla | ND: sin SLA | O: observar errores durante prueba |
| 11 Deployment & Go-Live | A: decisiones de plataforma | A: hardening/config | A: GH Actions/Terraform/rolling | A: pre/post deploy checks | A: runbook si se despliega | ND: aprobación regulatoria no establecida | ND: sin capacidad | A: health/OTel, alerting abierto |
| 12 Hypercare | O: cambios por incidentes | O: incidente de seguridad | O: operación del ambiente | A: smoke/regresión si aplica | A: registro de soporte | ND: depende de uso real | ND: sin SLO | A: OTel si desplegado |
| 13 Continuous Improvement | A: revisar límites | A: revisar findings | O: pipeline/infra improvements | A: regresión/gates | A: mantener roadmap | O: si hay obligación confirmada | ND: medir solo con objetivo acordado | A: mejoras basadas en evidencia |

## Equipo recomendado para el ejercicio

Son **roles hipotéticos recomendados**, no personas, puestos contratados ni staffing confirmado. En un proyecto personal, una sola persona puede asumir varios roles; no hace falta simular un organigrama completo.

| Rol recomendado | Responsabilidades | Entregables clave | Participación por fase |
| --- | --- | --- | --- |
| Product Owner | Mantener objetivo/prioridad del ejercicio; decidir qué aclaraciones se simulan; aceptar cambios de alcance. | Alcance, prioridad, decisión de qué fases ejecutar, revisión de mockups/UAT simulada. | 0–3, 6, 10–13 |
| Business Analyst | Trazar BR/FR/AC/UC, facilitar aclaraciones y glosario sin responder por los actores. | Mapa de requisitos, catálogo de preguntas, journeys, trazabilidad. | 0–3, 6, 10, 13 |
| Scrum Master | Facilitar flujo incremental, riesgos y retrospectiva; en autoaprendizaje su función es opcional. | Acuerdos de trabajo y revisión de flujo, si se utiliza. | 0–1, 4–6, 9–13 |
| Solution Architect | Mantener límites, decisiones y trade-offs alineados con constitución; no fijar opciones abiertas unilateralmente. | Overview, alternativas, dependencias, riesgos arquitectónicos. | 0–5, 7–9, 11–13 |
| Technical Lead | Asegurar coherencia técnica, revisión, boundaries y calidad. | Estructura de foundation, criterios técnicos, revisión de gates. | 2, 4–9, 11–13 |
| Frontend Developers | Construir Angular, formularios/listas/detalles y estados responsive accesibles. | Shell/UI, componentes, pruebas frontend. | 3–6, 9–13 |
| Backend Developers | Implementar casos de uso .NET, reglas y acceso autorizado conforme a decisiones. | Foundation backend, features, pruebas unitarias/integración. | 2, 4–9, 11–13 |
| QA Engineers | Relacionar AC con pruebas, revisar gaps y resultados de regresión/aceptación. | Plan/matriz de pruebas, informes, automatización BDD/E2E. | 1, 3, 5–7, 9–13 |
| DevOps Engineers | Configurar CI/CD, Podman local, Terraform y operación de despliegue si aplica. | Pipelines, IaC y runbooks condicionales. | 2, 4–5, 7–9, 11–13 |
| Security Engineer | Revisar amenazas, autorización, clasificación PII y controles constitucionales. | Threat review, recomendaciones y evidencia de scan. | 1–2, 4–9, 11–13 |
| UX/UI Designer | Elaborar/revisar mockups, estados y accesibilidad visual. | Mockups, índices, revisión de contenido. | 1–3, 10, 13 |
| Data Architect | Facilitar propiedad/fuente de verdad, modelo y retención; no elegir tecnología sin acuerdo. | Revisión de datos y preguntas de modelo, si se necesita. | 1–2, 6–8, 13 |
| Platform Engineer | Revisar red, plataforma Azure, observabilidad e IaC cuando exista despliegue real. | Diseño de plataforma/seguridad y soporte de deployment, condicional. | 2, 4, 7–9, 11–12 |

## Registro de entregables y aprobaciones propuestas

Las autoridades de aprobación son roles hipotéticos propuestos para gobernar el ejercicio. No identifican personas y no implican aprobación ya obtenida. “No aplica” significa que el entregable es condicional o solo de aprendizaje.

| ID | Entregable | Descripción / estado actual | Rol responsable propuesto | Autoridad de aprobación propuesta | Fase |
| --- | --- | --- | --- | --- | --- |
| D0.1 | Límite del ejercicio | Resumen de objetivo, qué se practica y qué no se declara producto real; por elaborar. | Product Owner | Product Owner del ejercicio (rol no asignado) | 0 |
| D0.2 | Inventario de evidencia | Baseline, constitución, specs, mockups y gaps; fuentes existentes. | Business Analyst | Product Owner del ejercicio | 0 |
| D1.1 | Catálogo de requisitos trazado | BR-001, FR-001–006, SEC-001 y AC asociados; existentes, Draft. | Business Analyst | Product Owner (propuesto; no sign-off de negocio) | 1 |
| D1.2 | Registro de clarificaciones | LAB-OQ-001–010 y Q-001–025; preguntas abiertas existentes. | Business Analyst | Product Owner del ejercicio | 1 |
| D1.3 | Regla de prioridad | Prioridad/esfuerzo por feature; por definir. | Product Owner | Product Owner del ejercicio | 1 |
| D2.1 | Arquitectura overview | Propuesta existente, requiere ratificación de decisiones abiertas. | Solution Architect | Product Owner + Technical Lead (propuestos) | 2 |
| D2.2 | Modelo de dominio conceptual | Existente, Draft/LAB-HYP; límites y agregados no confirmados. | Solution Architect / Data Architect | Technical Lead (propuesto) | 2 |
| D2.3 | Elecciones arquitectónicas pendientes | API, persistencia, identidad, auth, estilo/CQRS; elegir solo las necesarias. | Solution Architect | Product Owner del ejercicio + Technical Lead | 2 |
| D3.1 | Mockups low-fi | Mockups existentes F001 y F003–F007, con README/CHANGELOG; LAB-F002 se representa en F001. | UX/UI Designer | Product Owner del ejercicio (revisión visual) | 3 |
| D3.2 | Feedback de mockups | Ajustes y gaps tras revisar pantallas; condicional. | UX/UI Designer | Product Owner del ejercicio | 3 |
| D4.1 | Entorno local | Podman y configuración de aprendizaje; por preparar/validar. | DevOps Engineer | Technical Lead (propuesto) | 4 |
| D4.2 | CI | GitHub Actions con build/lint/test/security gates constitucionales; por preparar/validar. | DevOps Engineer | Technical Lead | 4 |
| D4.3 | IaC | Terraform solo para infraestructura aprobada; no generado en esta hoja de ruta. | DevOps / Platform Engineer | Solution Architect + Technical Lead | 4 |
| D4.4 | Estrategia de promoción y entornos | Flujo entre entornos, condicionado a resolver el trigger de dev y el alcance de despliegue. | DevOps Engineer | Technical Lead (propuesto) | 4 |
| D5.1 | Foundation app | Shell Angular + backend .NET 8 y límites acordados; por implementar. | Frontend/Backend Developers | Technical Lead | 5 |
| D5.2 | Observabilidad base | OpenTelemetry hacia Azure según constitución, si el entorno se configura. | Backend Developer / DevOps Engineer | Technical Lead | 5 |
| D5.3 | Configuración local segura | Configuración de desarrollo sin secretos en el repositorio; por preparar. | Backend Developer / DevOps Engineer | Technical Lead | 5 |
| D5.4 | Health checks y trazabilidad base | Health checks del template constitucional e instrumentación inicial, cuando aplique. | Backend Developer / DevOps Engineer | Technical Lead | 5 |
| D5.5 | Pruebas de arquitectura iniciales | Pruebas estructurales para las fronteras acordadas; por implementar. | QA Engineer / Technical Lead | Technical Lead | 5 |
| D6.1 | Funcionalidad core | LAB-F001–007 según la secuencia acordada; por implementar. | Backend/Frontend Developers | Product Owner del ejercicio + Technical Lead | 6 |
| D6.2 | Trazabilidad de implementación | Relación de features/AC a pruebas y cambios; por elaborar durante desarrollo. | QA Engineer | Technical Lead | 6 |
| D6.3 | Pruebas unitarias e integración | Pruebas de los comportamientos implementados y no bloqueados por preguntas abiertas. | QA Engineer / Developers | Technical Lead | 6 |
| D6.4 | Evidencia de gates por incremento | Resultados de los controles de calidad aplicables a cada entrega. | QA Engineer / DevOps Engineer | Technical Lead | 6 |
| D7.1 | Decisión de integración | Resolver si hay sistemas externos; actualmente ninguno está evidenciado. | Solution Architect / Business Analyst | Product Owner del ejercicio | 7 |
| D7.2 | Integración y contrato | Solo si una integración se confirma; contrato no incluido aquí. | Backend Developer / Solution Architect | Product Owner + Security Engineer | 7 |
| D8.1 | Revisión de amenazas | Riesgos del flujo de propiedad/asignación y datos; por elaborar si se implementa. | Security Engineer | Technical Lead | 8 |
| D8.2 | Clasificación y privacidad | Clasificar datos y determinar aplicabilidad; no equivale a compliance report. | Security Engineer / Data Architect | Product Owner (con asesoría competente si aplica) | 8 |
| D8.3 | Evaluación de aplicabilidad y cumplimiento | Solo si se obtiene contexto verificable sobre usuarios, jurisdicción y obligaciones. | Security Engineer | Product Owner del ejercicio (con asesoría competente si aplica) | 8 |
| D9.1 | Suites de pruebas | Unitarias, integración, BDD/E2E y arquitectura conforme al stack final. | QA Engineer / Developers | Technical Lead | 9 |
| D9.2 | Evidencia de quality gates | Reportes de 80 % cobertura unitaria, 60 % mutación y cero críticos en scans. | QA Engineer / DevOps Engineer | Technical Lead | 9 |
| D9.3 | Matriz AC, Gherkin y pruebas | Trazabilidad de criterios a escenarios y pruebas ejecutadas, señalando gaps. | QA Engineer | Technical Lead | 9 |
| D9.4 | Informe de defectos y gaps | Resultados de QA, defectos y comportamientos sin especificar. | QA Engineer | Technical Lead | 9 |
| D9.5 | Evidencia de gates | Resultados de los quality gates aplicables; no implica aceptación de negocio. | QA Engineer / DevOps Engineer | Technical Lead | 9 |
| D10.1 | Revisión de aceptación simulada | Recorrido personal basado en AC; no UAT de negocio aprobada. | Product Owner / QA Engineer | Product Owner del ejercicio | 10 |
| D10.2 | Gaps y cambios propuestos | Feedback y discrepancias encontrados durante la revisión personal. | Business Analyst / QA Engineer | Product Owner del ejercicio | 10 |
| D10.3 | Actualización de baseline | Cambios documentales solo si el autor decide realizarlos y conserva su trazabilidad. | Business Analyst | Product Owner del ejercicio | 10 |
| D11.1 | Decisión de despliegue | Desplegar o no; depende de plataforma, target y autorización. | DevOps / Platform Engineer | Product Owner del ejercicio + Technical Lead | 11 |
| D11.2 | Registro de go-live | Solo si hay entorno y usuarios previstos; no hay go-live asumido. | DevOps Engineer | Product Owner del ejercicio | 11 |
| D11.3 | Evidencia del despliegue de aprendizaje | Registro del despliegue y comprobaciones posteriores, solo si se autoriza y ejecuta. | DevOps Engineer | Product Owner del ejercicio + Technical Lead | 11 |
| D12.1 | Registro hypercare | Observaciones tras despliegue, condicional a operación con usuarios. | DevOps / QA Engineer | Product Owner del ejercicio | 12 |
| D12.2 | Cierre de hypercare | Resumen de incidencias y cierre, solo si se activa esta fase. | DevOps Engineer / QA Engineer | Product Owner del ejercicio | 12 |
| D13.1 | Revisión de mejora | Aprendizajes, deuda y siguiente alcance opcional. | Scrum Master / Product Owner | Product Owner del ejercicio | 13 |
| D13.2 | Cambios priorizados | Propuestas de mejora para una iteración futura, sin comprometer su ejecución. | Product Owner / Business Analyst | Product Owner del ejercicio | 13 |
| D13.3 | Documentación actualizada | Ajustes a la documentación derivados de mejoras decididas y realizadas. | Business Analyst / Technical Lead | Product Owner del ejercicio | 13 |

## Dependencias globales y gates

- **Constitución:** todo diseño debe respetar .NET 8, Angular, Podman local, GitHub Actions, Terraform, GitHub Flow, rolling, entornos habilitados, OpenTelemetry hacia Azure y controles/gates aprobados.
- **Estado de requisitos:** ninguna fase puede describir LAB-HYP como validado por negocio. Cambios del ejercicio se mantienen como cambios de trabajo, no como aprobación de producto.
- **Decisiones antes de implementación:** concretar solo elecciones necesarias para el siguiente incremento: diseño de API y persistencia, identidad/autorización para SEC-001, y comportamiento necesario para estados que se implementen.
- **Calidad antes de aceptación simulada:** build/lint/test, unit coverage ≥80 %, mutation ≥60 %, security/container scan sin críticos y architecture tests aplicables.
- **Despliegue:** no avanzar a go-live hasta resolver el trigger `develop` frente a GitHub Flow, destino, permisos, presupuesto y controles aplicables.
- **Trabajo:** GitHub Projects es la herramienta seleccionada en la constitución. Esta hoja de ruta no crea, importa ni sincroniza items.

## Trazabilidad de fuentes

- **Constitución:** [digest](../../.boltf/memory/constitution.digest.md) y [texto canónico](../../.boltf/memory/constitution.md).
- **Baseline y clarificaciones:** [baseline LAB-HYP](../../specs/lab/requirements-baseline.md), [resumen](../../specs/clarification-summary.md).
- **Especificaciones:** requirements, UCs y Gherkin de LAB-F001–LAB-F007 bajo `specs/lab-*/`.
- **Diseño:** [modelo de estados](../../specs/lab-005-approve-vacation-request/requirements/state-model.md), [modelo de dominio](../design/ddd/vacation-management/domain-model.md), [arquitectura](../design/architecture/architecture-overview.md).
- **Mockups:** README/CHANGELOG bajo `specs/lab-001-submit-vacation-request/mockups/` y `specs/lab-003-*` a `specs/lab-007-*`.

> **Límite de esta entrega:** este archivo es una hoja de ruta general, no un plan por feature. No crea `notes.md`, `task_plan.md`, planes técnicos, contratos OpenAPI, listas de tareas, ADR, código ni work items.
