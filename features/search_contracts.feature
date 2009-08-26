# For some reason, this doesn't work, giving all sorts of internal ruby
# errors when it's run.
Feature: Finding contracts
  As a Dallas user
  I should be able to see all the contracts in my area
  And I should be able to narrow the list down by searching;
    Including a search by serial number
  In order to find the contract I need.
  But I should not see the Philadelphia contracts
  Unless I search by serial number
  So that security is maintained.

  Background:
    Given the contract dropdowns are populated
    And I am logged in as a "call_screener" with only the "Dallas" team
    And some contracts exist to search on
    And line items exist for those contracts
    And I visit /contracts
#
#  Scenario: Viewing contracts
#    Then I should see "contract the first"
#    And I should see "contract the second"
#    But I should not see "contract the third"
#    And I should not see "contract the fourth"
#
#  Scenario Outline: Search in Dropdowns
#    When I select "<value>" from "<dropdown>"
#    And I press "Search"
#    Then I should see "<result>"
#    But I should not see "<hidden>"
#
#    Examples:
#    | value | dropdown | result | hidden |
#    | Dallas | Sales Office | contract the first | contract the third |
#    | Dallas | Sales Office | contract the second | contract the fourth |
#    | Dallas | Supp. Office | contract the first | contract the third |
#    | Annual | Terms | contract the first | contract the second |
#    | Monthly | Terms | contract the second | contract the first |
#
#  Scenario Outline: Search in text fields
#    When I fill in "<field>" with "<value>"
#    And I press "Search"
#    Then I should see "contract the first"
#    But I should not see "contract the second"
#
#    Examples:
#    | field         | value       |
#    | Account Name  | ACS         |
#    | SAID          | first       |
#    | Description   | first       |
#    | Start Date    | 2009-01-01  |
#    | End Date      | 2009-01-31  |
#    | Annual Rev    | 10100       |
#    | Annual Rev    | >10000      |
#
  Scenario Outline: Search by serial number
    When I fill in "serial_search_serial_number" with "<serial>"
    And I press "Find Serial Num"
    Then I should see "contract the <number>"
    But I should not see "contract the <other>"

    Examples:
    | serial    | number  | other   |
    | SERIAL11  | first   | second  |
    | SERIAL12  | first   | third   |
    | SERIAL21  | second  | fourth  |
    | SERIAL22  | second  | first   |
    | SERIAL31  | third   | second  |
    | SERIAL32  | third   | fourth  |
    | SERIAL41  | fourth  | first   |
    | SERIAL42  | fourth  | third   |

  Scenario Outline: Serial Number approximate Matches
    When I fill in "serial_search_serial_number" with "<serial>"
    And I press "Find Serial Num"
    Then I should see "contract the <number>"
    And I should see "NOTE: Serial Number search found approximate matches."
    But I should not see "contract the <other>"
    Examples:
    | serial    | number  | other   |
    | SERIALI1  | first   | second  |
    | SERIALI2  | first   | third   |
    | SERIAL2I  | second  | fourth  |

  Scenario: Call Screener Views a contract
    When I visit the path for a contract outside my area
    Then I should see "General Details" within "#section2"
    And I should see "Terms"
    And I should see "SERIAL31"
    But I should not see "Edit"
    And I should not see "Revenue" within "#section2"
    And I should not see "Delete"
    And I should not see "Destroy"
    And I should not see "Drag"
    And I should not see "New Line Item"
    And I should not see "Line Items Mass Update"

