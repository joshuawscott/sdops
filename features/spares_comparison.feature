@wip
Feature:
  As a Spares Purchaser or Field Engineer
  I need to compare spares on-hand to spares needed
  So that I can keep the stocking levels in a good range

  Background:
    Given 3 "W1" inventory items exist
    And warehouse "W1" is "Warehouse 1"
    And I am logged in without a role
    And a contract and line items exist for comparison
    And I follow "Spares Assessment"

  Scenario:
    When I select "Dallas" from "filter_offices"
    And I press "Search"
    And I should see "A5001"
    And I should see "A5002"
    And I should see "A5003"
    And I should see "A5004"
