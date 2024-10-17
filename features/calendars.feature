Feature: Calendar View
  As a user
  I want to view the calendar
  So that I can see my scheduled events

  Scenario: Accessing the calendar view as a logged-in user
    Given I am logged in as a valid user
    When I navigate to the calendar page
    Then I should see the calendar

  Scenario: Attempting to access the calendar view without logging in
    Given I am not logged in
    When I navigate to the calendar page
    Then I should be redirected to the login page
