Feature: Line Items Mass Delete
  As a Contract Admin
  I want to be able to delete many line items at once
  In order to more quickly make changes

  Background:
    Given the contract dropdowns are populated
    And I am logged in as a "admin"
    And a contract exists
    And I have created 2 line items for that contract
    And I am viewing that contract

  Scenario: Mass Delete all line items
    When I check 2 of the line item checkboxes
    And I press "Delete Checked Items"
    Then I should not see "Hardware Line Items"

  Scenario: Mass Delete one line item
    When I check 1 of the line item checkboxes
    And I press "Delete Checked Items"
    Then I should see 1 line item

