Feature: Viewing Milestones
  As a user
  I want to view and filter project milestones
  So that I can track my progress effectively

  Scenario: Viewing All Milestones
    Given I am a logged-in user with an assigned project
    When I navigate to the milestones page
    Then I should see a list of all project milestones

  Scenario: Filtering Milestones by Status
    Given I am on the milestones page
    When I select "In-Progress" from the status filter
    Then I should see only milestones that are in-progress
