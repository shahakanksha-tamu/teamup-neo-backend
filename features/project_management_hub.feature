Feature: Project Management Hub
  As a project manager
  I want to manage the project team
  So that I can add and remove students from the project team

Background: users and projects in database
  Given the following users exist
    | first_name | last_name | email               | role   | provider      |
    | John       | Doe       | johndoe@gmail.com   | admin  | google_oauth2 |
    | Jane       | Smith     | janesmith@gmail.com | student| google_oauth2 |
    | Mark       | Lee       | marklee@gmail.com   | student| google_oauth2 |
  And the following projects exist
    | name              |
    | Alpha Project      |
  And I am already registered to Neo application with email "johndoe@gmail.com"
  And I visit landing page

Scenario: login using google account
  When I press Login with Google and choose "johndoe@gmail.com" as my google account for authentication
  Then I should be signed in as "johndoe@gmail.com"
  And I should see "Logout" button

Scenario: Accessing the team management page as a logged-in user
  Given I am already registered to Neo application with email "johndoe@gmail.com"
  When I press Login with Google and choose "johndoe@gmail.com" as my google account for authentication
  And I navigate to the project management page for "Alpha Project"
  Then I shouldd see "Team Members"


Scenario: Adding a student to the project
 Given I am already registered to Neo application with email "johndoe@gmail.com"
 When I press Login with Google and choose "johndoe@gmail.com" as my google account for authentication
 And I navigate to the project management page for "Alpha Project"
When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
