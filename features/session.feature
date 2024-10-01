Feature: Session

  As a user
  So that I can't access proetcted resources without login
  I should be redirected to landing page

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |
  
 
Scenario: Access dashboard without login
  Given I visit landing page
  And   I am already registered to Neo application with email "johndoe@gmail.com"
  And   I am not logged in
  When  I visit dashboard page
  Then  I should be on the landing page
  And   I should see "You must be logged in to access the resource."






