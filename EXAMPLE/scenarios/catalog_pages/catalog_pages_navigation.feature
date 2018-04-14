
Feature: Test navigation on each of the catalog pages


  Scenario: Navigate to the home page from the Casual Dresses Page
    Given I am on the Casual Dresses Page
    When I click the your logo button
    Then I should see the Home Page