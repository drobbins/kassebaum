Feature: Listing Patients

    Admin's should be able to view a list of patients.

    Scenario: Listing patients is forbidden to Technicians
        Given I'm on the home page
        And I'm logged in as a "tech"
        Then the "Patients" link is not visible

    # Scenario: Adding a patient as an Admin
    #     Given I'm on the home page
    #     And I'm logged in as an "admin"
    #     And the "Add Patient" link is visible
    #     When I click on the "Add Patient" link
    #     And enter and submit a test patient
    #     Then an alert with "Successfully added patient. Patient code:" should be displayed
    #     And the new patient should appear in the patient list