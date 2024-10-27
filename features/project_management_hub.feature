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

Scenario: Adding a student to the project but saving fails
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And An unknown error would occur when adding the student
  And I click the "Add Student" button
  Then I should see "Failed to add student to the team."

Scenario: Adding a student already in the project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  Then I should see "janesmith@gmail.com is already assigned to a project."

Scenario: Remove a student from the project
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."
  When I click on the remove button for "student1@mail.com"
  Then I should see the removal success message "janesmith@gmail.com was successfully removed from the team."

Scenario: Remove a student from the project but removing fails
  Given I am logged in as 'johndoe@gmail.com'
  And I navigate to the project management page for "Alpha Project"
  And I click on the Team Management
  When I click on the student dropdown
  And I select "janesmith@gmail.com" from the student dropdown
  And I click the "Add Student" button
  Then I should see a success message "janesmith@gmail.com was successfully added to the team."
  And an unknown error would occur when removing the student
  When I click on the remove button for "student1@mail.com"
  Then I should see "Failed to remove janesmith@gmail.com from the team."

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