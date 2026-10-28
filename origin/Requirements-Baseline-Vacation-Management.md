# Línea base de requisitos — Gestión de vacaciones

> **Estado de la línea base:** Borrador bloqueado — falta un RFP aprobado y fuentes pertinentes.
> **Fecha:** 2026-10-27
> **Idioma:** Español (España)

## 1. Propósito y alcance

Este documento registra la línea base de requisitos disponible para el proyecto de Gestión de
vacaciones. Solo se incorporarán requisitos trazables a fuentes pertinentes y aprobadas. Las
transcripciones se consideran evidencia de origen, no instrucciones listas para implementar; las
ambigüedades y posibles errores de transcripción deben confirmarse antes de convertirlos en
requisitos.

## 2. Estado de las fuentes

| ID de fuente | Fuente / revisión | Pertinencia | Estado y tratamiento |
| --- | --- | --- | --- |
| SRC-001 | `origin/RFP-Vacation-Management.md`, revisión local del 2026-10-27 | Relacionada con el proyecto | Borrador, no aprobado. Declara que no hay fuentes de Gestión de vacaciones y no confirma requisitos. No se usa como aprobación de requisitos. |
| SRC-002 | `origin/RFP-Calculator.md`, blob `2c083f69eb62ac4f40d1ed306eb0ffc1a7452ad2` en el commit `d6670f5` | No pertinente | RFP para una aplicación de calculadora de negocio. Está eliminado del árbol de trabajo y se excluye por no corresponder al producto. No se reutiliza ninguno de sus datos o requisitos. |

Las carpetas `origin/rfp/`, `origin/discovery/`, `origin/business-notes/`, `origin/constraints/`,
`origin/integrations/` y `origin/reference-images/` no contenían fuentes en la revisión.

## 3. Clasificación

- **BR:** requisito de negocio.
- **FR:** requisito funcional.
- **NFR:** requisito no funcional.
- **TC:** restricción técnica.
- **INT:** requisito de integración.
- **SEC:** requisito de seguridad o cumplimiento.

Cada requisito deberá documentarse con estos campos: identificador, tipo, enunciado, fuente,
justificación, evidencia de aceptación, dependencias, ambigüedades y estado (`Draft`, `Clarification
needed` o `Confirmed`).

## 4. Requisitos identificados

**No hay requisitos baselinables en esta revisión.** No se asignan identificadores BR, FR, NFR, TC,
INT ni SEC porque las fuentes pertinentes no contienen necesidades aprobadas de Gestión de
vacaciones. Esto no significa que el producto carezca de requisitos; significa que todavía no hay
evidencia suficiente para registrarlos.

| Identificador | Tipo | Enunciado | Fuente | Justificación | Evidencia de aceptación | Dependencias | Ambigüedades | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

## 5. Preguntas abiertas

Estas preguntas son aclaraciones pendientes, no requisitos ni decisiones:

| ID | Pregunta | Fuente relacionada | Estado |
| --- | --- | --- | --- |
| OQ-001 | ¿Cuál es el RFP aprobado de Gestión de vacaciones y qué documentos o transcripciones lo respaldan? | SRC-001 | Clarification needed |
| OQ-002 | Para cada transcripción, ¿qué afirmaciones son hechos confirmados, qué pasajes son ambiguos o posiblemente incorrectos y quién puede validarlos? | Fuentes pendientes | Clarification needed |
| OQ-003 | ¿Qué necesidades de negocio y resultados espera el proyecto, y qué pasaje de una fuente respalda cada uno? | RFP aprobado pendiente | Clarification needed |
| OQ-004 | ¿Qué actores, procesos y reglas de negocio deben estar dentro del alcance? No se presupone ningún rol ni regla. | RFP aprobado y transcripciones pendientes | Clarification needed |
| OQ-005 | ¿Qué objetivos no funcionales, restricciones técnicas, obligaciones legales o de cumplimiento están aprobados y dónde se documentan? | Fuentes pendientes | Clarification needed |
| OQ-006 | ¿Qué sistemas externos o intercambios de datos forman parte del alcance, si los hubiera? | Fuentes pendientes | Clarification needed |

## 6. Supuestos

No se adopta ningún supuesto como hecho. Los valores ausentes, actores, umbrales, reglas, integraciones
y decisiones técnicas permanecen sin definir hasta que una fuente pertinente los respalde y una parte
responsable los confirme.

## 7. Criterio para actualizar la línea base

1. Añadir las fuentes originales a `origin/` sin corregir ni traducir su contenido fuente.
2. Asignar un ID estable a cada fuente y conservar la referencia exacta (archivo y página, sección,
   marca temporal o fragmento).
3. Registrar por separado la transcripción original, las correcciones propuestas y su validación.
4. Crear un requisito independiente por actor u outcome distinto; no fusionar requisitos diferentes.
5. Asignar el tipo y el estado adecuados, junto con evidencia de aceptación, dependencias y
   ambigüedades.
6. Cambiar a **Confirmed** únicamente cuando la fuente y la aprobación estén registradas.