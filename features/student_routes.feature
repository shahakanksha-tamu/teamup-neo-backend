Feature: Student_Role_Restriction

    As a student 
    I should be able to access specific pages

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |  

Scenario: Student accesses dashboard
    Given the student is logged in with "johndoe@gmail.com"
    When the student navigates to the dashboard
    Then the student should be directed to the dashboard
    And the studnet should see "user : student" 


Scenario: Student accesses settings
    Given the student is logged in with "johndoe@gmail.com"
    When the student navigates to the settings
    Then the student should be directed to the settings


Scenario: Student accesses project hub
    Given the student is logged in with "johndoe@gmail.com"
    When the student navigates to the project_hub
    Then the student should be directed to the project_hub


Scenario: Student accesses project management hub
    Given the student is logged in with "johndoe@gmail.com"
    When the student navigates to the project_management_hub
    Then the student should be directed to the dashboard


Scenario: Student accesses an unknown route
    Given the student is logged in with "johndoe@gmail.com"
    When the student navigates to the unknown_route
    Then the student should see the 404 page