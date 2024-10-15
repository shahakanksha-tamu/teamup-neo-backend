Feature: Student Dashboard - View Team Member and Mentor Information

  As a student
  So that I can contact team members and mentors
  I should be able to view their information on the student dashboard

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |
  | Mariam           | Webster          | mariam@gmail.com          |  student      |  google_oauth2 |
  | David            | Jones            | davidjones@gmail.com      |  admin        |  google_oauth2 |
  | Josie            | Mathew           | josie@gmail.com           |  admin        |  google_oauth2 |
  
 
Scenario: Access team member information page as student
  Given I login as "johndoe@gmail.com"
  And   I visit team information page
  Then  I should see mentor information
  And   I should see team members information for project

Scenario: Access team member information page as admin
  Given I login as "davidjones@gmail.com"
  And   I visit team information page
  Then  I should be on the dashboard page
  And   I should see "You are not authorized to access this page"
