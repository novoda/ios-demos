Feature: As a user, I want to fill in my details and successfully finish my order

Scenario: User is taken to success screen after pressing buy now button
    Given user launches the application
    When user fills in all the text fields
    And user presses buy now button
    Then user is taken on the success screen

Scenario: User is taken back to Form screen after pressing success button on success screen
    Given user launches the application
    When user fills in all the text fields
    And user presses buy now button
    Then user is taken on the success screen
    When user presses success button
    Then user is on the form screen

