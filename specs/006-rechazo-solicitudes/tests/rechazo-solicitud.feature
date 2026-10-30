# language: es
# F-006 / US-001 / UC-008 · Bolt 1 (#74).
# Escenarios basados en decisiones del laboratorio DL-B1-02..06, no en criterios aprobados por el cliente.
# Datos: solicitudes semilla ficticias; no representan integración real.

@F-006 @US-001 @UC-008 @bolt-1 @laboratorio
Característica: Rechazar una solicitud de vacaciones pendiente
  Como responsable
  Quiero rechazar una solicitud pendiente
  Para aplicar el resultado de rechazo sin proponer alternativas

  Antecedentes:
    Dado que existe la solicitud ficticia "LAB-001" de "Persona Ficticia A" en estado "Pendiente"

  @AC-LAB-01 @smoke
  Escenario: Rechazar una solicitud pendiente
    Cuando el responsable rechaza la solicitud "LAB-001"
    Entonces la solicitud "LAB-001" queda en estado "Rechazada"

  @AC-LAB-02 @regression
  Escenario: No se puede rechazar dos veces una solicitud
    Dado que el responsable ya ha rechazado la solicitud "LAB-001"
    Cuando el responsable intenta rechazar de nuevo la solicitud "LAB-001"
    Entonces se informa de que la solicitud no está pendiente
    Y la solicitud "LAB-001" sigue en estado "Rechazada"

  @AC-LAB-03 @regression
  Escenario: Rechazar una solicitud inexistente
    Cuando el responsable intenta rechazar la solicitud "NO-EXISTE"
    Entonces se informa de que la solicitud no existe

  @AC-LAB-03 @regression
  Escenario: Consultar una solicitud inexistente
    Cuando el responsable consulta la solicitud "NO-EXISTE"
    Entonces se informa de que la solicitud no existe

  @AC-LAB-04 @AC-LAB-05 @smoke @ui
  Escenario: Rechazar desde la interfaz sin motivo ni alternativas
    Dado que el responsable ve la solicitud "LAB-001" con persona, fechas y estado "Pendiente"
    Y no se le pide motivo ni se le ofrecen fechas alternativas
    Cuando pulsa "Rechazar solicitud"
    Entonces ve el estado "Rechazada"
    Y ya no se le ofrece la acción de rechazar

  @AC-LAB-05 @regression @ui
  Escenario: Error al consultar una solicitud inexistente desde la interfaz
    Cuando el responsable abre la solicitud "NO-EXISTE"
    Entonces ve un mensaje de que la solicitud no existe
    Y no se le ofrece la acción de rechazar
