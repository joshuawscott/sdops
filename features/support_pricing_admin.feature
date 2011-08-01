Feature: Pricing Admin
  As a Pricing Admin
  I want to be able to edit and delete prices
  To correct the mistakes of the pricing_managers.

  Background:
    Given the product lines are populated
    And some support products exist
    And I am logged in as a "pricing_admin"

  Scenario: Links to admin features should be seen - HW
    When I search for HW Support Price "A6144A"
    Then I should see "Delete" inside the support search results
    And I should see "Edit" inside the support search results

  Scenario: Delete a price - HW
    When I search for HW Support Price "A6144A"
    And I follow "Delete" next to the support search results
    And I search for HW Support Price "A6144A"
    Then I should not see "L3000"

  Scenario: Edit a price - HW
    When I search for HW Support Price "A6144A"
    And I follow "Edit" next to the support search results
    And I fill in "Description" with "L2000"
    And I press "Update"
    And I search for HW Support Price "A6144A"
    Then I should not see "L3000"
    But I should see "L2000"

  Scenario: Links to admin features should be seen - SW
    When I search for SW Support Price "A6144A"
    Then I should see "Delete" inside the support search results
    And I should see "Edit" inside the support search results

  Scenario: Delete a price - SW
    When I search for SW Support Price "A6144A"
    And I follow "Delete" next to the support search results
    And I search for SW Support Price "A6144A"
    Then I should not see "L3000"

  Scenario: Edit a price - SW
    When I search for SW Support Price "A6144A"
    And I follow "Edit" next to the support search results
    And I fill in "Description" with "L2000"
    And I press "Update"
    And I search for SW Support Price "A6144A"
    Then I should not see "L3000"
    But I should see "L2000"

