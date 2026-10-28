# Mockups: Aprobar una solicitud de vacaciones

**Feature:** LAB-F005 · **Historia:** US-LAB-F005-01 · **Caso de uso:** UC-005  
**Modo:** `generate` · **Fecha:** 2026-10-27

## Flujo y pantallas

| Flujo | Paso | Estados | Pantalla |
| --- | --- | --- | --- |
| `aprobar-solicitud` | `accion` | default | [Solicitud pendiente](approve-request-action-default.html) |
| `aprobar-solicitud` | `accion` | loading | [Acción en curso](approve-request-action-loading.html) |
| `aprobar-solicitud` | `accion` | error | [Error de aprobación](approve-request-action-error.html) |
| `aprobar-solicitud` | `accion` | success | [Aprobación registrada](approve-request-action-success.html) |

## Asunciones y pendientes

- El actor es el Responsable aprobador; la solicitud está Pendiente, asignada y el actor está autorizado conforme al flujo descrito.
- El detalle solo ilustra las fechas y el comentario opcional de la solicitud; los valores son placeholders.
- No se añade confirmación previa, comentario obligatorio, reversión ni notificación externa.
- El error representa solicitud no pendiente, actor no autorizado o solicitud no encontrada. El texto y el tratamiento visual exactos quedan pendientes en `TODO(content)`.
- La confirmación visual muestra el estado `Aprobada`; el texto exacto dirigido al responsable sigue abierto.

## Apertura

Abre los HTML directamente en un navegador; Tailwind CSS v4 se carga mediante CDN.
