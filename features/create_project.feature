Feature: Create Project


Background: users in database

  Given the following users exist
  | first_name | last_name        | email                     |  role       |  provider      |
  | Jane       | Doe              | janedoe@gmail.com         |  admin      |  google_oauth2 |  
  | Jane       | Smith            | janesmith@gmail.com       | student     | google_oauth2  |

  Scenario: Successfully creating a project with valid attributes
    Given the admin is logged in with "janedoe@gmail.com"
    Given I have valid project attributes
    When I fill in the form
    And I submit
    Then I should see a success message

  Scenario: Failing to create a project due to invalid date
    Given the admin is logged in with "janedoe@gmail.com"
    Given I have valid project attributes with an invalid date
    When I fill in the form
    And I submit
    Then I should see an error message

  Scenario: Failing to create a project due to invalid user
    Given the admin is logged in with "janedoe@gmail.com"
    Given I have valid project attributes
    When I fill in the form
    Given I delete the selected user
    When I submit
    Then I should see an error message