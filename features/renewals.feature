Feature: Track Renewals
  As a user of SDOps
  I want to be able to track expiring contracts for my team(s)
  In order to know when to create a replacement quote

  Background:
    Given the contract dropdowns are populated
  Scenario:
    Given I am logged in as a "commenter"
    And some renewal contracts exist
    When I visit /reports/renewals
    Then I should see "contract the first"
    And I should not see "contract the second"
    And I should not see "contract the third"
    And I should not see "contract the fourth"

  Scenario:
    Given I am logged in as a "manager"
    And some renewal contracts exist
    When I visit /reports/renewals
    Then I should see "contract the first"
    And I should not see "contract the second"
    And I should see "contract the third"
    And I should not see "contract the fourth"

  Scenario:
    Given I am logged in as a "manager"
    And I have the "renewals_manager" role
    And some renewal contracts exist
    And I visit /reports/renewals
    And I follow the sentrenewal link
    Then I should see "Renewal Sent"
    And I should see "Renewal Amount"
    And I should see "Renewal Created"
    And I should see "Update Renewal Sent Date"

  Scenario:
    Given I am logged in as a "manager"
    And I have the "renewals_manager" role
    And some renewal contracts exist
    And I follow the sentrenewal link
    When I fill in "Renewal Sent" with "10/31/2011"
    And I fill in "Renewal Amount" with "9797.55"
    And I fill in "Renewal Created" with "10/15/2011"
    And I press "Update"
    Then I should see "EXPIRED CONTRACTS"
    And I should see "2011-10-31"
    And I should see "2011-10-15"
    And I should see "9,797.55"