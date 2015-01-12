Feature: Access Logging

    Admins should be able to view a log of all system accesses

   Scenario: Viewing access logs is forbidden to Technicians
        Given I'm on the home page
        And I'm logged in as a "tech"
        Then the "Logs" link is not visible
