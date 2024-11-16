#Feature: Dashboard view

#Background: users in database

  #  Given the following users exist
 #   | first_name  | last_name | email               | role      | provider      | score |
 #   | John        | Doe       | johndoe@gmail.com   | admin     | google_oauth2 |       |
 #   | Jane        | Smith     | janesmith@gmail.com | student   | google_oauth2 | 100   |
 #   | Mark        | Lee       | marklee@gmail.com   | student   | google_oauth2 | 95    |

#Scenario: Admin edits students' score
 #   Given the admin is logged in with "johndoe@gmail.com"
   #  Then I should see "Edit Student Score"
 #   When I change score
#    And I press "Update Scores"
#    And I should see "Scores updated successfully."
