Feature: Viewing Project Timeline
  As a user
  I want to view the project timeline with milestones
  So that I can understand the project’s schedule

  Scenario: Viewing the Project Timeline
    Given I am a logged-in user with an assigned project
    When I navigate to the project timeline page
    Then I should see a Gantt chart displaying project milestones

  Scenario: Expanding Gantt Chart to View Details
    Given I am on the project timeline page
    When I expand a milestone on the Gantt chart
    Then I should see detailed information for that milestone
