Feature: Dashboard view

Background: users in database

    Given the following users exist
    | first_name  | last_name | email             | role      | provider      |
    | John        | Doe       | john@example.com  | student   | google_oauth2 |

    And the following projects exist
    | name        | description             | status    | objectives            |
    | Project A   | Project A description   | active    | Project A objectives  |
    | Project B   | Project B description   | inactive  | Project B objectives  |

    And the following student assignments exist for "john@example.com"
    | project_name  |
    | Project A     |

    And the following milestones exist for "Project A"
    | title       | objective               | deadline          |
    | Milestone 1 | Milestone 1 objectives  | 2024-12-01 10:00  |
    | Milestone 2 | Milestone 2 objectives  | 2025-01-15 10:00  |

Scenario: Student accesses project hub
    Given the student is logged in with "john@example.com"
    When the student navigates to the dashboard
    Then the student should be directed to the dashboard
    And I should see "Project A"
    And I should see "Project A description"
    And I should see "Project A objectives"
    And I should see "Milestone 1 objectives"
    And I should see "Milestone 2 objectives"