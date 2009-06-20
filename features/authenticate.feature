Feature: Authentication
  As a user of the system
  I want to log in
  So that I can do work

  Background:
    Given a user "bob smith" with login "bob" and password "secret"

  Scenario: Login Correctly
    When I enter login "bob" and password "secret"
    And I press "Log in"
    Then I should not see "Your user name or password is incorrect"
    And I should see "bob smith"

  Scenario: Wrong Password
    When I enter login "bob" and password "incorrect"
    And I press "Log in"
    Then I should see "Your user name or password is incorrect"

  Scenario: Wrong Username
    When I enter login "notbob" and password "secret"
    And I press "Log in"
    Then I should see "Your user name or password is incorrect"

  Scenario: Logging out
    When I enter login "bob" and password "secret"
    And I press "Log in"
    And I follow "Logout"
    Then I should see "Login"
    And I should see "Password"
