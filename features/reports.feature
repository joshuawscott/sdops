
Feature:
  As a user of SDOps
  I want to be able to view reports
  And I want to be able to export data
  In order to use the information in the system

  Background:
    Given the Dallas territory has a "New Business" goal of "500.00"
    Given the Philadelphia territory has a "New Business" goal of "500.00"
    And some contracts exist

  Scenario: View report showing territory's performance measured against quota
    Given I am on the reports page
    When I follow the "New Business Against Quota"
    Then I should see "Dallas"
    And I should see "30%"
    And I should see "Philadelphia"
    And I should see "40%"
