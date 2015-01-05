Feature: Adding a Patient

    We should be able to add patients.

    Scenario: Adding a patient as a Technician
        Given I'm on the home page
        And I'm logged in as a "tech"
        And the "Add Patient" link is visible
        When I click on the "Add Patient" link
        And enter and submit a test patient
        Then an alert with "Successfully added patient. Patient code:" should be displayed

    Scenario: Adding a patient as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Add Patient" link is visible
        When I click on the "Add Patient" link
        And enter and submit a test patient
        Then an alert with "Successfully added patient. Patient code:" should be displayed