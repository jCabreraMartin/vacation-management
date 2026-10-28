# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F003-01
# Use case: ../requirements/use-cases/UC-003.md (UC-003)
# Requisitos: FR-002, SEC-001
@LAB-F003
Feature: Consultar las solicitudes propias de vacaciones
  Como empleado, quiero consultar mis solicitudes para conocer su estado actual.

  # Gap (UC-003): el comportamiento para una lista vacía, un detalle inexistente o una consulta fallida no está definido.
  # No se asigna un resultado esperado a esos casos.

  @US-LAB-F003-01 @AC-LAB-F003-01 @UC-003 @smoke
  Scenario: Consultar la lista, el detalle y el estado de solicitudes propias
    Given el empleado tiene solicitudes registradas
    When consulta sus solicitudes
    Then puede ver la lista de sus solicitudes
    When selecciona una de ellas
    Then puede consultar su detalle
    And puede ver su estado actual

  @US-LAB-F003-01 @AC-LAB-F003-02 @UC-003 @security
  Scenario: Denegar la consulta de una solicitud ajena
    Given una solicitud pertenece a otra persona
    When el empleado intenta consultarla como propia
    Then el acceso se deniega
