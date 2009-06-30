Feature: Comments
  As a commenter
  I want to be able to add comments to a contract
  So I can add additional information where needed.

  Scenario: Add a comment
    Given I am logged in as a "commenter"
    And a contract exists
    And I am viewing that contract
    When I fill in "New Comment" with "I have now commented on this contract"
    And I hit enter to save the comment
    Then I should see "I have now commented on this contract"

  Scenario: Fail to add a comment
    Given I am logged in without a role
    And a contract exists
    When I am viewing that contract
    Then I should not see "New Comment"

  Scenario: Edit my comment
    Given I am logged in as a "commenter"
    And a contract exists
    And I have created a comment "I have now commented on this contract" on a contract
    And I am viewing that contract
    When I click "edit" in the comment area
    And I change my comment to "My Comment has now changed"
    And I press "Update"
    Then I should see "My Comment has now changed"

  Scenario: Delete my comment
    Given I am logged in as a "commenter"
    And a contract exists
    And I have created a comment "I have now commented on this contract" on a contract
    And I am viewing that contract
    When I click "delete" in the comment area
    Then I should not see "I have now commented on this contract"

