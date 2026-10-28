# Mockups: Rechazar una solicitud de vacaciones

**Feature:** LAB-F006 · **Historia:** US-LAB-F006-01 · **Caso de uso:** UC-006  
**Modo:** `generate` · **Fecha:** 2026-10-27

## Flujo y pantallas

| Flujo | Paso | Estados | Pantalla |
| --- | --- | --- | --- |
| `rechazar-solicitud` | `accion` | default | [Solicitud pendiente](reject-request-action-default.html) |
| `rechazar-solicitud` | `accion` | loading | [Acción en curso](reject-request-action-loading.html) |
| `rechazar-solicitud` | `accion` | error | [Error de rechazo](reject-request-action-error.html) |
| `rechazar-solicitud` | `accion` | success | [Rechazo registrado](reject-request-action-success.html) |

## Asunciones y pendientes

- La solicitud mostrada está `Pendiente`, asignada al responsable y este está autorizado para decidirla.
- No se incluye un campo de motivo/comentario de decisión: su obligatoriedad y contenido no están resueltos.
- No se añaden confirmación previa, reversión ni notificación al empleado.
- El error representa solicitud no pendiente, responsable no autorizado o solicitud no encontrada. El texto exacto queda como placeholder `TODO(content)`.
- El success muestra `Rechazada`; el texto exacto de confirmación al responsable sigue pendiente.

## Apertura

Abre los HTML directamente en un navegador; Tailwind CSS v4 se carga mediante CDN.
