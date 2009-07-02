Feature: Manage Contracts
  As a Contract Admin
  I want to be able to create, edit and delete contracts
  And I want to ensure that certain information is filled in
  In order to maintain the contract information for later retrieval

  Background:
    Given the contract dropdowns are populated
    And I am logged in as a "contract_admin"

  Scenario: Create a contract
    Given I am on the new contracts page
    When I create a new contract
    Then there should be 1 contract
    And I should see a new contract

  Scenario: Edit a contract
    Given I have created a contract
    And I am viewing that contract
    When I follow "Edit"
    And I change a contract detail
    Then I should see the new details
    And I should not see "problem"

  Scenario: Delete a contract
    Given I have created a contract
    And I am viewing that contract
    When I follow "Destroy"
    Then there should be 0 contracts

  Scenario Outline: Try to create an incomplete contract
    Given I am on the new contracts page
    When I create a contract missing "<field>"
    Then I should see "<message>"

    Examples:
    | field           | message                       |
    | account_id      | Account can't be blank        |
    | account_name    | Account name can't be blank   |
    | sales_office    | Sales office can't be blank   |
    | support_office  | Support office can't be blank |
    | sales_rep_id    | Sales rep can't be blank      |
    | said            | Said can't be blank           |
    | sdc_ref         | Sdc ref can't be blank        |
    | payment_terms   | Payment terms can't be blank  |
    | platform        | Platform can't be blank       |
    | start_date      | Start date can't be blank     |
    | end_date        | End date can't be blank       |
    | po_received     | Po received can't be blank    |

  Scenario Outline: Entering incorrect values for fields
    Given I am on the new contracts page
    When I create a contract with "<field>" set to "<value>"
    Then I should see "<message>"

    Examples:
    | field         | value | message                       |
    | revenue       | abc   | Revenue is not a number       |
    | annual_hw_rev | abc   | Annual hw rev is not a number |
    | annual_sw_rev | abc   | Annual sw rev is not a number |
    | annual_sa_rev | abc   | Annual sa rev is not a number |
    | annual_ce_rev | abc   | Annual ce rev is not a number |
    | annual_dr_rev | abc   | Annual dr rev is not a number |

