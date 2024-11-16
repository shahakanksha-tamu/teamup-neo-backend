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
    | name              | status |
    | Alpha Project      | active|

Scenario: Accessing the project dashboard page as a logged-in user
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  Then I shouldd see "Team Management"
  And I should see "Resource Management"

Scenario: Accessing the Team Management page as a logged-in user
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  Then I should see "Team Management"
  And I click on the Team Management
  Then I should see "Team Members"

Scenario: Adding a student to the project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."

Scenario: Trying to add a student already assigned to a project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  And I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  When I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."
  And I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  When I click the "Add Student" button
  Then I should see the error message "janesmith@gmail.com is already assigned to a project."
Scenario: Remove a student from the project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."
  When I click on the remove button for "first_student@mail.com"
  Then I should see the removal success message "janesmith@gmail.com was successfully removed from the team."

Scenario: Trying to add a student already assigned to a project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  And I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  When I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."
  # Attempting to add the same student again should trigger an error
  And I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  When I click the "Add Student" button
  Then I should see the error message "janesmith@gmail.com is already assigned to a project."

Scenario: Accessing the Resource Management page as a logged-in user
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  Then I should see "Resource Management"
  And I click on the Resource Management
  Then I should see "Resources"

Scenario: Successful creation of a resource
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Resource Management
  Given I fill in "Name" with "Sample Resource"
  And I attach the file "sample.txt" to "File"
  When I click Create Resource
  Then I should be redirected to the resources page for "Alpha Project"
  And I should see "Resource was successfully created."
  And I should see "Sample"

Scenario: Successful delete a resource
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Resource Management
  Given I fill in "Name" with "Sample Resource"
  And I attach the file "sample.txt" to "File"
  When I click Create Resource
  Then I should be redirected to the resources page for "Alpha Project"
  And I should see "Resource was successfully created."
  And I should see "Sample"
  When I click on the remove button for file "Sample Resource"
  Then I should not see "Sample Resource"

Scenario: Create a resource but saving fails
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Resource Management
  Given I fill in "Name" with "Sample Resource"
  And I attach the file "sample.txt" to "File"
  When An unknown error would occur when creating the resource
  And I click Create Resource
  And I should not see "Resource was successfully created."

  Scenario: Successfully updating a project from the dashboard
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  When I click on the Edit Project button
  Then I should see the Edit Project modal
  When I fill in the Edit Project form with the following:
    | Name        | Updated Alpha Project |
    | Description | Updated description   |
    | Objectives  | Updated objectives    |
    | Status      | Active                |
  And I click Update Project
  Then the project should be updated successfully
  Then the progress chart should show 0% complete

  Scenario: Project update failure due to invalid data
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  When I click on the Edit Project button
  Then I should see the Edit Project modal
  When I fill in the Edit Project form with the following invalid:
    | Name        |            |  # Intentionally leave the name blank to trigger an error
    | Description | Updated description   |
    | Objectives  | Updated objectives    |
    | Status      | Active                |
  And I click Update Projectt
  Then I should see an error message "Name can't be blank"
