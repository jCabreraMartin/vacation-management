# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F005-01
# Use case: ../requirements/use-cases/UC-005.md (UC-005)
# Requisitos: FR-004 (outcome de aprobación), SEC-001
@LAB-F005
Feature: Aprobar una solicitud de vacaciones
  Como responsable aprobador, quiero aprobar una solicitud pendiente asignada y registrar el resultado.

  # Gap (UC-005): el resultado ante fallo de registro, decisiones concurrentes y retraso de actualización no está definido.

  @US-LAB-F005-01 @AC-LAB-F005-01 @AC-LAB-F005-02 @UC-005 @smoke
  Scenario: Aprobar una solicitud pendiente y consultar el estado actualizado
    Given existe una solicitud en estado "Pendiente" de un empleado asignado al responsable
    And el responsable está autorizado para decidirla
    When el responsable aprueba la solicitud
    Then la solicitud queda registrada como "Aprobada"
    When el empleado consulta sus solicitudes
    Then puede ver el estado "Aprobada" en la solicitud

  @US-LAB-F005-01 @UC-005
  Scenario: No aprobar una solicitud que ya no está pendiente
    Given la solicitud ya no está en estado "Pendiente"
    When el responsable intenta aprobarla
    Then no se registra la aprobación

  @US-LAB-F005-01 @UC-005 @security
  Scenario: Denegar la aprobación por falta de autorización
    Given existe una solicitud pendiente de un empleado no asignado al responsable
    When el responsable intenta aprobarla
    Then la acción se deniega
    And el estado de la solicitud no cambia

  @US-LAB-F005-01 @UC-005
  Scenario: No registrar una decisión para una solicitud inexistente
    Given la solicitud indicada no existe
    When el responsable intenta aprobarla
    Then no se registra una decisión
