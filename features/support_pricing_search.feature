Feature: Search for Support Pricing information
  As a system user
  I want to be able to search for support prices
  In order to be able to find the current and historical prices
  When I search for a product number, the system should match any
  product numbers that begin with the search string.
  When I search for a description, the system should match any items
  that contain the search string.
  The search boxes should also preserve the search strings

  Background:
    Given I am logged in without a role
    And some support products exist

  Scenario Outline: Search for a product
    Given I follow "<link>"
    And I fill in "<searchbox>" with "<entry>"
    And I press "Search"
    Then I should see "<entry>"
    And I should see "<seen>"
    But I should not see "<unseen>"

    Examples:
    | link                | searchbox   | entry   | seen    | unseen    |
    | HW Support Pricing  | Part Number | A6144A  | L3000   | Processor |
    | HW Support Pricing  | Description | L3000   | A6144A  | A5522A    |
    | HW Support Pricing  | Part Number | A614    | L3000   | Processor |
    | HW Support Pricing  | Description | L3      | A6144A  | A5522A    |
    | SW Support Pricing  | Part Number | A6144A  | L3000   | Processor |
    | SW Support Pricing  | Description | L3000   | A6144A  | A5522A    |
    | SW Support Pricing  | Part Number | A614    | L3000   | Processor |
    | SW Support Pricing  | Description | L3      | A6144A  | A5522A    |

  Scenario: Search for a product that has 1 entry
  Scenario: Search for a product that has 2 entries
