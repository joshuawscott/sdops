Feature: Opportunities
  As a user
  I want to add be able to add opportunites
  and I want to br able to edit and delet my teams opportunites
  So I can keep track of my team's opportunites

  Background:
    #Given the opportunities dropdowns are populated
    Given I am logged in without a role

  Scenario: Add an opportunity
    Given I am on the opportunities page
    When I create a new opportunity
    Then there should be 1 opportunity
    And I should see a new opportunity

