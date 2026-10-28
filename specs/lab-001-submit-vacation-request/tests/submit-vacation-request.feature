# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F001-01
# Use case: ../requirements/use-cases/UC-001.md (UC-001)
# Requisitos: BR-001 (parcial), FR-001, SEC-001
@LAB-F001
Feature: Presentar una solicitud de vacaciones
  Como empleado, quiero presentar un intervalo de vacaciones para registrar una solicitud.

  # Gap: Las reglas completas para aceptar un intervalo siguen abiertas (LAB-OQ-002, LAB-OQ-004).
  # Estos escenarios solo pueden asumir las comprobaciones especificadas en FR-006.

  @US-LAB-F001-01 @AC-LAB-F001-01 @UC-001 @smoke
  Scenario: Presentar una solicitud sin comentario
    Given el empleado ha iniciado una solicitud con ambas fechas presentes
    And la fecha final no es anterior a la fecha inicial
    And no añade un comentario
    When envía la solicitud
    Then la solicitud queda registrada con estado "Pendiente"
    And el empleado recibe una confirmación de registro

  @US-LAB-F001-01 @AC-LAB-F001-02 @UC-001
  Scenario: Asociar el comentario opcional a la solicitud
    Given el empleado ha iniciado una solicitud con ambas fechas presentes
    And la fecha final no es anterior a la fecha inicial
    And añade un comentario
    When envía la solicitud
    Then el comentario queda asociado a la solicitud registrada
    And la solicitud queda registrada con estado "Pendiente"
