# ADR-0002: Registrar la selección de Angular para el frontend

## Estado

Sustituida por [ADR-0004](ADR-0004-replace-angular-with-vue-frontend.md) el 2026-10-29. Originalmente
aceptada (seleccionada en el asistente de inicialización; la versión del framework sigue sin
especificarse).

## Contexto

El asistente de inicialización greenfield seleccionó Angular para el frontend. No preguntó ni
registró una versión principal, ni recogió una comparación específica del proyecto entre frameworks
frontend.

## Decisión

Usar Angular para el frontend. La evidencia disponible del laboratorio no selecciona la versión del
framework; esta debe confirmarse antes de generar la estructura o instalar dependencias.

## Justificación

El asistente registra explícitamente Angular como framework seleccionado. No se recogió ninguna
justificación adicional de negocio o técnica; por ello, este ADR registra el resultado sin inventar
ventajas comparativas.

## Alternativas consideradas

El asistente ofrecía React, Vue.js y la opción de no usar framework frontend o usar varios. El
laboratorio registra Angular como opción seleccionada, pero no documenta los motivos para descartar
las alternativas.

## Consecuencias

- Las instrucciones y la estructura inicial del frontend deben orientarse a Angular cuando se
  confirme su versión.
- Si se requiere una justificación comparativa, la persona responsable del proyecto debe documentar
  los requisitos que motivaron la selección de Angular.