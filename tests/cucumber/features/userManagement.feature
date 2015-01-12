Feature: User Management

    Adding and Managing Users

    Scenario: Create User Acccount
        Given I'm on the home page
        And I'm not logged in
        When I click on the "Sign in" link
        And I click on the "Create account" link
        And enter and submit a new username and password
        Then I should be logged in as this new user

#    Scenario: Adding a patient as an Admin
#        Given I'm on the home page
#        And I'm logged in as an "admin"
#        And the "Add Patient" link is visible
#        When I click on the "Add Patient" link
#        And enter and submit a test patient
#        Then an alert with "Successfully added patient. Patient code:" should be displayed