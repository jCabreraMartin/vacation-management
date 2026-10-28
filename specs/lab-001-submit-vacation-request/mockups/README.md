# Mockups: Presentar una solicitud de vacaciones

**Feature:** LAB-F001  
**Modo:** `generate`  
**Fecha:** 2026-10-27

Estos HTML son wireframes estáticos para el ejercicio de aprendizaje. Representan el flujo descrito en la feature, UC-001 y FR-006. No implementan validación, envío ni persistencia.

## Flujo y pantallas

| Flujo | Paso | Estado | Pantalla |
| --- | --- | --- | --- |
| `presentar-solicitud` | `step1` | `default` | [Formulario inicial](submit-vacation-request-step1-default.html) |
| `presentar-solicitud` | `step1` | `loading` | [Envío en curso](submit-vacation-request-step1-loading.html) |
| `presentar-solicitud` | `step1` | `error` | [Falta fecha inicial](submit-vacation-request-step1-missing-start-error.html) |
| `presentar-solicitud` | `step1` | `error` | [Falta fecha final](submit-vacation-request-step1-missing-end-error.html) |
| `presentar-solicitud` | `step1` | `error` | [Fecha final anterior a inicial](submit-vacation-request-step1-inverted-range-error.html) |
| `presentar-solicitud` | `step1` | `success` | [Registro confirmado](submit-vacation-request-step1-success.html) |

## Asunciones y pendientes

- Las dos fechas se muestran como obligatorias y el comentario como opcional, según FR-001.
- Las únicas condiciones de validación representadas son las expresas en FR-006: falta una fecha o la fecha final es anterior a la inicial.
- El mensaje exacto de error, el contenido de la confirmación y el texto del estado de envío están señalados con comentarios `TODO(content)` en los HTML.
- El estado success muestra `Pendiente`, conforme a FR-001. No representa notificaciones externas.
- El formato, zona horaria, política de calendario y tratamiento de fallos no se infieren.
- Los controles son representativos; no hay JavaScript ni comportamiento funcional.

## Estado omitido

- **`empty`: omitido deliberadamente.** La pantalla es un formulario de captura, no una colección que pueda quedar vacía. Los campos sin completar pertenecen al estado inicial `default`, no a un estado empty.

## Apertura

Abre cualquiera de los enlaces anteriores directamente en un navegador. Cada archivo carga Tailwind CSS v4 browser build desde CDN, por lo que la vista requiere acceso a Internet.
