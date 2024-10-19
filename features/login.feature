Feature: Login to Neo application using Google OAuth
  As a user
  So that I can access the dashboard page
  I want to login using my google account

Background: users in database
  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |

Scenario: login using google account
  Given I visit landing page
  Given I am already registered to Neo application with email "johndoe@gmail.com"
  When  I press Login with Google and choose "johndoe@gmail.com" as my google account for authentication
  Then  I should be signed in as "johndoe@gmail.com"

Scenario: login using invalid google account
  Given I visit landing page
  Given I am already registered to Neo application with email "johndoe@gmail.com"
  When  I press Login with Google and choose "johndoe2@gmail.com" as my google account for authentication
  Then  I should be on the landing page
  And   I should see "Login failed."

Scenario: Access landing page after successful login
  Given I visit landing page
  Given I am already registered to Neo application with email "johndoe@gmail.com"
  When  I press Login with Google and choose "johndoe@gmail.com" as my google account for authentication
  Then  I should be on the dashboard page
  When  I visit landing page
  Then  I should be on the dashboard page

Scenario: User does not accept the Google OAuth authentication consent
  Given I visit landing page
  Given I am already registered to Neo application with email "johndoe@gmail.com"
  When  I press "Login with Google"
  And   I cancel the Google OAuth consent
  Then  I should be on the landing page
  And   I should see "Authentication failed"


