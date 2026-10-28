# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F006-01
# Use case: ../requirements/use-cases/UC-006.md (UC-006)
# Requisitos: FR-004 (outcome de rechazo), SEC-001
@LAB-F006
Feature: Rechazar una solicitud de vacaciones
  Como responsable aprobador, quiero rechazar una solicitud pendiente asignada y registrar el resultado.

  # Gap (UC-006): el resultado ante fallo de registro, decisiones concurrentes y retraso de actualización no está definido.
  # El motivo de rechazo es una pregunta abierta; estos escenarios no lo requieren ni lo descartan.

  @US-LAB-F006-01 @AC-LAB-F006-01 @AC-LAB-F006-02 @UC-006 @smoke
  Scenario: Rechazar una solicitud pendiente y consultar el estado actualizado
    Given existe una solicitud en estado "Pendiente" de un empleado asignado al responsable
    And el responsable está autorizado para decidirla
    When el responsable rechaza la solicitud
    Then la solicitud queda registrada como "Rechazada"
    When el empleado consulta sus solicitudes
    Then puede ver el estado "Rechazada" en la solicitud

  @US-LAB-F006-01 @UC-006
  Scenario: No rechazar una solicitud que ya no está pendiente
    Given la solicitud ya no está en estado "Pendiente"
    When el responsable intenta rechazarla
    Then no se registra el rechazo

  @US-LAB-F006-01 @UC-006 @security
  Scenario: Denegar el rechazo por falta de autorización
    Given existe una solicitud pendiente de un empleado no asignado al responsable
    When el responsable intenta rechazarla
    Then la acción se deniega
    And el estado de la solicitud no cambia

  @US-LAB-F006-01 @UC-006
  Scenario: No registrar una decisión para una solicitud inexistente
    Given la solicitud indicada no existe
    When el responsable intenta rechazarla
    Then no se registra una decisión
