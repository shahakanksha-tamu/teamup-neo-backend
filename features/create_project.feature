Feature: Create Project


Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | Jane             | Doe              | janedoe@gmail.com         |  admin      |  google_oauth2 |  

  Scenario: Successfully creating a project with valid attributes
    Given the admin is logged in with "janedoe@gmail.com"
    Given I have valid project attributes
    When I create a new project
    ## Then I should see the project in the project list
    Then I should see a success message

  Scenario: Failing to create a project due to invalid date
    Given the admin is logged in with "janedoe@gmail.com"
    Given I have valid project attributes with an invalid date
    When I create a new project
    ## Then I should not see the project in the project list
    Then I should see an error message