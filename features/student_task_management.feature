Feature: Student Task Management

  As a student
  So that I can manage my tasks
  I should be able to view list of tasks assigned to me and view progress graph


Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  contact   |  provider       |
  | John             | Doe              | johndoe@gmail.com         |  student      |  234765456 |  google_oauth2  |
  | Mariam           | Webster          | mariam@gmail.com          |  student      |  123645778 |  google_oauth2  |

  And the given projects exists in the database
  | name                  |
  | Capstone Project      |

  And the given student assignments exist
  | user_email             | project_name       |
  | johndoe@gmail.com      | Capstone Project   |
  | mariam@gmail.com       | Capstone Project   |

  And the following milestones exist for "Capstone Project"
    | title       | objective               | deadline          | status      | 
    | Milestone 1 | Milestone 1 objectives  | 2024-12-12 10:00  | In-Progress | 
  
  And the following tasks exist for "Milestone 1"
    | name   | status | description | deadline |
    | Task 1 | Not Started | Task 1 description | 2024-12-12 10:00 |
    | Task 2 | In-Progress | Task 2 description | 2024-12-12 10:00 |
    | Task 3 | Not Started | Task 3 description | 2024-12-12 10:00 |

  And the following task assignments exists
    | user_email        | task_name |
    | johndoe@gmail.com | Task 1    |
    | johndoe@gmail.com | Task 2    |
    | mariam@gmail.com  | Task 3    |
 
Scenario: View the list of tasks assigned to a student
  Given I am logged in as "johndoe@gmail.com"
  Then  I visit task management page for "Capstone Project" project for Student "johndoe@gmail.com" 
  Then I should see a list of tasks "[Task 1, Task 2]"
  And I should not see the task "Task 3"

Scenario: View project hub
  Given I am logged in as "johndoe@gmail.com"
  Then  I visit project hub page
  Then I should see "Project Hub"

@javascript
Scenario: Update task status
  Given I am logged in as "johndoe@gmail.com"
  Then  I visit task management page for "Capstone Project" project for Student "johndoe@gmail.com" 
  When  I click on the "Task 1" title
  Then  I should see the details of task "Task 1"
  And   I change the status of the "Task 1" to "Completed"
  Then  the status of task "Task 1" should be "Completed"


