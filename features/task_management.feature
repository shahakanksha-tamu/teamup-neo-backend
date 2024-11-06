Feature: Task Board Management
  As a user
  I want to manage tasks assigned to students on a task board
  So that I can view, add, and organize tasks effectively
Background: users in database
  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  contact   |  provider       |
  | John             | Doe              | johndoe@gmail.com         |  student      |  234765456 |  google_oauth2  |
  | Mariam           | Webster          | mariam@gmail.com          |  student      |  123645778 |  google_oauth2  |
  | Denver           | Kane             | denverkane@gmail.com      |  student      |  123645778 |  google_oauth2  |
  | David            | Jones            | davidjones@gmail.com      |  admin        |  567323423 |  google_oauth2  |
  | Josie            | Mathew           | josie@gmail.com           |  admin        |  214435356 |  google_oauth2  |
  
  And the following project exists in the database
  | id | name               | description                    | objectives                    | 
  | 1  | Project Alpha    | Main project description     | Objective 1, Objective 2    | 

  And the given student assignments exist
  | user_email             | project_name       |
  | johndoe@gmail.com      | Project Alpha    |
  | mariam@gmail.com       | Project Alpha   |
  
  And the following milestones exist in the database
  |id | project_id |  title           | objective                      | deadline            | 
  | 1 |  1         | Milestone 1  | Complete initial setup        | 2024-12-01 10:00:00 | 
  | 2 |  1        | Milestone 2   | Develop core features         | 2025-01-15 12:00:00 | 
  | 3 |   1       | Milestone 3   | Conduct testing and review    | 2025-02-20 15:00:00 | 
  And the following tasks exist in the database
  | milestone_id | task_name         | description           | status        | deadline            |
  | 1            | Task 1         | First task example  | Not Started | 2024-10-30 12:00:00 | 
  | 1            | Task 2          | Second task example | Not Started     | 2024-11-05 12:00:00 | 
  | 1            | Task 3          | Third task example  | Not Started   | 2024-11-10 12:00:00 | 

  And there are students with tasks assigned
  | user_email             | task_name  |
  | johndoe@gmail.com      | Task 1   |
  | mariam@gmail.com       | Task 2   |


  Scenario: Viewing the task board
    Given I am logged in as "davidjones@gmail.com"
    When I visit the task board page
    Then I should see a card for each student
    And each card should display the student’s tasks with task details
  
  Scenario: Adding a new task to a student
    Given I am logged in as "davidjones@gmail.com"
    When I visit the task board page
    And I click on "Add Task" for "John"
    And I fill in the task details
      | task_name    | description          | milestone     | deadline    | status       |
      | New Task     | New Description      | Milestone 1   |2024-11-01   | Not Started|
    And I submit the form
    Then I should see the task "New Task" under "John" on the task board

  Scenario: Updating details of a task
    Given I am logged in as "davidjones@gmail.com"
    And there exists a task named "Task 1"
    When I change the task details
      | task_name    | description          | milestone     | deadline    | status       |
      | Updated Task     | New Description      | Milestone 1   |2024-11-06   | Not Completed |
    And I click on "Update Task"
    Then I should see the task "Updated Task" under "John" on the task board  
