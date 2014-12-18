Feature: Adding a Patient

    We should be able to add patients.

    Scenario: Adding a patient as a Technician
        Given I'm on the home page
        And I'm logged in as a "tech"
        Then the "Add Patient" link should be visible.