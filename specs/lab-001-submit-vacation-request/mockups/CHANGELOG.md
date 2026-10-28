# Changelog de mockups

## 2026-10-27 — generate

- Generadas las vistas estáticas para `LAB-F001`, flujo `presentar-solicitud`, paso `step1`.
- Archivos: `submit-vacation-request-step1-default.html`, `submit-vacation-request-step1-loading.html`, `submit-vacation-request-step1-missing-start-error.html`, `submit-vacation-request-step1-missing-end-error.html`, `submit-vacation-request-step1-inverted-range-error.html` y `submit-vacation-request-step1-success.html`.
- Incluye los errores de fecha ausente y de intervalo invertido expresados por FR-006, dejando el contenido no especificado como `TODO(content)`.
- No se genera `empty`: el flujo es un formulario sin colección.
- No se modifica la spec, el caso de uso, Gherkin ni código de aplicación.
