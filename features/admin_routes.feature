Feature: Admin_Role_Restriction

    As an admin 
    I should be able to access specific pages

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | Jane             | Doe              | janedoe@gmail.com         |  admin      |  google_oauth2 |  

Scenario: Admin accesses dashboard
    Given the admin is logged in with "janedoe@gmail.com"
    When the admin navigates to the project_management_hub
    Then the admin should be directed to the project_management_hub
    And  the admin should see "Get Stated. Create a New Project."

Scenario: Student accesses settings
    Given the admin is logged in with "janedoe@gmail.com"
    When the admin navigates to the settings
    Then the admin should be directed to the settings


Scenario: Student accesses project hub
    Given the admin is logged in with "janedoe@gmail.com"
    When the admin navigates to the project_hub
    Then the admin should be directed to the project_management_hub


Scenario: Student accesses project management hub
    Given the admin is logged in with "janedoe@gmail.com"
    When the admin navigates to the project_management_hub
    Then the admin should be directed to the project_management_hub


Scenario: Student accesses an unknown route
    Given the admin is logged in with "janedoe@gmail.com"
    When the admin navigates to the unknown_route
    Then the admin should see the 404 page