Feature: Score editing

Background: users in database

    Given the following users exist
    | first_name  | last_name | email               | role      | provider      | score |
    | John        | Doe       | johndoe@gmail.com   | admin     | google_oauth2 |       |
    | Jane        | Smith     | janesmith@gmail.com | student   | google_oauth2 | 100   |
    | Mark        | Lee       | marklee@gmail.com   | student   | google_oauth2 | 95    |

Scenario: Admin edits students' score
    Given the admin is logged in with "johndoe@gmail.com"
    When the admin visits the edit score page
    When I change score for "Jane"
    And I press "Update Scores"
    And I should see "Scores updated successfully."
