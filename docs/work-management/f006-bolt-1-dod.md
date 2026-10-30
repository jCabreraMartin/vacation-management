# Revisión final de Definition of Done: F-006, Bolt 1

**Dictamen: APTO. La DoD técnica del Bolt de laboratorio está cumplida para el SHA revisado.**
El incremento local está terminado y validado remotamente. La aprobación humana de Ready,
integración y cierre no se ejecuta en esta revisión; requiere confirmación expresa.

| Propiedad | Valor verificado |
| --- | --- |
| Fecha | 2026-10-30 |
| Bolt / Feature | [#74](https://github.com/jCabreraMartin/vacation-management/issues/74) / [#13](https://github.com/jCabreraMartin/vacation-management/issues/13) |
| PR | [#75](https://github.com/jCabreraMartin/vacation-management/pull/75), OPEN / Draft |
| SHA revisado | `12398abf5ceba67441a2973445418477ca78c2c8` |
| Rama | `bolt/rechazo-solicitudes/bolt-1-rechazo` |
| Padre del PR | `feature/vacation-management-lab-catalog`; no main |
| Integración informada por GitHub | MERGEABLE / CLEAN; no equivale a aprobación humana |
| Aprobación humana remota | No consta; permanece pendiente de confirmación |
| Estado de este documento | Informe local nuevo, sin commit ni push; no forma parte del SHA evaluado |

## Criterios técnicos del Bolt

PASS significa verificado dentro de DL-B1 y en el contenido publicado del SHA anterior. BLOCKED
separa acciones o aprobaciones pendientes; no significa que se hayan impuesto funcionalidades de
producción al laboratorio. NO APLICA identifica elementos expresamente ajenos al incremento.

| Criterio | Estado | Evidencia y límite |
| --- | --- | --- |
| Requisitos y AC-LAB-01 | PASS | Consulta y rechazo de Pendiente a Rechazada, verificados por dominio, servicio, API, componente y E2E. |
| AC-LAB-02 | PASS | Rechazo repetido devuelve conflicto; la regresión determinista coordina dos snapshots y obtiene un único éxito. También se comprueba conflicto HTTP e independencia de ids. |
| AC-LAB-03 | PASS | GET y POST de un id inexistente devuelven 404/Problem Details; UI informa sin ofrecer rechazo. |
| AC-LAB-04 | PASS | No se pide motivo ni se ofrecen alternativas; probado en componente y E2E. |
| AC-LAB-05 | PASS | Carga, rechazo en curso, éxito y errores explícitos. JSON ilegible no bloquea la UI. POST incierto exige consulta manual, sin reintento automático ni confirmación falsa. |
| UC-008 y modelo del laboratorio | PASS | Variante de laboratorio y transición aisladas del análisis del cliente; sin introducir otros estados o integraciones. |
| Gherkin y tareas | PASS | Seis escenarios trazan cinco AC; tareas del laboratorio y preparación histórica distinguidas. Validación estática de etiquetas, no ejecución BDD directa. |
| A-01: atomicidad | PASS | Snapshots de lectura y guardado condicional `TryUpdate`; pruebas coordinadas no dependientes del azar y prueba HTTP de 200/409. |
| A-02: uso local efectivo | PASS | Listeners HTTP loopback, rechazo de configuración ajena y controles de Host/Origin/cabecera; tests reales IPv4/IPv6 y E2E. Sin autenticar a otros procesos locales. |
| A-03: lectura de respuestas | PASS | Pruebas GET/POST con JSON inválido/cuerpo interrumpido; E2E con escritura real aplicada y respuesta corrompida, seguido de GET manual. |
| A-04: CI real de aplicación | PASS | Backend/frontend/E2E/resumen remoto exitosos, rutas reales, cobertura y mutación exigibles. No se usa la antigua plantilla de npm raíz como evidencia. |
| A-05: coherencia documental | PASS | Research, tasks e índice publicados separan preparación histórica y excepción DL-B1; auditoría original conservada con seguimiento. |
| Build, tipos, lint y formato | PASS | Pasos correspondientes en las CI del SHA actual concluidos en éxito. |
| Unitarias backend | PASS | 24/24 en el run de PR actual. |
| Cobertura unitaria ≥80 % | PASS | Artefacto del run actual: Domain y Application 100 % de líneas/ramas; Infrastructure 93,54 % líneas y 90 % ramas. Frontend supera los umbrales configurados de 80 % en su job actual. No se afirma cobertura unitaria de Api. |
| Mutación ≥60 % | PASS | Logs del run actual: backend 79,67 %, frontend 94,95 %. Sin rebajar umbrales ni añadir exclusiones. |
| Arquitectura | PASS | 9/9 pruebas de dependencias entre capas en el run actual. No se impone CQRS no elegido. |
| Integración API | PASS | 23/23 pruebas en CI de aplicación; suite específica del workflow de contratos 6/6. |
| E2E local fullstack | PASS | 5/5 Chromium en el run actual, incluido resultado incierto y origen ajeno. |
| Contratos aplicables | PASS | Trazabilidad de cinco AC y rutas; comportamiento API verificado con la suite existente; resumen de cambios solo informativo. |
| Gobernanza documental aplicable | PASS | 10/10 tests del validador; 12 documentos y 95 enlaces publicados comprobados, sin escrituras automáticas. |
| Todos los checks del último SHA | PASS | Cinco runs verificados, 15/15 checks SUCCESS, sin fallos, pendientes ni omitidos. |
| Fuentes y distinción laboratorio/cliente | PASS | F-006 sigue Draft; DL-B1 no aprueba al cliente; PA-06/14/26 conservan estado abierto. |
| Publicación y cambios locales separados | PASS | Delta del PR y material local ajeno identificados; los documentos compartidos completos locales no se confunden con las vistas parciales publicadas. |
| OpenAPI separado / validación de esquemas | NO APLICA | No existe una exigencia del plan para este Bolt ni esquemas configurados. Ausencia declarada, no presentada como validación superada. Un nuevo esquema requerirá validador explícito. |
| Pact, Cucumber o Reqnroll | NO APLICA | No seleccionados; no se introdujeron runners vacíos ni se cuenta Gherkin como BDD ejecutado. |
| Identidad corporativa, BD real e integraciones | NO APLICA | Fuera de DL-B1. La aplicación es local, ficticia y en memoria. |
| Terraform, despliegue y certificación de producción | NO APLICA | No ejecutados ni autorizados por este Bolt. No se afirma preparación para producción. |

## Evidencia publicada y ejecuciones del SHA actual

Se volvió a consultar GitHub durante esta revisión. Las cinco ejecuciones corresponden exactamente
a `12398abf5ceba67441a2973445418477ca78c2c8`, no a `ee772e3` ni a una propuesta local.
Todos los jobs de cada ejecución están en éxito, incluidos los resúmenes obligatorios.

| Workflow / evento | Resultado | URL |
| --- | --- | --- |
| Aplicación / push | PASS | [41052249604](https://github.com/jCabreraMartin/vacation-management/actions/runs/41052249604) |
| Aplicación / PR | PASS | [41052259371](https://github.com/jCabreraMartin/vacation-management/actions/runs/41052259371) |
| Contratos / push | PASS | [41052249662](https://github.com/jCabreraMartin/vacation-management/actions/runs/41052249662) |
| Contratos / PR | PASS | [41052259388](https://github.com/jCabreraMartin/vacation-management/actions/runs/41052259388) |
| Gobernanza / PR | PASS | [41052259379](https://github.com/jCabreraMartin/vacation-management/actions/runs/41052259379) |

La cobertura backend se comprobó descargando `backend-evidence` de la ejecución de PR actual y
leyendo su XML Cobertura. Los porcentajes de mutación, recuentos de pruebas y E2E se contrastaron
con los logs del mismo run. No se volvió a ejecutar la suite durante esta revisión ni se alteró
código para recrear el RED histórico: este permanece registrado en la auditoría y en #74.

Evidencia funcional publicada:
[requisitos](../../specs/006-rechazo-solicitudes/requirements/requirements.md),
[UC-008](../../specs/006-rechazo-solicitudes/requirements/use-cases/UC-008-rechazar-solicitud.md),
[modelo](../../specs/006-rechazo-solicitudes/requirements/state-model.md),
[Gherkin](../../specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature),
[tasks](../../specs/006-rechazo-solicitudes/planning/tasks.md),
[auditoría y seguimiento](f006-bolt-1-audit.md),
[controles heredados adaptados](legacy-checks-adaptation.md).
Las métricas y textos de fases iniciales son históricos y no sustituyen los resultados actuales.

## Qué está terminado y qué no

| Ámbito / actuación | Estado | Interpretación |
| --- | --- | --- |
| Bolt 1 local de laboratorio | PASS | Incremento terminado dentro de DL-B1 y con validación remota actual. Cierre propuesto, todavía no ejecutado. |
| Aceptación de la Feature F-006 por el cliente | BLOCKED | Continúa Draft; autoridad/semántica PA-06/14/26 pendientes. No se cierra #13 ni #42–#44. |
| Resto del producto | BLOCKED | Features y decisiones pendientes; este resultado no las aprueba ni implementa. |
| Ejecución o preparación final de infraestructura | BLOCKED | Trabajo separado, no se reevalúa ni ejecuta Terraform o Azure aquí. |
| Ready, squash merge al padre y cierre de #74 | BLOCKED | Falta confirmación expresa del usuario para esas acciones. No es un fallo técnico del Bolt. |
| Integración del padre en main | NO APLICA | No propuesta ni autorizada; el padre conserva sus 13 commits históricos previos. |
| Despliegue, seguridad integral y producción | NO APLICA | Sin despliegue ni certificación de preparación de producción; no extrapolar las pruebas locales a esos ámbitos. |

## Cambios locales fuera del PR

Permanecen excluidos y sin publicar: cambios en `.github/workflows/infra-validation.yml` y
`.gitignore` de raíz; las versiones completas locales de `specs/README.md` y
`specs/clarification-summary.md`; la copia de seguridad de constitución, roadmap, notes/task_plan,
informe global de sincronización, carpetas de F-001–F-005/F-007–F-012 y `terraform/`.
Las versiones parciales de los dos documentos compartidos sí están en el PR: no confundirlas con
el contenido más amplio del árbol de trabajo. Este informe final nuevo tampoco está publicado.

No se deben usar `git add .`, reset, checkout o pull que sobrescriban ese material al integrar o
limpiar ramas. El eventual borrado de la rama Bolt debe revisarse por separado si la rama está
activa en este árbol sucio; no se borrará automáticamente como parte de esta revisión.

## Arranque local y demostración reproducible

Usar PowerShell 7, .NET SDK 10 con runtime ASP.NET Core/.NET 8 y Node 24, entorno validado por esta
entrega. La aplicación tiene destino `net8.0`. No se necesita Docker/Podman, Azure, BD ni identidad
corporativa para esta demostración local. Las instalaciones/restauraciones descargan paquetes de
NuGet/npm; no contienen credenciales de servicios corporativos.

Para reproducir el contenido publicado sin interferir con los cambios locales, se recomienda una
copia separada en una carpeta nueva:

```powershell
git clone --single-branch --branch bolt/rechazo-solicitudes/bolt-1-rechazo https://github.com/jCabreraMartin/vacation-management.git vacation-management-demo
Set-Location vacation-management-demo
git rev-parse HEAD
```

Si la rama avanza después, comprobar el SHA antes de extrapolar este dictamen. No clonar encima
de la carpeta de trabajo actual. Los comandos siguientes parten de la raíz de la copia elegida.

### Terminal 1: backend

```powershell
dotnet --list-sdks
dotnet --list-runtimes
dotnet restore src/backend/VacationManagement.sln
dotnet run --project src/backend/src/VacationManagement.Api --no-launch-profile --urls http://localhost:5080
```

Mantener el proceso ejecutándose. No arrancar `dotnet run` desde el directorio de solución sin
indicar el proyecto API. El puerto 5080 debe estar libre; no usar `0.0.0.0` ni una IP de red.

### Terminal 2: frontend

```powershell
Set-Location src/frontend
node --version
npm ci
npm run dev -- --host localhost
```

El puerto 5173 debe estar libre. Se mantiene ese puerto porque la protección de escritura autoriza
el frontend local en 5173. Vite redirige `/api` al backend de `localhost:5080`. No se propone abrir
el servidor en la LAN ni cambiar puertos sin adecuar y probar el contrato local.

### Demostración

1. Abrir `http://localhost:5173/?id=LAB-001`.
2. Comprobar el aviso de datos ficticios y «Persona Ficticia A», fechas `2026-07-01`/`2026-07-15`,
   estado «Pendiente». No son datos de una integración corporativa.
3. Pulsar «Rechazar solicitud». Debe aparecer «Rechazada», resultado de éxito y desaparecer la acción.
4. Recargar la página: conserva «Rechazada» mientras el backend siga activo.
5. Desde otro terminal PowerShell, repetir el POST con la cabecera de laboratorio:

```powershell
$response = Invoke-WebRequest -Method Post `
  -Uri http://localhost:5080/api/vacation-requests/LAB-001/rejection `
  -Headers @{ 'X-Laboratory-Request' = '1' } -SkipHttpErrorCheck
$response.StatusCode
$response.Content
```

Se espera 409 y Problem Details de solicitud no pendiente. La cabecera no es una credencial; el
servidor rechaza escrituras sin ella o con origen ajeno. Consultar `?id=NO-EXISTE` muestra el error
de solicitud inexistente. Para repetir desde Pendiente, detener solo el backend con Ctrl+C y
arrancarlo de nuevo: **reiniciar el frontend no reinicia la memoria del backend**. No hay endpoint
de reset, persistencia real ni reintentos automáticos de rechazo.

La prueba automática del caso incierto está en el E2E publicado: el POST se aplica realmente y
la respuesta se hace ilegible; se muestra resultado desconocido y «Comprobar estado», sin otro POST.

## Propuesta de cierre e integración, no ejecutada

1. Obtener confirmación expresa para marcar #75 Ready, hacer squash merge **solo** hacia
   `feature/vacation-management-lab-catalog` y cerrar #74 como Bolt de laboratorio terminado.
2. Antes de ejecutar, volver a comprobar el último SHA y todos sus checks. Si el SHA cambia, esta
   revisión no se traslada automáticamente al nuevo commit.
3. Tras el merge confirmado, verificar SHA de integración y el estado del padre; no integrar main.
   Proponer el cierre manual de #74 con un comentario que delimite la aceptación al laboratorio.
4. Conservar #13 y #42–#44 abiertas, F-006 Draft y PA-06/14/26 pendientes. El eventual estado Done del
   elemento de #74 en Project #1 debe reflejar exclusivamente el cierre del Bolt, no de la Feature.

GitHub informa `closingIssuesReferences=[]` para el PR actual. Su base no es la rama predeterminada
main, por lo que no se debe confiar en autocierre al fusionar al padre. Los seis commits publicados
incluyen `Closes #74`; un futuro merge a main o el cuerpo generado del squash pueden conservar esas
referencias y provocar autocierre. Revisar el mensaje de squash y el futuro PR del padre para no
cerrar otras Issues por accidente. No añadir `Closes #13` ni cierres de las tareas de preparación.

Si se desea publicar este informe en Git, solicitar antes autorización para un commit documental y
su push. Después debe verificarse la CI del nuevo SHA y añadir una adenda de revisión, no atribuirle
automáticamente los checks de `12398ab`. En esta revisión no se publica documentación nueva por Git,
no se marca Ready, no se fusiona ni se cierra ninguna Issue.