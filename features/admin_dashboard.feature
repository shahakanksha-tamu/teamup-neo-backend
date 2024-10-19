Feature: Admin Dashboard

Background: users in database

    Given the following users exist
    | first_name  | last_name | email             | role      | provider      |
    | John        | Doe       | john@example.com  | admin   | google_oauth2 |

    And the following projects exist
    | name        | description             | status    | objectives            |
    | Project A   | Project A description   | active    | Project A objectives  |
    | Project B   | Project B description   | inactive  | Project B objectives  |

Scenario: Admin accesses project management hub 
    Given the admin is logged in with "john@example.com"
    When the admin navigates to the project_management_hub
    Then the admin should be directed to the project_management_hub
    And  the admin should see "Project A"
    And the admin should see "Project B"
    