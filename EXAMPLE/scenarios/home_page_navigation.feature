
Feature: Test navigation on the Home Page


  Scenario: Navigating to the Casual Dresses page using the Dresses menu
    Given I am on the Home Page
    And I hover over the Dresses Button
    When I click the Casual Dresses Button
    Then I should see the Casual Dresses Page


  Scenario: Navigate from the Home Page to the Sign In Page
    Given I am on the Home Page
    When I click the Sign In button
    Then I should see the Sign In Page