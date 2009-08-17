Feature:
  Subcontracts should belong to a Subcontractor, and each subcontract
  should have multiple line items.

  Background:
    Given I am logged in as a "contract_admin"

  Scenario: Add line items to a subcontract
    Given a subcontractor exists
    And a subcontract exists
    And a contract exists
    And I have created 2 line items for that contract
    And I am viewing that contract
    When I check 2 of the line item checkboxes
    And I press "Add to Subcontract"
    Then I should see the subcontract form
