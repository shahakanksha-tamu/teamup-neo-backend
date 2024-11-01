Feature: Project Hub
    as a student
    I want to access the project resources
    So that I can download and view the resources


Background: users and projects in database
  Given the following users exist
    | first_name | last_name | email               | role   | provider      |
    | John       | Doe       | johndoe@gmail.com   | admin  | google_oauth2 |
    | Jane       | Smith     | janesmith@gmail.com | student| google_oauth2 |
    | Mark       | Lee       | marklee@gmail.com   | student| google_oauth2 |
  And the following projects exist
    | name              | status |
    | Alpha Project      | active|
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  And I navigate to the project management page for "Alpha Project"
  And I click on the Resource Management
  Given I fill in "Name" with "Sample Resource"
  And I attach the file "sample.pdf" to "File"
  When I click Create Resource
  Then I should be redirected to the resources page for "Alpha Project"
  When I choose "Logout" button from profile dropdown
  And I should see "You are logged out."

Scenario: Download a resource
  Given I am logged in as 'janesmith@gmail.com'
  When I click View Project
  And I click "Download" on the resource "Sample Resource"
  Then I should see the file "sample.pdf" downloaded

Scenario: Open a resource to view
  Given I am logged in as 'janesmith@gmail.com'
  When I click View Project
  And I click "Preview" on the resource "Sample Resource"
  Then I should see the file "sample.pdf" opened

Scenario: Open Task Management page
  Given I am logged in as 'janesmith@gmail.com'
  When I click View Project
  And I click Task Management
#   to be replaced with the actual task management page
  Then I should see "Task Management"
