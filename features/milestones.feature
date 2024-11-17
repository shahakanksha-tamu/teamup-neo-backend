Feature: Milestones Management
    As a project manager
    I want to manage the milestones
    So that I can add and removes tasks from the milestones

    Background: users in database

    Given the following users exist
    | first_name       | last_name        | email                     |  role         |  contact   |  provider       |
    | John             | Doe              | johndoe@gmail.com         |  student      |  234765456 |  google_oauth2  |
    | Mariam           | Webster          | mariam@gmail.com          |  student      |  123645778 |  google_oauth2  |
    | Denver           | Kane             | denverkane@gmail.com      |  student      |  123645778 |  google_oauth2  |
    | David            | Jones            | davidjones@gmail.com      |  admin        |  567323423 |  google_oauth2  |
    | Josie            | Mathew           | josie@gmail.com           |  admin        |  214435356 |  google_oauth2  |

    And the following project exists in the database
    | id | name               | description                    | objectives                    |  start_date  |  end_date  | 
    | 1  | "Project Alpha"    | "Main project description"     | "Objective 1, Objective 2"    |  2024-10-01 10:00:00 |  2025-02-28 10:00:00 |

    And the given student assignments exist
    | user_email             | project_name       |
    | johndoe@gmail.com      | "Project Alpha"   |
    | mariam@gmail.com       | "Project Alpha"   |

    
    And the following milestones exist in the database
    | project_id | title           | objective                       | deadline            | start_date          |
    | 1          | "Milestone 1"   | "Complete initial setup"        | 2024-12-01 10:00:00 | 2024-10-01 12:00:00 |
    | 1          | "Milestone 2"   | "Develop core features"         | 2025-01-15 12:00:00 | 2024-11-01 12:00:00 |
    | 1          | "Milestone 3"   | "Conduct testing and review"    | 2025-02-20 15:00:00 | 2025-01-15 12:00:00 |


    And the following tasks exist in the database
    | milestone_id | task_name         | description           | status        | deadline            |
    | 1            | "Task 1"          | "First task example"  | Not Completed | 2024-10-30 12:00:00 | 
    | 1            | "Task 2"          | "Second task example" | Completed     | 2024-11-05 12:00:00 | 
    | 1            | "Task 3"          | "Third task example"  | Not Completed | 2024-11-10 12:00:00 | 

    
    Scenario: View all the Milestones for a Project
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        Then I should see a card for each milestone

    Scenario: Create a new milestone
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        Then I should see "Create a New Milestone"
        When I create a new milestone with the title "Project Kickoff", objective "Initial meeting and setup", and deadline "2025-12-01 10:00:00"

    Scenario: Edit an existing milestone
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        And I see a milestone with the title "Milestone 1" and objective "Complete initial setup"
        When I click the edit button for the milestone "Milestone 1"
        Then I should see "Edit Milestone" 
        And the title field should contain "\"Milestone 1\""
        And the objective field should contain "\"Complete initial setup\""
        And the deadline field should be set to "2024-12-01"
        When I update the objective to "Revised initial meeting and setup"
        And I click "Update Milestone"
        Then I should see the milestone "Milestone 1" with objective "Revised initial meeting and setup" in the list of milestones

    @javascript
    Scenario: Delete an existing milestone
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        And I see a milestone with the title "Milestone 1"
        When I click the delete button for the milestone "Milestone 1"
        Then I should not see "Milestone 1" in the list of milestones

    Scenario: User updates the milestone status
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        And I see a milestone with the title "Milestone 1"
        When I click the update status button for the milestone "Milestone 1"
        And I select "In-Progress" from the status dropdown
        And I click "Update Status" in the modal
        Then I should see the status "In-Progress" displayed for "Milestone 1"


    Scenario: User opens the update status modal and closes it without updating
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        And I see a milestone with the title "Milestone 1"
        When I click the update status button for the milestone "Milestone 1"
        And I close the modal
        Then I should see "Milestone Management"

    Scenario: User views tasks for a milestone
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        When I click the show tasks button for the milestone "Milestone 1"
        Then I should see the task "Task 1" with status "Not Completed"
        And I should see the task "Task 2" with status "Completed"
        And I should see the task "Task 3" with status "Not Completed"
    
    Scenario: Admin fails to create a milestone with a deadline less than a week from now
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        Then I should see "Create a New Milestone"
        When I set the milestone deadline to less than a week from now with the rest of the valid inputs
        And I click "Create Milestone"
        Then I should see "Deadline must be at least one week from now."
        And I should not see "Test Milestone" in the list of milestones

    Scenario: Admin fails to create a milestone due to a save failure
        Given I am logged in as "davidjones@gmail.com"
        When I visit the Milestone Management Page
        Then I should see "Create a New Milestone"
        When I attempt to create a invalid milestone with the title "Failing Milestone", objective "This milestone will fail to save", and deadline "2025-12-01"
        Then I should see "Failed to create milestone."
        And I should not see "Failing Milestone" in the list of milestones

