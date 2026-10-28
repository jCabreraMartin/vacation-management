# Mockups: Retirar una solicitud de vacaciones pendiente

**Feature:** LAB-F007 · **Historia:** US-LAB-F007-01 · **Caso de uso:** UC-007  
**Modo:** `generate` · **Fecha:** 2026-10-27

## Flujo y pantallas

| Flujo | Paso | Estados | Pantalla |
| --- | --- | --- | --- |
| `retirar-solicitud-propia` | `detalle-accion` | default | [Solicitud propia pendiente](withdraw-request-action-default.html) |
| `retirar-solicitud-propia` | `detalle-accion` | loading | [Retirada en curso](withdraw-request-action-loading.html) |
| `retirar-solicitud-propia` | `detalle-accion` | error | [Error de retirada](withdraw-request-action-error.html) |
| `retirar-solicitud-propia` | `detalle-accion` | success | [Estado Retirada](withdraw-request-action-success.html) |

## Asunciones y pendientes

- La vista inicial presenta una solicitud propia con estado `Pendiente`; los datos de fechas/comentario son placeholders ilustrativos.
- No se muestra un diálogo de confirmación; esa necesidad sigue abierta.
- El error no distingue visualmente entre solicitud ajena y solicitud que ya no está pendiente, y no expone datos del recurso.
- El texto exacto de error, progreso y confirmación está pendiente (`TODO(content)`).
- No se representa el resultado de una revisión en curso como un estado distinto: su semántica permanece abierta.

## Apertura

Abre los HTML directamente en un navegador; Tailwind CSS v4 se carga mediante CDN.
