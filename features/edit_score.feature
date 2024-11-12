Feature: Score editing

Background: users in database

    Given the following users exist
    | first_name  | last_name | email               | role      | provider      | score |
    | John        | Doe       | johndoe@gmail.com   | admin     | google_oauth2 |       |
    | Jane        | Smith     | janesmith@gmail.com | student   | google_oauth2 | 100   |
    | Mark        | Lee       | marklee@gmail.com   | student   | google_oauth2 | 95    |

    And the given projects exists in the database
    | name                  |
    | Capstone Project      |

    And the given student assignments exist
    | user_email             | project_name       |
    | janesmith@gmail.com    | Capstone Project   |
    | marklee@gmail.com      | Capstone Project   |

Scenario: Admin edits students' score
    Given the admin is logged in with "johndoe@gmail.com"
    When the admin visits the score page of "Capstone Project"
    When the admin changes score for "Jane Smith"
    And I should see "Score updated successfully!"
