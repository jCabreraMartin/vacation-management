# Mockups F-006: Rechazo de solicitudes

**Estado:** prototipo visual Draft para conversación; no define UX aprobada ni transición de estado.

## Flujos

| Flujo | Historia / interacción | Estados | Recorrido visual |
| --- | --- | --- | --- |
| `solicitud-rechazar` | US-001: el responsable rechaza una solicitud | `default`, `loading`, `error`, `success` | Revisar solicitud genérica → rechazar → confirmar resultado por definir. |

Abre los HTML directamente en un navegador con conexión al CDN de Tailwind CSS v4. También se puede ejecutar `python -m http.server` desde la raíz del repositorio.

## Suposiciones y límites

- «Responsable» y acción de rechazar aparecen en la historia; rol autorizado, ámbito y estado elegible siguen `Por confirmar`.
- No se añaden campos de motivo, acciones de cierre, reversión o fechas alternativas. El resultado/copy de éxito no se ha aprobado.
- Error y carga son placeholders visuales; no definen comportamiento ni recuperación.
- El bloque de solicitud no define datos/columnas; neutral, sin datos de ejemplo.

## Estados omitidos

- `empty`: se representa el punto de revisión de una solicitud identificada, no una colección; selección y listado quedan por confirmar.
- `no-permissions` y `read-only`: no hay política de autorización.
- Ningún estado formal `Rechazada` se propone. Las dudas sobre «valorar/cerrar» permanecen abiertas.

PA-06, PA-14 y PA-26 siguen abiertas. US-001, UC-008 y el modelo de estados permanecen Draft.
