Feature: Session Management
  Scenario: User fails to logout
    Given I am logged in as a valid user
    When an error occurs during logout
    Then I should be redirected to the dashboard
    And I should see an alert message "Failed to logout: [error message]"

  Scenario: User login fails
    Given I am on the login page
    When I try to log in with invalid credentials
    Then I should be redirected to the root path
