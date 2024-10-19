Feature: Logout

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |

Scenario: successfully log out after logged in
    Given I am logged in as user
    | first_name       | last_name        | email                     |  role         |  provider      |
    | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |
    When I choose "Logout" button from profile dropdown
    Then I should be on the landing page
    And I should see "You are logged out."

Scenario: try logging out without logging in
    Given I am not logged in
    When I visit "logout" directly
    Then I should see "You must be logged in to access the resource."
    And I should be on the landing page
    And I should see "Login with Google" button 