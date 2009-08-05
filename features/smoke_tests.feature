Feature: Smoke Tests
  This will log in as various roles, and visit pages to check for application errors.
  Except for Cashflow

  Scenario Outline: Admin
    Given I am logged in as a "admin"
    And the contract dropdowns are populated
    And some contracts exist to search on
    When I follow "<link>"
    Then I should still see the menu
    Examples:
    |link|
    |Main Page|
    |Renewals|
    |Contracts|
    |Reports|
    |Dashboard|
    |Customers|
    |New Business|
    |Locations|
    |Spares Requirements|
    |Inventory|
    |Tools|
    |I/O Scan|
    |SW List|
    |Dell Warranty|
    |Dell Configuration|
    |Prices|
    |HW Support Pricing|
    |SW Support Pricing|
    |Admin|
    |Users|
    |Dropdowns|
    |Roles|
    |Import|
    |Upfront Orders|
    |Appgen Orders|
    |Admin Page|
    |Appgen|

  Scenario Outline: Config Admin
    Given I am logged in as a "config_tool_admin"
    When I follow "<link>"
    Then I should still see the menu
    Examples:
    |link|
    |Servers|
    |Blacklists|
    |Whitelists|

  Scenario Outline: Pricing Manager
    Given I am logged in as a "pricing_manager"
    When I follow "<link>"
    Then I should still see the menu
    Examples:
    |link|
    |HW Support Add|
    |SW Support Add|

