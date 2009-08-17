Feature: Line Items Mass Update
  As a Contract Editor
  I want to be able to update many line items at once
  In order to more quickly make changes

  Background:
    Given the contract dropdowns are populated
    And I am logged in as a "contract_editor"
    And a contract exists
    And a subcontractor exists
    And I have created 2 line items for that contract
    And I am viewing that contract

  Scenario: Mass Update all line items
    When I check 2 of the line item checkboxes
    And I select "subkspecial" from "Supp Provider"
    And I press "Update Checked Items"
    Then I should see "subkspecial" in the line items
    And I should not see "Sourcedirect" in the line items

  Scenario: Mass Update one line item
    When I check 1 of the line item checkboxes
    And I select "subkspecial" from "Supp Provider"
    And I press "Update Checked Items"
    Then I should see "subkspecial" in the line items
    And I should see "Sourcedirect" in the line items

