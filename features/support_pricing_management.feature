Feature: Maintain pricing information
  As a pricing manager
  I want to add support prices
  To allow quoters to retrieve accurate and timely price and description data

  Background:
    Given I am logged in as a "pricing_manager"
    And the product lines are populated

  Scenario: Add a HW support price
    Given I follow "HW Support Add"
    When I fill in "Product Number" with "A6144A"
    And I fill in "Description" with "L3000 Server"
    And I select "HP | Proliant" from "Product Line"
    And I fill in "List Price" with "100.00"
    And I press "Create"
    Then I should see "The price was saved successfully."
    And I should see the HW support price add form

  Scenario: Add a SW support price
    Given I follow "SW Support Add"
    When I fill in "Product Number" with "A6144A"
    And I fill in "Description" with "L3000 Server"
    And I select "HP | Proliant" from "Product Line"
    And I fill in "Phone Price" with "100.00"
    And I fill in "Update Price" with "100.00"
    And I press "Create"
    Then I should see "The price was saved successfully."
    And I should see the SW support price add form

