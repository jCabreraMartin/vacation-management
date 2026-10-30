# UC-008: Rechazar una solicitud

| Propiedad | Valor |
| --- | --- |
| Feature / historia | F-006 / US-001 |
| Estado | Draft; resultado pendiente de aclaración |
| Scenario | fullstack |
| Nivel | Objetivo de usuario |

## Actores

- **Principal:** responsable; el rol autorizado concreto está pendiente de confirmar.
- **Interesados:** persona solicitante y responsables del proceso.

## Disparador

El responsable decide rechazar una solicitud.

## Precondiciones

- La autoridad del actor y el estado en que se permite rechazar no están definidos.
- No se presupone que «valorar» o «cerrar» sean sinónimos de rechazar.

## Escenario principal candidato

1. El responsable solicita rechazar una solicitud.
2. El sistema refleja el resultado de rechazo conforme a una semántica todavía por validar.
3. No se proponen fechas alternativas, según BL-RF-014.

## Secuencia fullstack y límites técnicos

1. El responsable inicia la intención de rechazo; la autoridad y el significado de «valorar/cerrar» permanecen pendientes.
2. Cuando corresponda, Vue.js comunica la intención al backend C#/.NET 8; no se elige ruta, contrato o protocolo.
3. El backend procesa únicamente el rechazo respaldado tras aclarar sus condiciones y usa una frontera lógica de registro aún no seleccionada.
4. El resultado vuelve a la interfaz conforme a reglas futuras; no se inventan motivo, estado o reversión.

Fallos entre interfaz/backend o backend/registro pueden impedir confirmar el resultado. Comportamiento ante timeout, fallo incierto y recuperación sin especificar; sin reintentos, circuit breaker o idempotencia seleccionados.

## Flujos alternativos y de error

- **A1. «Valorar» o «cerrar» tiene otro significado:** el flujo debe revisarse antes de aprobar el caso.
- **E1. Actor no autorizado o fallo al registrar:** comportamiento no especificado.

## Postcondiciones

- **Éxito:** la solicitud queda rechazada si se confirma el significado y el efecto de la acción.
- **Mínima:** no se define el resultado de un rechazo fallido.

## Reglas de negocio y autorización

- Las fuentes mencionan rechazo y ausencia de propuesta de alternativas (BL-RF-006, BL-RF-014, BL-RF-016, BL-RF-046, BL-RF-048).
- No se inventan motivo, estado, reversión ni notificación.

## Requisitos cubiertos

- BL-RF-006, BL-RF-014, BL-RF-016, BL-RF-046, BL-RF-048.

## Preguntas abiertas

- PA-06: significado de «valorar/cerrar».
- PA-14: estados y efectos de acciones.
- PA-26: actor autorizado y responsable de validar.

## Variante del laboratorio · Paso 16.2, Bolt 1

> Decisiones del laboratorio DL-B1-02…06 ([requisitos](../requirements.md#decisiones-del-laboratorio--paso-162-bolt-1),
> [#74](https://github.com/jCabreraMartin/vacation-management/issues/74)). No es aprobación del cliente;
> el caso de uso anterior sigue siendo el Draft basado en fuentes.

**Actor:** «responsable» implícito, sin autenticación ni comprobación de permisos (DL-B1-02).

**Precondición:** existe una solicitud semilla ficticia identificada (DL-B1-04).

**Escenario principal:**

1. El responsable abre la solicitud indicando su identificador.
2. La interfaz Vue consulta la solicitud al backend y muestra persona, fechas y estado.
3. El responsable pulsa «Rechazar solicitud»; no se pide motivo ni se ofrecen fechas alternativas.
4. El backend comprueba que la solicitud está «Pendiente» y la registra como «Rechazada».
5. La interfaz muestra el estado «Rechazada» y deja de ofrecer la acción.

**Flujos de error:**

- **E-LAB-1. Solicitud no pendiente:** el backend rechaza la operación; la interfaz informa y el estado no cambia.
- **E-LAB-2. Identificador inexistente:** se informa de que la solicitud no existe.
- **E-LAB-3. Fallo de comunicación o lectura de la respuesta:** la interfaz termina la carga y muestra
  un error. Tras POST, el resultado se considera desconocido: no se confirma éxito ni se afirma
  que no hubo escritura; solo una consulta manual del estado permite decidir si vuelve a ofrecerse
  el rechazo. No hay reintentos automáticos ni clave de idempotencia.
- **E-LAB-4. Rechazos simultáneos:** la comparación condicional del repositorio confirma uno y
  rechaza los demás como conflicto, sin serializar solicitudes distintas (corrección A-01).
- **E-LAB-5. Escritura de origen ajeno:** la protección local la rechaza antes del caso de uso
  (corrección A-02), sin añadir autenticación corporativa.

**Postcondición:** la solicitud queda «Rechazada» en la memoria del proceso; se pierde al reiniciar (DL-B1-05).
