Feature: Viewing and Searching the Inventory list
  As a user
  I want to be able to view a list of items in inventory
  So that I can know what my current inventory is

  Background:
    Given 3 inventory items exist
    And warehouse "W1" is "Warehouse 1"
    And warehouse "W2" is "Warehouse 2"
    And I am logged in without a role
    And I follow "Inventory"

  Scenario: View list
    Then I should see "Inventory Items"
    And I should see "Tracking #"
    And I should see "Part Number"
    And I should see "Description"
    And I should see "Serial Number"
    And I should see "Warehouse"
    And I should see "Location"

  Scenario Outline: Search in dropdowns
    Given I should see "<value>"
    When I select "<value>" from "<field>"
    And I press "Search"
    Then I should see "<id>"
    But I should not see "<bad_id>"

    Examples:
    | value       | field        | id     | bad_id |
    | Warehouse 1 | Warehouse    | ID1001 | ID1002 |
    | Warehouse 2 | Warehouse    | ID1002 | ID1001 |
    | LOC1        | Location     | ID1001 | ID1002 |
    | LOC2        | Location     | ID1002 | ID1001 |
    | MFG1        | Manufacturer | ID1001 | ID1002 |
    | MFG2        | Manufacturer | ID1002 | ID1001 |

  Scenario Outline: Search in other fields
    Given I should see "<value>"
    When I fill in "<field>" with "<value>"
    And I press "Search"
    Then I should see "<value>"
    But I should not see "<unmatched_value>"

    Examples:
    | value         | field         | unmatched_value |
    | ID1001        | Tracking      | ID1002          |
    | ID1002        | Tracking      | ID1001          |
    | A5001         | Part Number   | A5002           |
    | A5002         | Part Number   | A5001           |
    | Item Number 1 | Description   | Item Number 2   |
    | Item Number 2 | Description   | Item Number 1   |
    | ABC1          | Serial Number | ABC2            |
    | ABC2          | Serial Number | ABC1            |

