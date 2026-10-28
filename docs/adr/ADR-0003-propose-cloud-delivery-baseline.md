# ADR-0003: Proponer la base de entrega en la nube

## Estado

Propuesta; resolver el conflicto entre el modelo de ramas y el disparador del despliegue a desarrollo
antes de implementar.

## Contexto

El asistente de inicialización seleccionó GitHub Actions, Terraform, Podman para el desarrollo local
con contenedores, OpenTelemetry hacia Azure, despliegues rolling, GitHub Flow y las fases de pipeline
de aplicación e infraestructura. También seleccionó el despliegue a desarrollo en commits a
`develop`, a UAT al fusionar un PR y a producción con aprobación manual.

## Decisión

Registrar GitHub Actions, Terraform, Podman para desarrollo local, OpenTelemetry hacia Azure,
despliegues rolling y GitHub Flow como base seleccionada. Mantener como propuesta el comportamiento
del despliegue a desarrollo hasta resolver el conflicto entre hacer commits a `develop` y el modelo
GitHub Flow de `feature/*` hacia `main`.

El asistente seleccionó una cobertura de pruebas unitarias del 80 % y una puntuación de mutación del
60 %. También seleccionó VNet, Private Endpoints, WAF, claves de cifrado administradas por Azure,
cifrado de PII, GDPR e HIPAA. Estas selecciones no establecen que los requisitos de cumplimiento sean
aplicables ni que los controles estén implementados.

## Justificación

Las selecciones del asistente son la única evidencia registrada. No recogió comparaciones específicas
del proyecto, restricciones de nube, aplicabilidad de cumplimiento ni los motivos para preferir estas
opciones. Por tanto, este ADR registra las selecciones y preguntas pendientes, sin afirmar una
justificación técnica.

## Alternativas consideradas

El asistente ofrecía proveedores de pipeline, herramientas IaC, enfoques de observabilidad,
estrategias de despliegue y modelos de ramas alternativos. El laboratorio registra las opciones
seleccionadas, pero no los motivos para descartar las alternativas.

## Consecuencias

- Las herramientas y fases de pipeline indicadas pueden orientar la planificación, pero la
  implementación debe esperar a que se resuelva el disparador de desarrollo y el modelo de ramas.
- La persona responsable del proyecto debe confirmar si GDPR e HIPAA son aplicables y definir la
  evidencia de control necesaria antes de afirmar cumplimiento.
- Las selecciones de infraestructura y políticas de seguridad son requisitos, no pruebas de que los
  controles estén desplegados.