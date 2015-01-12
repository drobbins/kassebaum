Feature: User Management

    Adding and Managing Users

    Scenario: Create User Acccount
        Given I'm on the home page
        And I'm not logged in
        When I click on the "Sign in" link
        And I click on the "Create account" link
        And enter and submit a new username and password
        Then I should be logged in as this new user