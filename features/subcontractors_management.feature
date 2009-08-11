Feature: Manage Subcontractors
  As a contract_admin
  I want to be able to manage subcontractors
  So that I can maintain an accurate list and accurate information about them.

  Scenario: Add a Subcontractor
    Given I am logged in as a "contract_admin"
    When I follow "Partners"
    And I follow "New subcontractor"
    And I fill in "Name" with "subkspecial"
    And I fill in "Notes" with "This is a note"
    And I press "Create"
    Then I should see "subkspecial"
    And I should see "This is a note"

  Scenario: Delete a Subcontractor
    Given a subcontractor exists
    And I am logged in as a "contract_admin"
    When I follow "Partners"
    And I follow "Delete" in the subcontractors table
    Then I should not see "subkspecial"

  Scenario: Modify a Subcontractor
    Given a subcontractor exists
    And I am logged in as a "contract_admin"
    When I follow "Partners"
    And I follow "Edit" in the subcontractors table
    And I fill in "Name" with "anothersubcontractor"
    And I press "Update"
    Then I should see "anothersubcontractor"
    And I should see "Subcontractor was successfully updated"
    But I should not see "subkspecial"

