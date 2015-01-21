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
        When I click on the "Patients" link
        Then I should see a list of the "3" existing patients

    Scenario: Searching for a patient as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Patients" link is visible
        When I click on the "Patients" link
        And Enter the search term "abcdEF"
        Then I should see a list of the "1" matching patients

    Scenario: Viewing a patient as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Patients" link is visible
        When I click on the "Patients" link
        And I click on the "View" patient link for patient "abcdEF"
        Then I should see the details for patient "abcdEF"

    Scenario: Editing a patient as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Patients" link is visible
        When I click on the "Patients" link
        And I click on the "Edit" patient link for patient "abcdEF"
        And update a field and submit the form
        Then I should see the edit reflected in the patients list