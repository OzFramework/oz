
Feature: Test feature for the OZ framework

  Scenario: Static text on the Home Page
    Given I am on the Home Page
    And I can see that all the content on the page is correct

  Scenario: Static text on the Dresses Page
    Given I am on the Dresses Page
    And I can see that all the content on the page is correct

  Scenario: Static text on the Casual Dresses Page
    Given I am on the Casual Dresses Page
    And I can see that all the content on the page is correct
    And I proceed to the Home Page

  Scenario: Navigate back to the home page from the Casual Dresses Page
    Given I am on the Casual Dresses Page
    When I proceed to the Home Page
    Then I can see that all the content on the page is correct

  Scenario: Navigate back to the home page from the Casual Dresses Page
    Given I am on the Casual Dresses Page
    When I click the banner home button
    Then I should see the Home Page