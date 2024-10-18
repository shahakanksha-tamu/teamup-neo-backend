Feature: Student Dashboard - View Team Member and Mentor Information

  As a student
  So that I can contact team members and mentors
  I should be able to view their information on the student dashboard

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  contact   |  provider       |
  | John             | Doe              | johndoe@gmail.com         |  student      |  234765456 |  google_oauth2  |
  | Mariam           | Webster          | mariam@gmail.com          |  student      |  123645778 |  google_oauth2  |
  | Denver           | Kane             | denverkane@gmail.com      |  student      |  123645778 |  google_oauth2  |
  | David            | Jones            | davidjones@gmail.com      |  admin        |  567323423 |  google_oauth2  |
  | Josie            | Mathew           | josie@gmail.com           |  admin        |  214435356 |  google_oauth2  |

  And the following projects exist
  | name                  |
  | Capstone Project      |

  And the following student assignments exist
  | user_email             | project_name       |
  | johndoe@gmail.com      | Capstone Project   |
  | mariam@gmail.com       | Capstone Project   |

 
Scenario: Access team member information page as student
  Given I am logged in as "johndoe@gmail.com"
  When  I visit team information page
  Then  I should see mentor information
  And   I should other team members information for project "Capstone Project" and not contact information for "johndoe@gmail.com"

Scenario: Access team member information page as admin
  Given I am logged in as "josie@gmail.com"
  When  I visit team information page as admin
  Then  I should be on the admin dashboard page
  And   I should see "You are not authorized to access this page"

Scenario: Student has no project assignment
  Given  I am logged in as "denverkane@gmail.com"
  When   I visit team information page
  Then   I should see "You have a pending project assignment, no team information is available. Please check again later"



