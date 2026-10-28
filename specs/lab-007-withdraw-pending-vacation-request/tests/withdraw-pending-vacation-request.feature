# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F007-01
# Use case: ../requirements/use-cases/UC-007.md (UC-007)
# Requisitos: FR-005, FR-002 (parcial), SEC-001
@LAB-F007
Feature: Retirar una solicitud de vacaciones pendiente
  Como empleado, quiero retirar una solicitud propia mientras siga pendiente.

  # Gap (UC-007): la respuesta visible al intentar retirar una solicitud no pendiente no está definida.
  # “En revisión” no está definido como estado; no se presupone su relación con "Pendiente".
  # El resultado ante fallo de registro tampoco está especificado.

  @US-LAB-F007-01 @AC-LAB-F007-01 @UC-007 @smoke
  Scenario: Retirar una solicitud propia pendiente
    Given el empleado tiene una solicitud propia en estado "Pendiente"
    When solicita retirarla
    Then la solicitud queda en estado "Retirada"
    And deja de aparecer entre las solicitudes pendientes del responsable
    And el empleado puede consultar el estado "Retirada"

  @US-LAB-F007-01 @AC-LAB-F007-02 @UC-007
  Scenario: No retirar una solicitud aprobada
    Given el empleado tiene una solicitud propia en estado "Aprobada"
    When solicita retirarla
    Then la solicitud no cambia al estado "Retirada"

  @US-LAB-F007-01 @UC-007 @security
  Scenario: Denegar la retirada de una solicitud ajena
    Given una solicitud pertenece a otra persona
    When el empleado intenta retirarla
    Then el acceso se deniega
    And la solicitud no se modifica

  @US-LAB-F007-01 @UC-007
  Scenario: No marcar como retirada una solicitud cuya revisión está en curso
    Given la revisión de la solicitud está en curso
    When el empleado intenta retirarla
    Then la solicitud no se cambia a "Retirada"
