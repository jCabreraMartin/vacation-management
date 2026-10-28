# Mockups: Consultar solicitudes pendientes asignadas

**Feature:** LAB-F004 · **Historia:** US-LAB-F004-01 · **Caso de uso:** UC-004  
**Modo:** `generate` · **Fecha:** 2026-10-27

## Flujos y pantallas

| Flujo | Paso | Estados | Pantalla |
| --- | --- | --- | --- |
| `pendientes-asignadas` | `bandeja` | default | [Bandeja](assigned-pending-inbox-default.html) |
| `pendientes-asignadas` | `bandeja` | empty | [Bandeja sin elementos](assigned-pending-inbox-empty.html) |
| `pendientes-asignadas` | `bandeja` | loading | [Consulta en curso](assigned-pending-inbox-loading.html) |
| `pendientes-asignadas` | `bandeja` | error | [Error de consulta](assigned-pending-inbox-error.html) |
| `pendientes-asignadas` | `detalle` | default | [Detalle para revisar](assigned-request-detail-default.html) |
| `pendientes-asignadas` | `detalle` | error | [Denegación fuera del ámbito](assigned-request-detail-error.html) |

## Asunciones y pendientes

- La bandeja solo representa solicitudes `Pendiente`; el elemento mostrado es ilustrativo.
- No se añaden nombres, identificadores, fechas ni otros campos al resumen/detalle porque UC-004 no define qué datos mostrar.
- No se inventan asignaciones, cardinalidad, sustituciones, orden, filtros ni búsquedas.
- La pantalla empty no distingue entre falta de asignaciones y ausencia de pendientes; esa diferencia y el contenido quedan pendientes.
- El error de detalle no muestra datos ni confirma existencia de una solicitud fuera del ámbito autorizado.
- Mensajes, recuperación y comportamiento ante consulta fallida siguen pendientes (`TODO(content)`).

## Apertura

Abre los HTML directamente en un navegador; Tailwind CSS v4 se carga mediante CDN.
