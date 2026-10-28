# Catálogo de features — Gestión de vacaciones

**Estado:** Bloqueado a la espera de un RFP aprobado y requisitos confirmados. · **Fecha de revisión:** 2026-10-27

## Resultado de la revisión

No hay features aprobadas para el producto: la [solicitud de propuesta](../origin/RFP-Vacation-Management.md)
sigue en borrador y la [línea base de requisitos](../origin/Requirements-Baseline-Vacation-Management.md)
no contiene requisitos confirmados. Para el laboratorio se generaron siete features hipotéticas
`LAB-HYP`, todas en estado Draft y no implementables sin validación.

El RFP de calculadora de negocio registrado como SRC-002 en la línea base no corresponde a Gestión
de vacaciones y no se usa para inferir features, actores, objetivos ni criterios de aceptación.

## Features

**Features aprobadas del producto:** 0.  
**Features didácticas LAB-HYP:** 7 (Draft).

| ID | Feature didáctica | Requisitos | Issue | Estado |
| --- | --- | --- | --- | --- |
| LAB-F001 | Presentar una solicitud de vacaciones | BR-001, FR-001 | [gh#1](https://github.com/jCabreraMartin/vacation-management/issues/1) | Draft / LAB-HYP |
| LAB-F002 | Validar el intervalo de fechas de una solicitud | FR-006 | [gh#6](https://github.com/jCabreraMartin/vacation-management/issues/6) | Draft / LAB-HYP |
| LAB-F003 | Consultar solicitudes propias de vacaciones | FR-002 | [gh#2](https://github.com/jCabreraMartin/vacation-management/issues/2) | Draft / LAB-HYP |
| LAB-F004 | Consultar solicitudes pendientes asignadas | FR-003 | [gh#3](https://github.com/jCabreraMartin/vacation-management/issues/3) | Draft / LAB-HYP |
| LAB-F005 | Aprobar una solicitud de vacaciones | FR-004 (outcome aprobación) | [gh#4](https://github.com/jCabreraMartin/vacation-management/issues/4) | Draft / LAB-HYP |
| LAB-F006 | Rechazar una solicitud de vacaciones | FR-004 (outcome rechazo) | [gh#7](https://github.com/jCabreraMartin/vacation-management/issues/7) | Draft / LAB-HYP |
| LAB-F007 | Retirar una solicitud de vacaciones pendiente | FR-005 | [gh#5](https://github.com/jCabreraMartin/vacation-management/issues/5) | Draft / LAB-HYP |

## Material didáctico del laboratorio

Para poder practicar la generación de features y casos de uso sin fuentes reales, se ha creado una
[línea base hipotética](lab/requirements-baseline.md). Sus requisitos son ficticios y están en estado
Draft; no constituyen requisitos aprobados del proyecto ni sustituyen la línea base respaldada por
fuentes.

Cada spec didáctico está en su carpeta independiente, bajo `requirements/requirements.md`. Una
feature solo pasará a ser del producto cuando sus fuentes y requisitos sean validados y aprobados.
Cada especificación incluirá:

- Objetivo y valor de negocio.
- Actores respaldados por la fuente.
- Alcance y exclusiones.
- Requisitos funcionales cubiertos.
- Requisitos no funcionales aplicables.
- Historias de usuario y criterios de aceptación iniciales.
- Dependencias.
- Preguntas abiertas.
- Trazabilidad a las fuentes y estado de aprobación.

No se combinarán requisitos con actores u outcomes distintos. Los campos sin evidencia se dejarán
pendientes, sin completar con valores por defecto.

## Preguntas bloqueantes

1. ¿Cuál es el RFP aprobado de Gestión de vacaciones y qué fuentes o transcripciones lo respaldan?
2. ¿Quién validará las correcciones de transcripción y resolverá las expresiones ambiguas?
3. ¿Qué necesidades de negocio, actores, flujos y reglas están confirmados?
4. ¿Qué requisitos no funcionales, restricciones, obligaciones de cumplimiento e integraciones están
   documentados y aprobados?

La información aportada deberá añadirse bajo `origin/` como evidencia; el catálogo se actualizará
solo después de su revisión y confirmación.