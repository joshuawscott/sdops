@wip

Feature: Manage Goals/Quotas
  As a Goal Admin
  I want to be able to create, edit and delete goals
  And I want to ensure that certain information is filled in
  In order to maintain the goal information for later retrieval

  Background:
    #Given the goal dropdowns are populated
    Given I am logged in as a "goal_admin"

  Scenario: Create a goal
    Given I am on the new goals page
    When I create a new goal
    Then there should be 1 goal
    And I should see a new goal

  Scenario: Edit a goal
    Given I have created a goal
    And I am viewing that goal
    When I follow "Edit"
    And I change a goal detail
    Then I should see the new details
    And I should not see "problem"

  Scenario: Delete a goal
    Given I have created a goal
    And I am viewing that goal
    When I follow "Destroy"
    Then there should be 0 goals

  Scenario Outline: Try to create an incomplete goal
    Given I am on the new goals page
    When I create a goal missing "<field>"
    Then I should see "<message>"

    Examples:
    | field              | message                          |
    | type               | Type can't be blank              |
    | description        | Description can't be blank       |
    | sales_office       | Sales office can't be blank      |
    | sales_office_name  | Sales office name can't be blank |
    | amount             | Amount can't be blank            |
    | start_date         | Start date can't be blank        |
    | end_date           | End date can't be blank          |
    | periodicity        | Periodicity can't be blank       |

  Scenario Outline: Entering incorrect values for fields
    Given I am on the new goals page
    When I create a goal with "<field>" set to "<value>"
    Then I should see "<message>"

    Examples:
    | field         | value | message                       |
    | amount        | abc   | Amount is not a number        |

