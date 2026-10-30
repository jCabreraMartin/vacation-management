# Auditoría del Bolt 1 de F-006: rechazo de solicitudes

**Dictamen: requiere correcciones antes de cerrar #74.** Los gates locales reproducidos pasan, pero
no cubren los defectos de atomicidad y recuperación de la interfaz descritos a continuación.

Fecha: 2026-10-30. Paso 16.3 del laboratorio. [Bolt #74](https://github.com/jCabreraMartin/vacation-management/issues/74),
[Feature #13](https://github.com/jCabreraMartin/vacation-management/issues/13).
Rama revisada: `bolt/rechazo-solicitudes/bolt-1-rechazo`, con trabajo sin confirmar.
Se revisaron los archivos actuales, incluidos los cambios recientes de configuración y cliente frontend.

## Hallazgos y correcciones necesarias

### A-01 · P1 · Dos rechazos simultáneos pueden confirmar éxito

Evidencia: [VacationRequest.Reject](../../src/backend/src/VacationManagement.Domain/VacationRequest.cs#L28),
[VacationRequestService.RejectAsync](../../src/backend/src/VacationManagement.Application/VacationRequestService.cs#L25)
y [repositorio en memoria](../../src/backend/src/VacationManagement.Infrastructure/InMemoryVacationRequestRepository.cs#L23).

El dominio comprueba `Status != Pending` y después asigna `Rejected`, sin una operación atómica.
El repositorio devuelve la misma instancia mutable a ambos llamadores. `ConcurrentDictionary`
protege las operaciones de la colección, no la comprobación y modificación de esa instancia.
La secuencia consultar/rechazar/guardar del servicio tampoco está sincronizada.

**Reproducción:** sonda C# compilada únicamente en memoria, con dos hilos y una barrera de inicio y
fin por ronda. Cada ronda usa un repositorio real nuevo con la semilla y el servicio real. En
100.000 rondas hubo **8.017 con dos resultados `Success`**, sin excepciones inesperadas. El estado
final siempre fue `Rejected`; no se observó pérdida del estado. La sonda cargó los ensamblados
`net8.0` en el host .NET 10 de PowerShell; no fue un estrés HTTP de Kestrel. El
[mapeo HTTP](../../src/backend/src/VacationManagement.Api/VacationRequestEndpoints.cs#L23) convierte
ambos éxitos en 200.

Incumple la regla DL-B1-03/AC-LAB-02 de que el segundo rechazo debe producir error, también cuando
las peticiones se solapan. Puede suceder localmente con dos pestañas; no requiere infraestructura
distribuida ni base de datos real.

**Antes del cierre:** hacer atómica la transición dentro del almacenamiento local compartido y
añadir una prueba de concurrencia que exija exactamente un éxito y un conflicto para el mismo id.
Conservar la independencia de solicitudes distintas. No se prescribe una nueva tecnología.

### A-02 · P1 · El límite «exclusivamente local» no se impone

Evidencia: [Program.cs](../../src/backend/src/VacationManagement.Api/Program.cs#L5) usa la configuración
normal del host y [app.Run](../../src/backend/src/VacationManagement.Api/Program.cs#L17), sin validar
direcciones de escucha o solicitudes procedentes de orígenes ajenos. El límite autorizado consta en
la [arquitectura](../design/architecture/architecture-overview.md#L145).

La escucha predeterminada en localhost no evita que una configuración `--urls` o `ASPNETCORE_URLS`
abra la API sin autenticación en otra interfaz. No se ha probado ni abierto una escucha en la LAN.
Tampoco basta un aviso visual o el nombre del entorno para imponer ese límite.

**Reproducción acotada:** el backend arranca en `Production` sobre `127.0.0.1` y acepta un POST de
rechazo con `Origin: https://audit.invalid` y tipo `application/x-www-form-urlencoded`: responde
**200 / Rejected**. La prueba usa un cliente HTTP y demuestra aceptación en el servidor; no demuestra
una explotación universal desde un navegador, cuyas políticas de red pueden variar. CORS por sí
solo no garantiza que una operación simple de escritura no se ejecute.

**Antes del cierre:** acotar efectivamente el arranque a loopback y proteger la escritura frente a
solicitudes de orígenes ajenos con una medida compatible con el frontend local; probar ambos límites.
No se exige autenticación corporativa, roles ni una identidad real. Su ausencia está autorizada;
el problema es que el límite que permite prescindir de ella es solo documental.

### A-03 · P2 · Fallar al leer el JSON deja bloqueada la interfaz

Evidencia: el [cliente HTTP](../../src/frontend/src/api/vacationRequests.ts#L22) captura el fallo inicial
de `fetch`, pero las lecturas `response.json()` de
[GET](../../src/frontend/src/api/vacationRequests.ts#L33) y
[POST](../../src/frontend/src/api/vacationRequests.ts#L42) quedan fuera de ese control.
La vista desactiva los indicadores solo después de los `await` de
[carga](../../src/frontend/src/components/VacationRequestReview.vue#L28) y
[rechazo](../../src/frontend/src/components/VacationRequestReview.vue#L39), sin una salida para ese fallo.

**Reproducción:** Chromium contra un servidor Vite efímero en loopback, interceptando únicamente la
respuesta API e inyectando 200 con JSON inválido; sin modificar archivos de la aplicación.

| Respuesta alterada | Resultado observado |
| --- | --- |
| GET | `SyntaxError` no controlado; permanece «Cargando solicitud…» y no aparece alerta. |
| POST, tras un GET válido | `SyntaxError` no controlado; permanece «Rechazando…», botón deshabilitado y ninguna alerta. |

La API actual emite JSON válido en el recorrido normal; la sonda prueba una respuesta defectuosa o
truncada, no añade un nuevo resultado de negocio. Es una laguna de AC-LAB-05 y del flujo E-LAB-3 de
[UC-008](../../specs/006-rechazo-solicitudes/requirements/use-cases/UC-008-rechazar-solicitud.md).

**Antes del cierre:** convertir los errores de lectura de la respuesta en un resultado controlado,
asegurar la salida de los estados transitorios y cubrir consulta y rechazo con pruebas. Ante fallo
después de una escritura no debe darse por confirmado que el servidor no la realizó.

### A-04 · P2 · La CI actual no valida este incremento fullstack

Evidencia: [ci.yml](../../.github/workflows/ci.yml#L119) configura Node y ejecuta `npm ci` desde la raíz,
sin `working-directory` del frontend ni `cache-dependency-path` de su lockfile. En esa raíz **no
existen** `package.json` ni `package-lock.json`; están bajo `src/frontend`. El workflow no contiene
`dotnet build`/`dotnet test` ni los gates de mutación del Bolt. La cobertura heredada solo genera un
[aviso](../../.github/workflows/ci.yml#L269) por debajo del umbral.

Es una inspección estática, no el resultado de una ejecución remota: no se lanzó GitHub Actions ni
se hizo push. No debe describirse esta CI como una validación correcta del frontend o como una mera
omisión de backend: sus rutas actuales impiden validar el nuevo frontend también.

La [constitución](../../.boltf/memory/constitution.digest.md#L11) selecciona GitHub Actions y fases de
pipeline; los gates locales no equivalen a esos controles automatizados.

**Antes del cierre:** adaptar la CI al árbol real y a los gates acordados, o registrar una excepción
explícita de cierre exclusivamente local del laboratorio. No existe aquí una exención aprobada que
permita llamar a CI «superada». Se conserva #74 abierta; preparar o ejecutar CI requerirá el alcance
y las autorizaciones posteriores que correspondan, sin contradecir la prohibición actual de push.

### A-05 · P2 · La preparación histórica no está separada de forma uniforme

Evidencia: [research](../../specs/006-rechazo-solicitudes/planning/research.md#L24) sigue concluyendo
`BLOCKED` y que no se generan Issues, contratos o decisiones técnicas, sin una sección de excepción
del laboratorio. El [índice](../../specs/README.md#L18) afirma que no hay escenarios `.feature`, y las
secciones iniciales de [tasks](../../specs/006-rechazo-solicitudes/planning/tasks.md#L15) dicen que no
hay Gherkin ni tareas de implementación.

El [plan](../../specs/006-rechazo-solicitudes/planning/plan.md#L48), requisitos, UC, modelo y sección
posterior de tasks sí distinguen la excepción de laboratorio. No se considera contradicción que la
Feature permanezca Draft ni que PA-06/14/26 sigan abiertas ante el cliente.

**Antes del cierre:** marcar expresamente los bloques anteriores como preparación histórica o
estado del alcance del cliente, añadir la excepción pertinente en research y corregir las
afirmaciones generales del índice. Mantener las fuentes originales, los estados Draft y las PA
abiertas. No reescribir los requisitos como si el cliente hubiera aprobado el laboratorio.

## Cobertura de criterios, arquitectura y alcance

| Criterio | Evidencia actual | Conclusión |
| --- | --- | --- |
| AC-LAB-01 | Dominio, servicio, integración API y E2E de rechazo. [Gherkin](../../specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature#L16). | Cubierto en ejecución secuencial. |
| AC-LAB-02 | Pruebas de rechazo repetido en dominio, [servicio](../../src/backend/tests/VacationManagement.UnitTests/Application/VacationRequestServiceTests.cs#L48) y [API](../../src/backend/tests/VacationManagement.IntegrationTests/VacationRequestEndpointsTests.cs#L61). | Se comprueba conflicto, conservación del estado y un solo guardado secuencial. Falta concurrencia: A-01. |
| AC-LAB-03 | GET/POST inexistentes en servicio e integración; cliente y UI; E2E de id inexistente. | Cubierto. |
| AC-LAB-04 | Vue no solicita motivo ni alternativas; pruebas de componente y E2E. | Cubierto. |
| AC-LAB-05 | Carga, rechazo en curso, éxito, 404/409, 500/red en cliente y componente; dos E2E. | Cubierto en casos existentes, incompleto ante lectura defectuosa: A-03. |

Los seis escenarios Gherkin trazan los cinco AC. No hay un runner BDD ejecutándolos: xUnit, Vitest
y Playwright verifican comportamientos asociados. Esto está documentado y no se exige introducir
Reqnroll por plantilla.

Domain no depende de infraestructura/API; Application usa un puerto; Infrastructure implementa ese
puerto; Api compone las dependencias. Se reprodujeron nueve pruebas de arquitectura, incluido un
control positivo. No se exige CQRS ni un patrón no seleccionado en las decisiones vinculantes.

El contrato disponible consta en la [arquitectura](../design/architecture/architecture-overview.md#L150),
los endpoints, el DTO y las pruebas: GET por id y POST al recurso de rechazo, 200 con solicitud,
404/409 con Problem Details y manejo de 500 sin detalles internos. La UI traduce `Pending`/`Rejected`
a las etiquetas españolas acordadas. Los datos se identifican como ficticios y el almacenamiento
es local al proceso.

**La falta de un contrato API separado no incumple la planificación vigente.** El
[plan](../../specs/006-rechazo-solicitudes/planning/plan.md#L40) dice «contratos solo si decisiones
posteriores los requieren»; DL-B1-07 no impone OpenAPI. Separar y completar ese contrato sería útil,
pero no una corrección obligatoria para este alcance.

No se implementaron listado, alta, aprobación, cancelación, notificaciones, motivo, reversión,
integración corporativa ni base de datos. No se han detectado ampliaciones funcionales de esas
Features. La ausencia de identidad, persistencia real y contenedores en este incremento local está
autorizada; no se presenta como un defecto de producción.

## Gates reproducidos en esta auditoría

Entorno: Windows, SDK .NET 10.0.401 y runtime 8.0.33 para `net8.0`; Node 24.19.0. Se usaron las
dependencias instaladas, sin instalar herramientas nuevas ni cambiar versiones o exclusiones.

| Gate | Resultado reproducido | Alcance / límite |
| --- | --- | --- |
| Backend build | PASS | Solución completa, sin errores; avisos tratados como errores. |
| Backend formato | PASS | `dotnet format --no-restore --verify-no-changes`. |
| Backend pruebas | 36/36 PASS | 21 unitarias, 9 arquitectura, 6 integración. |
| Backend cobertura unitaria | 100 % líneas y ramas | Domain/Application/Infrastructure, no una afirmación de cobertura unitaria del ensamblado Api. |
| Api cobertura de integración | 96,67 % líneas, 75 % ramas | Informe nuevo de integración; la cifra histórica 96,8 % no se reutiliza como medición actual. |
| Stryker.NET 5.0.0 | 81,82 %, PASS ≥60 % | 36 eliminados, 7 supervivientes y 1 sin cobertura; 11 ignorados por el filtro automático del runner. |
| Frontend tipos, ESLint, Prettier y build | PASS | Archivos actuales; checks sin opción de reescritura. |
| Frontend Vitest | 24/24 PASS | 3 archivos de pruebas. |
| Frontend cobertura | 100 % | 52/52 líneas, 39/39 ramas, 7/7 funciones, 53/53 sentencias; bootstrap fuera de la métrica configurada. |
| Stryker JS 10.1.1 | 98,75 %, PASS ≥60 % | 79 eliminados y 1 superviviente. |
| Playwright Chromium | 2/2 PASS | API local real; los servidores de prueba terminan al acabar. |
| Sondas de defectos | A-01/A-02/A-03 reproducidos | No forman parte aún de la suite del repositorio. Sus fallos no invalidan los porcentajes, pero sí la suficiencia de los casos cubiertos. |

Los supervivientes backend nuevos son cinco cambios de `ConfigureAwait(false)` a `true` y dos
eliminaciones de guardas; queda un mutante de mensaje sin cobertura en el brazo de resultado no
producido por el servicio. El superviviente frontend elimina el retorno explícito de `undefined`
en `catch`, conservando ese retorno implícito. No se ha excluido código adicional para superar gates.
Superar los umbrales no demuestra ausencia de carreras ni cobertura de fallos no probados.

### Comandos de reproducción de los gates

Desde la raíz del repositorio, con dependencias ya disponibles:

```powershell
dotnet build src/backend/VacationManagement.sln --no-restore
dotnet format src/backend/VacationManagement.sln --no-restore --verify-no-changes
dotnet test src/backend/VacationManagement.sln --no-restore --no-build --collect:'XPlat Code Coverage'
Push-Location src/backend
dotnet tool run dotnet-stryker --output (Join-Path $env:TEMP 'vm-audit-mutation')
Pop-Location
Push-Location src/frontend
npm run typecheck
npm run lint
npm run format:check
npm run build
npm run test:coverage
npm run test:mutation
npm run test:e2e
Pop-Location
```

Evidencias backend de esta ejecución en `%TEMP%/vm-audit-163-d5f8fdb3-63b6-4e64-bbdc-3c00c363fb02`
(TRX y Cobertura) y `%TEMP%/vm-audit-mut-dc1959b9-4ff7-4a69-b513-2b8b1469c858/reports`
(mutación). Informes frontend bajo los directorios ignorados `coverage`, `reports/mutation` y
`playwright-report` dentro de `src/frontend`. Las sondas puntuales permanecen en el registro de la
sesión; no se añadieron tests ni herramientas al código del Bolt.

## Evidencias históricas y validaciones no reproducidas

El cuerpo de #74 se leyó completo; tenía **cero comentarios** al comenzar. Su evidencia RED histórica
describe tipos/importaciones ausentes y cinco pruebas de API que fallaron sin endpoints. La sesión
de construcción recoge esos fallos y los GREEN posteriores. No se revirtió código ni se recrearon
snapshots para repetir ese RED durante la auditoría. Los fallos de compilación demuestran ausencia
inicial de tipos, no por sí solos un fallo de regla de negocio; el RED de API sí fue conductual.
Los E2E se añadieron al final, no fueron desarrollados con RED previo.

No se ejecutaron CI remota, SAST ni análisis de contenedores. El `npm audit=0` anterior consta como
evidencia histórica y no se volvió a consultar al registro durante esta auditoría. No se afirman
seguridad exhaustiva, aprobación del cliente ni preparación para producción.

## Mejoras opcionales, no bloqueantes por sí mismas

- Contrato OpenAPI separado y validación de esquema, cuando exista otro consumidor o se amplíe el contrato.
- Runner BDD para ejecutar directamente los escenarios Gherkin; hoy existe trazabilidad por pruebas.
- Fijación del SDK/herramientas para facilitar repetición entre máquinas; `net8.0` sí está fijado.

No se propone introducir autenticación corporativa, persistencia real, otros estados ni integraciones
para resolver las correcciones de este Bolt.

## Resultado y seguimiento

Corregir A-01, A-02 y A-03 con pruebas de regresión; reconciliar A-05; resolver A-04 mediante CI
adecuada o una excepción de cierre local explícita. Repetir los gates afectados y revisar la evidencia
antes de cerrar #74. Las decisiones del laboratorio no cierran PA-06/PA-14/PA-26 ni aprueban F-006.

Esta auditoría no corrige código, no inicia otro Bolt y no cambia ramas. Solo crea este informe y
publica el resultado en #74. Se mantienen abiertas #74, #13 y #42–#44. Sin Terraform, operaciones
Azure, despliegues, commits ni push. La revisión de los hallazgos corresponde al siguiente diálogo
con el usuario, no a una corrección automática.

## Seguimiento de correcciones A-01…A-05 (2026-10-30)

El usuario autorizó corregir estos cinco hallazgos del mismo Bolt #74. La auditoría anterior se
conserva íntegra como registro: su dictamen, métricas y referencias de línea corresponden al estado
anterior. Este seguimiento no es aprobación del cliente ni cierre de la Issue. F-006 sigue Draft y
PA-06/14/26 siguen abiertas. Se conserva DL-B1 y no se inicia otro Bolt.

### Cambios y pruebas RED → GREEN

| Hallazgo | RED registrado antes de corregir | Corrección y GREEN |
| --- | --- | --- |
| A-01 | Dos fallos deterministas: la lectura modificaba el objeto almacenado sin guardar y dos snapshots coordinados confirmaban `Success`. | El repositorio devuelve copias y usa `TryUpdate` condicional por entrada; el servicio captura también el conflicto al guardar. 10/10 tests del repositorio. La barrera de las pruebas fuerza ambas lecturas antes de guardar, sin estrés dependiente del azar; otro id puede avanzar mientras el primero espera. Integración HTTP exige un 200 y un 409. |
| A-02 | 10 fallos backend: se aceptaban listeners no loopback, Host ajeno y escrituras de orígenes ajenos; faltaba la cabecera en el test del cliente. | Listeners explícitos loopback y rechazo de configuración Kestrel alternativa; validación de Host y protección de escrituras por Origin/cabecera. 16 tests de acceso local, incluidos listeners IPv4/IPv6 reales y ausencia de cabecera; E2E local operativo y origen ajeno bloqueado con 403. No se abrió la LAN ni se añadió autenticación corporativa. |
| A-03 | Siete fallos: cuatro lecturas GET/POST con JSON inválido o cuerpo interrumpido y tres aserciones de recuperación de resultado desconocido. | Lectura de respuestas controlada; los estados transitorios se liberan con `finally`. Un POST no confirmado no muestra éxito ni invita a repetir: solo ofrece «Comprobar estado». Se valida la recuperación tanto a Pendiente como a Rechazada sin otro POST. El E2E aplica la escritura real y corrompe solo la respuesta, antes del GET manual. |
| A-04 | Tests estructurales detectaron las rutas y gates ausentes; se detectó además el operador incorrecto del resumen PowerShell antes de corregirlo. | Workflow de aplicación con jobs backend/frontend/E2E, permisos de lectura, paths y lockfile correctos; cobertura y mutación obligatorias y resumen que rechaza estados distintos de éxito. Cuatro tests estructurales/documentales, seis pruebas del gate de cobertura y actionlint PASS. No se ejecutó remotamente. |
| A-05 | Una regresión documental falló al no distinguir preparación histórica y excepción del laboratorio. | Research, tasks e índice separan ambos alcances y enlazan el Gherkin del laboratorio; requisitos, UC y arquitectura reflejan seguridad local y resultado incierto. Regresión documental en GREEN; estados del cliente conservados. |

El aislamiento de lectura y la comparación condicional están en
[InMemoryVacationRequestRepository](../../src/backend/src/VacationManagement.Infrastructure/InMemoryVacationRequestRepository.cs).
Las pruebas coordinadas se integran en
[InMemoryVacationRequestRepositoryTests](../../src/backend/tests/VacationManagement.UnitTests/Infrastructure/InMemoryVacationRequestRepositoryTests.cs);
la comprobación HTTP está en
[VacationRequestEndpointsTests](../../src/backend/tests/VacationManagement.IntegrationTests/VacationRequestEndpointsTests.cs).
No se introdujo un bloqueo global ni serialización de solicitudes distintas.

[LocalOnlyAccess](../../src/backend/src/VacationManagement.Api/LocalOnlyAccess.cs) acepta `--urls` HTTP
loopback, por defecto `http://localhost:5080`; rechaza comodines, interfaces ajenas y endpoints
Kestrel alternativos. El POST requiere `X-Laboratory-Request: 1`. Si existe `Origin`, debe coincidir
con el backend o el frontend local de puerto 5173 en localhost/127.0.0.1/::1. La cabecera no es un
secreto ni una credencial; no se habilita CORS. Las peticiones de clientes locales sin Origin deben
enviar igualmente la cabecera. La restricción no es autenticación frente a otro proceso local.

El [cliente](../../src/frontend/src/api/vacationRequests.ts) transforma errores de lectura en un
resultado controlado. La [vista](../../src/frontend/src/components/VacationRequestReview.vue) conserva
el resultado como desconocido hasta una consulta manual; no reintenta la escritura automáticamente.
Las reproducciones del navegador son ahora tests de
[Playwright](../../src/frontend/e2e/rechazo-solicitud.spec.ts), no sondas externas a la suite.

### Validación final reproducida del código corregido

| Gate | Resultado local final |
| --- | --- |
| Backend build y formato/analizadores | PASS; solución completa y `dotnet format --verify-no-changes`. |
| Backend unitarias | 24/24 PASS. |
| Backend arquitectura | 9/9 PASS. |
| Backend integración | 23/23 PASS, incluyendo concurrencia HTTP y protección local. |
| Cobertura unitaria backend | Domain/Application 100 % líneas/ramas; Infrastructure 93,54 % líneas y 90 % ramas. Gate de líneas ≥80 % PASS. |
| Stryker.NET | 79,67 % ≥60 %; 98 eliminados, 20 supervivientes, 5 sin cobertura y 2 no compilables; sin timeouts ni errores en tests ejecutados. |
| Frontend tipos, ESLint, Prettier y build | PASS. |
| Frontend Vitest y cobertura | 30/30 PASS; líneas 63/63, ramas 42/42, funciones 7/7 y sentencias 64/64: 100 %. |
| Stryker JS | 94,95 % ≥60 %; 94 eliminados y 5 supervivientes, sin timeouts. |
| Playwright Chromium | 5/5 PASS contra los procesos locales; sin reintentos. |
| Gate de cobertura y regresiones CI/documentales | 6/6 casos del gate y 4/4 tests Node PASS. Falla por cobertura 79 %, informe ausente, datos no numéricos o capa ausente; acepta el límite 80 %. |
| Inspección del workflow | actionlint 1.7.12 PASS para YAML/Actions; scripts PowerShell del gate analizados y ejecutados localmente. |
| GitHub Actions remoto | NO EJECUTADO; no se declara superado. |

No se rebajaron umbrales ni se añadieron exclusiones de código. Los supervivientes y los mutantes
no compilables permanecen en los informes; superar el umbral no implica matarlos todos. La métrica
unitaria backend mide Domain/Application/Infrastructure como antes, no se presenta como cobertura
unitaria del ensamblado Api. No se ha obtenido una nueva cifra de cobertura de Api en este seguimiento.

El [workflow](../../.github/workflows/ci.yml) reemplaza la plantilla genérica de aplicación que usaba
npm desde raíz. Instala SDK .NET 8/10 para ejecutar el stack y herramientas ya elegidos, y Node 24;
usa los directorios reales, sin `continue-on-error` ni scripts opcionales. El
[gate backend](../../.github/scripts/Assert-BackendCoverage.ps1) exige informes válidos y las tres
capas medidas. La configuración de mutación sigue cortando en 60 % y Vitest mantiene sus umbrales.
No contiene autenticación Azure, despliegues ni decisiones sobre triggers de entornos. No se
certifican los otros workflows heredados ni SAST mediante esta validación.

Evidencia final backend bajo
`%TEMP%/vm-f006-final-0459e808-d2f8-4366-8ca2-2b6db0226979`: `unit`, `tests` (TRX) y
`mutation-final/reports`. Un intento interrumpido de mutación queda separado como incompleto y no
se usa para el dictamen. Frontend conserva sus reportes ignorados bajo `coverage`,
`reports/mutation` y `playwright-report`. Se usaron Windows, SDK 10.0.401/runtime 8.0.33 y Node 24.

### Estado de entrega del seguimiento

A-01…A-05 quedan corregidos y validados localmente, pendientes de revisión con el usuario; A-04
incluye preparación e inspección del workflow, no evidencia de una ejecución remota. La auditoría
original no se sustituye por una supuesta aprobación automática. #74, #13 y #42–#44 se mantienen
abiertas. No se ejecutaron Terraform, operaciones Azure, despliegues, commits ni push.