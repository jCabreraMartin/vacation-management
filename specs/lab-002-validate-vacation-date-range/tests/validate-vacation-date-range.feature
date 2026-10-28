# language: en
# Escenario detectado: fullstack, según la especificación.
# Spec: ../requirements/requirements.md
# User Story: US-LAB-F002-01
# Use case: ../requirements/use-cases/UC-002.md (UC-002)
# Requisito: FR-006
@LAB-F002
Feature: Validar el intervalo de fechas de una solicitud
  Como empleado, quiero recibir un error de validación si las fechas indicadas no cumplen las reglas expresas.

  # Gap: El contenido que haría el error "comprensible" no está definido ni es verificable con la evidencia actual.
  # LAB-OQ-002 y LAB-OQ-004 dejan abiertas otras reglas de calendario; no se prueban aquí.

  @US-LAB-F002-01 @AC-LAB-F002-01 @UC-002
  Scenario: Rechazar una solicitud sin fecha inicial
    Given el empleado ha iniciado una solicitud sin fecha inicial
    And la fecha final está presente
    When intenta enviar la solicitud
    Then el sistema comunica un error de validación
    And no crea una solicitud con estado "Pendiente"

  @US-LAB-F002-01 @AC-LAB-F002-01 @UC-002
  Scenario: Rechazar una solicitud sin fecha final
    Given el empleado ha iniciado una solicitud con fecha inicial
    And no ha indicado fecha final
    When intenta enviar la solicitud
    Then el sistema comunica un error de validación
    And no crea una solicitud con estado "Pendiente"

  @US-LAB-F002-01 @AC-LAB-F002-02 @UC-002
  Scenario: Rechazar un intervalo invertido
    Given el empleado ha iniciado una solicitud con ambas fechas presentes
    And la fecha final es anterior a la fecha inicial
    When intenta enviar la solicitud
    Then el sistema comunica un error de validación
    And no crea una solicitud con estado "Pendiente"
