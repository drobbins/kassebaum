Feature: Access Logging

    Admins should be able to view a log of all system accesses

   Scenario: Viewing access logs is forbidden to Technicians
        Given I'm on the home page
        And I'm logged in as a "tech"
        Then the "Logs" link is not visible

    Scenario: Viewing access logs as an Admin
        Given I'm on the home page
        And I'm logged in as an "admin"
        And the "Logs" link is visible
        And there are 3 log entries
        When I click on the "Logs" link
        Then I should see a list of the "5" existing log entries # Browsing to Logs adds two entries
