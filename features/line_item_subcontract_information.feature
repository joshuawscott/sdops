Feature: View Subcontract information for a line item
  As a Call Screener, I want to be able to view the subcontract information for a line item.
  When I receive a call, I should be able to click a link by the line item that the customer
  is calling for, and view the subcontract information.

  Scenario: Line items are subcontracted
    Given the contract dropdowns are populated
    And I am logged in as a "call_screener"
    And a contract exists
    And I have created a line item
    And a subcontract exists
    And the line item is subcontracted
    And I am viewing that contract
    When I follow "subkspecial"
    Then I should see "Subcontractor"
    And I should see "subkspecial"
    And I should see "Line Item subcontract information"
    And I should see "A6144A"
