Feature: Import data

Background: users in database

  Given the following users exist
  | first_name       | last_name        | email                     |  role         |  provider      |
  | John             | Doe              | johndoe@gmail.com         |  student      |  google_oauth2 |
  | John             | Doe              | johndoeadmn@gmail.com     |  admin        |  google_oauth2 |

Scenario: Import Data
    Given I am logged in as "johndoeadmn@gmail.com"
    When I choose "Import Data" button from profile dropdown
    Then I should be on the import data page
    And I should see "Import Data"

Scenario: upload file with incorrect headers
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    And I attach "./spec/fixtures/files/invalid_headers.xlsx" to "fileUpload"
    Then I click upload button
    Then I should see "File has missing required columns"

Scenario: upload csv file with missing data
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    And I attach "./spec/fixtures/files/missing_data.csv" to "fileUpload"
    Then I click upload button
    Then I should see "missing required data"

Scenario: upload excel file with missing data
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    And I attach "./spec/fixtures/files/missing_data.xlsx" to "fileUpload"
    Then I click upload button
    Then I should see "missing required data"

Scenario: upload file with sample data
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    And I attach "./spec/fixtures/files/sample_data.xlsx" to "fileUpload"
    Then I click upload button
    Then I should see "File uploaded and data imported successfully!"

Scenario: upload corrupted file
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    And I attach "./spec/fixtures/files/sample.xlsx" to "fileUpload"
    Then I click upload button
    Then I should see "An error occurred while processing the file"

Scenario: delete the data
    Given I am logged in as "johndoeadmn@gmail.com"
    Then I visit import data page
    Then I click on the delete button
    Then I should see "All the records have been deleted successfully"

