Feature: Session Management
  Scenario: User login fails
    Given I am on the login page
    When I try to log in with invalid credentials
    Then I should be redirected to the root path
