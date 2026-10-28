# Mockups: Consultar solicitudes propias de vacaciones

**Feature:** LAB-F003 · **Historia:** US-LAB-F003-01 · **Caso de uso:** UC-003  
**Modo:** `generate` · **Fecha:** 2026-10-27

## Flujos y pantallas

| Flujo | Paso | Estados | Pantalla |
| --- | --- | --- | --- |
| `consultar-solicitudes-propias` | `lista` | default | [Lista](own-requests-list-default.html) |
| `consultar-solicitudes-propias` | `lista` | empty | [Lista vacía](own-requests-list-empty.html) |
| `consultar-solicitudes-propias` | `lista` | loading | [Consulta en curso](own-requests-list-loading.html) |
| `consultar-solicitudes-propias` | `lista` | error | [Error de consulta](own-requests-list-error.html) |
| `consultar-solicitudes-propias` | `detalle` | default | [Detalle propio](own-request-detail-default.html) |
| `consultar-solicitudes-propias` | `detalle` | error | [Denegación de solicitud ajena](own-request-detail-error.html) |

## Asunciones y pendientes

- La lista no tiene columnas, filtros, búsqueda ni orden predefinido.
- En el detalle solo se ilustran fechas inicial/final, comentario opcional y estado, que aparecen en los artefactos fuente. Los valores visibles son placeholders ilustrativos.
- El acceso denegado no revela datos ni confirma la existencia de una solicitud ajena.
- Los textos exactos para estado vacío, fallo de consulta y denegación siguen pendientes; se marcan con `TODO(content)` en los HTML.
- No se añaden acciones de modificar, retirar ni decidir desde este flujo de consulta.

## Apertura

Abre los HTML directamente en un navegador; Tailwind CSS v4 se carga mediante CDN.
