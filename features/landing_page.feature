Feature: Landing Page
  As a visitor,
  I want to see the landing page,
  So that I can understand the purpose of the application.

  Scenario: Visit the landing page
    Given I am a visitor
    When I visit the landing page
    And I should see a heading "Welcome to NEO"
