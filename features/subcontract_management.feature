Feature: Manage Subcontracts
  As a contract_admin
  I want to be able to manage subcontracts
  So that I can maintain an accurate list and accurate information about them.

  Background:
    Given a subcontractor exists

  Scenario: Add a Subcontract
    Given I am logged in as a "contract_admin"
    When I follow "Subcontracts"
    And I follow "New subcontract"
    And I select "subkspecial" from "Subcontractor"
    And I fill in "Description" with "MySubcontract"
    And I fill in "Start Date" with "2009-01-01"
    And I fill in "End Date" with "2009-12-31"
    And I press "Create"
    Then I should see "subkspecial"
    And I should see "MySubcontract"
    And I should see "Subcontract was successfully created."

  Scenario: Delete a Subcontract
    Given a subcontract exists
    And I am logged in as a "contract_admin"
    When I follow "Subcontracts"
    And I follow "Delete" in the subcontracts table
    Then I should not see "subkspecial"

  Scenario: Modify a Subcontract
    Given a subcontract exists
    And I am logged in as a "contract_admin"
    When I follow "Subcontracts"
    And I follow "Edit" in the subcontracts table
    And I fill in "Description" with "AnotherSubcontract"
    And I press "Update"
    Then I should see "AnotherSubcontract"
    And I should see "Subcontract was successfully updated"
    But I should not see "MySubcontract"

