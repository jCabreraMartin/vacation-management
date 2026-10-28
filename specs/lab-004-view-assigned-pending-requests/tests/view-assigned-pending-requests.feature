# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F004-01
# Use case: ../requirements/use-cases/UC-004.md (UC-004)
# Requisitos: FR-003, SEC-001
@LAB-F004
Feature: Consultar solicitudes pendientes asignadas
  Como responsable aprobador, quiero consultar las solicitudes pendientes de los empleados que tengo asignados.

  # Gap (UC-004): no están definidos el estado vacío ni el tratamiento de asignaciones inexistentes o ambiguas.
  # Mensaje, reintentos y disponibilidad ante una consulta fallida tampoco están especificados.

  @US-LAB-F004-01 @AC-LAB-F004-01 @UC-004 @smoke
  Scenario: Ver las solicitudes pendientes de empleados asignados
    Given el responsable tiene empleados asignados con solicitudes pendientes
    When consulta sus solicitudes pendientes
    Then ve las solicitudes pendientes de esos empleados asignados

  @US-LAB-F004-01 @AC-LAB-F004-02 @UC-004 @security
  Scenario: Denegar la consulta de una solicitud de empleado no asignado
    Given una solicitud pertenece a un empleado no asignado al responsable
    When el responsable intenta consultarla
    Then el acceso se deniega
