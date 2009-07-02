Feature: Line Item Management
  As a Contract Editor
  I want to be able to add, remove, and modify line items
  And change their positions
  In order to maintain a clear and accurate listing of line items in a contract.

  Background:
    Given the contract dropdowns are populated
    And I am logged in as a "contract_editor"
    And a contract exists
    And I am viewing that contract

  Scenario: Create a line item
    When I follow "New Line Item"
    And I fill out the line item form
    And I press "Create"
    Then I should see the new line item

  Scenario: Edit a line item
    Given I have created a line item
    And I am viewing its contract
    When I follow "Edit" for that line item
    And I change a line item detail
    Then I should see the new line item details
    And I should not see "problem"

  Scenario: Delete a line item
    Given I have created a line item
    And I am viewing its contract
    When I follow "Delete" for that line item
    Then I should be see its contract
    And I should not see that line item

  Scenario Outline: Try to create an incomplete line item
    When I follow "New Line Item"
    And I create a line item missing "<field>"
    Then I should see "<message>"

    Examples:
    | field       | message                     |
    | location    | Location can't be blank     |
    | position    | Position can't be blank     |
    | product_num | Product num can't be blank  |

  Scenario Outline: Try to enter incorrect values for fields
    When I follow "New Line Item"
    And I create a line item with "<field>" set to "<value>"
    Then I should see "<message>"

    Examples:
    | field         | value | message                             |
    | support_type  | HW    | Line Item was successfully created. |
    | support_type  | SW    | Line Item was successfully created. |
    | support_type  | SRV   | Line Item was successfully created. |
    | support_type  | AA    | Line Item was successfully created. |
