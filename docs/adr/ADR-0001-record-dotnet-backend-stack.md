# ADR-0001: Registrar la selección de .NET para el backend

## Estado

Aceptada (seleccionada en el asistente de inicialización; la justificación específica del proyecto
sigue sin documentarse).

## Contexto

El asistente de inicialización greenfield seleccionó la plantilla de backend de .NET 8 para el
proyecto full-stack. No registró una comparación específica del proyecto entre frameworks backend ni
las necesidades de runtime.

## Decisión

Usar C# sobre .NET 8 (LTS) como runtime del backend, según consta en `.boltf/scopes.yaml`.

Esta decisión no selecciona un estilo de API o arquitectura, una base de datos, una tecnología de
acceso a datos, un proveedor de identidad ni un modelo de autorización. Esas decisiones siguen
pendientes.

## Justificación

La evidencia disponible es la selección explícita del asistente y el bloqueo de la plantilla en
.NET 8. No se recogió ninguna justificación adicional de negocio o técnica; por ello, este ADR
registra el resultado sin afirmar que la selección sea superior a las alternativas.

## Alternativas consideradas

El asistente también ofrecía Go, Node.js/NestJS, Python/FastAPI y una plantilla de backend
personalizada. El laboratorio registra .NET 8 como opción seleccionada, pero no documenta los motivos
para descartar las alternativas.

## Consecuencias

- La implementación y las herramientas del backend deben orientarse a .NET 8 hasta que este ADR sea
  sustituido.
- El estilo de API, la persistencia, la autenticación y la arquitectura deben decidirse por separado.
- Si se requiere una justificación comparativa, la persona responsable del proyecto debe añadir los
  requisitos que motivaron esta selección.