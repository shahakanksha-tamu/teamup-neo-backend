Feature: Viewing Project Timeline
  As a user
  I want to view the project timeline with milestones
  So that I can understand the project’s schedule

  Scenario: Viewing the Project Timeline
    Given I am a logged-in user with an assigned project
    When I navigate to the project timeline page

  Scenario: Expanding Gantt Chart to View Details
    Given I am on the project timeline page
