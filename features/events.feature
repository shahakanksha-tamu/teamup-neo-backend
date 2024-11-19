Feature: Events Management
    As a project manager
    I want to manage events
    So that I broadcast events to all student users

    Background: users in database

    Given the following users exist
    | first_name       | last_name        | email                     |  role         |  contact   |  provider       |
    | John             | Doe              | johndoe@gmail.com         |  student      |  234765456 |  google_oauth2  |
    | Mariam           | Webster          | mariam@gmail.com          |  student      |  123645778 |  google_oauth2  |
    | Denver           | Kane             | denverkane@gmail.com      |  student      |  123645778 |  google_oauth2  |
    | David            | Jones            | davidjones@gmail.com      |  admin        |  567323423 |  google_oauth2  |
    | Josie            | Mathew           | josie@gmail.com           |  admin        |  214435356 |  google_oauth2  |

    And the following project exists in the database
    | id | name               | description                    | objectives                    | start_date | end_date|
    | 1  | "Project Alpha"    | "Main project description"     | "Objective 1, Objective 2"    | 2024-10-01 12:00:00 | 2025-10-01 12:00:00 |

    And the given student assignments exist
    | user_email             | project_name       |
    | johndoe@gmail.com      | "Project Alpha"   |
    | mariam@gmail.com       | "Project Alpha"   |

    And the following milestones exist in the database
    | project_id | title           | objective                       | deadline            | 
    | 1          | "Milestone 1"   | "Complete initial setup"        | 2024-12-01 10:00:00 | 
    | 1          | "Milestone 2"   | "Develop core features"         | 2025-01-15 12:00:00 | 
    | 1          | "Milestone 3"   | "Conduct testing and review"    | 2025-02-20 15:00:00 | 

    And the following tasks exist in the database
    | milestone_id | task_name         | description           | status        | deadline            |
    | 1            | "Task 1"          | "First task example"  | Not Completed | 2024-10-30 12:00:00 | 
    | 1            | "Task 2"          | "Second task example" | Completed     | 2024-11-05 12:00:00 | 
    | 1            | "Task 3"          | "Third task example"  | Not Completed       | 2024-11-10 12:00:00 | 

    And the following events exist in the database
    | id | title               | description                | show |
    | 1  | "Kickoff Meeting"   | "Initial project meeting"  | true |
    | 2  | "Sprint Review"     | "Review of sprint progress" | false |
    | 3  | "Final Presentation" | "Project final presentation" | false |
   
   @javascript
    Scenario: Student sees event without event in session
        Given I am logged in as "johndoe@gmail.com"
        And the session does not include an event
        When I visit the Project Hub
        Then I should see the "Kickoff Meeting" event

    @javascript
    Scenario: Student does not see event in session
        Given I am logged in as "johndoe@gmail.com"
        And the session includes the event
        When I visit the Project Hub
        Then I should not see the "Kickoff Meeting" event

    Scenario: Admin creates an event with show defaulted to true
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        When I fill in "Title" with "Planning Session"
        And I fill in "Description" with "Project planning meeting"
        And I click "Create Event"
        Then I should see "Event was successfully created."
        And I should see "Planning Session" in the list of events
        And "Planning Session" should be broadcasted

    Scenario: Admin edits an event with show set to true by default
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        And I see the event "Kickoff Meeting"
        When I click the "Edit" button for the event "Kickoff Meeting"
        And I fill in "Title" with "Kickoff Meeting Updated"
        And I fill in "Description" with "Updated project meeting description"
        And I click "Update Event"
        Then I should see "Event was successfully updated."
        And I should see "Kickoff Meeting Updated" in the list of events
        And "Kickoff Meeting Updated" should be broadcasted

    @javascript
    Scenario: Admin deletes an event
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        And I see the event "Sprint Review"
        When I click the "Delete" button for the event "Sprint Review"
        And I confirm the deletion
        Then I should not see "Sprint Review" in the list of events

    @javascript
    Scenario: Admin broadcasts an event by toggling show to true
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        And I see the event "Final Presentation" with show set to "false"
        When I toggle the broadcast checkbox for the event "Final Presentation" to true
        Then I should see "Event was successfully broadcasted."
        And "Final Presentation" should be broadcasted
        And "Kickoff Meeting" should not be broadcasted

    @javascript
    Scenario: Admin stops broadcasting an event by toggling show to false
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        And I see the event "Kickoff Meeting" with show set to "true"
        When I toggle the broadcast checkbox for the event "Kickoff Meeting" to false
        Then I should see "Broadcasting was turned off for this event."
        And "Kickoff Meeting" should not be broadcasted

    Scenario: Admin fails to update an event due to missing required fields
        Given I am logged in as "davidjones@gmail.com"
        And I visit the Events page
        And I see the event "Kickoff Meeting"
        When I click the "Edit" button for the event "Kickoff Meeting"
        And I attempt to update the event with invalid data
        Then I should see "Failed to update event"
        And I should still see "Kickoff Meeting" in the list of events

