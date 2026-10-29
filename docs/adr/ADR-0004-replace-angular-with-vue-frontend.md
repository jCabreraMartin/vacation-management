# ADR-0004: Sustituir Angular por Vue.js en el frontend

## Estado

Aceptada (2026-10-29). Sustituye a [ADR-0002](ADR-0002-record-angular-frontend-selection.md).

## Contexto

El asistente de inicialización seleccionó Angular sin justificación específica del proyecto
(ADR-0002). Posteriormente se incorporaron las fuentes del cliente de Gestión de Vacaciones:

- [Documento funcional de requisitos](../../origin/business-notes/Documento%20Funcional%20de%20Requisitos.html),
  apartados 5.1–5.3: propone una aplicación frontend en Vue y justifica su encaje con la
  visualización de calendarios, periodos sobresolicitados y consulta sencilla por responsables.
- [Diagrama de arquitectura](../../origin/reference-images/Arquitectura.png): representa la
  «Aplicación Web (Vue.js)».

Ninguna de las fuentes especifica versión del framework.

## Decisión

Usar Vue.js para el frontend, alineando la constitución con la propuesta de las fuentes del cliente.
La versión principal no se fija en este ADR y debe confirmarse antes de generar la estructura del
frontend o instalar dependencias.

## Justificación

- La propuesta del cliente es la única evidencia de proyecto disponible sobre el framework; la
  selección de Angular no tenía justificación propia.
- Todavía no existe código frontend (`src/frontend/` vacío), por lo que el cambio no implica
  reescritura.

## Alternativas consideradas

- **Mantener Angular:** coherente con la inicialización, pero contradice la propuesta del cliente
  sin un motivo documentado.
- **React:** no aparece en las fuentes; no se evaluó.

## Consecuencias

- La constitución (`.boltf/memory/constitution.md`, su digest y los estados de refinamiento),
  `.boltf/scopes.yaml` y la tarjeta de ámbito de `.github/copilot-instructions.md` pasan a declarar Vue.js.
- Las skills de Vue disponibles en el entorno de Copilot (`vue-best-practices`, `vue-pinia-best-practices`,
  `vue-router-best-practices`, `vue-testing-best-practices`) sustituyen a `angular-primeng-frontend`
  como referencia. En el repositorio, `.boltf/available-skills/vue/` solo contiene un README; su
  aprovisionamiento es una acción independiente.
- Los artefactos archivados en la etiqueta `lab-hyp-v1` mencionan Angular; no se modifican.
- Herramientas de pruebas, gestión de estado, enrutado y librería de componentes siguen sin decidir.
