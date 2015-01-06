Feature: Listing Patients

    Admin's should be able to view a list of patients.

    Scenario: Listing patients is forbidden to Technicians
        Given I'm on the home page
        And I'm logged in as a "tech"
        Then the "Patients" link is not visible

    Scenario: Listing patients as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Patients" link is visible
        # When I temp on the "Patients" link
        When I click on the "Patients" link
        Then I should see a list of the existing patients