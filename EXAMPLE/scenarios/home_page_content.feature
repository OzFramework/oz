
Feature: Test the content of the Home Page


  Scenario: Static text on the Home Page
    Given I am on the Home Page
    And I can see that all the content on the page is correct


  Scenario: Hover over Dresses Button on the Home page
    Given I am on the Home Page
    When I hover over the Dresses Button
    Then I can see that all the content on the page is correct

