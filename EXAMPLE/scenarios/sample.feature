
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


  Scenario: Navigate back to the home page from the Casual Dresses Page
    Given I am on the Casual Dresses Page
    When I go back to the Home Page
    Then I can see that all the content on the page is correct


  Scenario: Navigate back to the home page from the Casual Dresses Page
    Given I am on the Casual Dresses Page
    When I click the your logo button
    Then I should see the Home Page


  Scenario: Navigate to the Sign In Page from the Home Page
    Given I am on the Home Page
    When I click the Sign In button
    Then I should see the Sign In Page


  Scenario: Static text to the Sign In Page
    Given I am on the Sign In Page
    Then I can see that all the content on the page is correct


  Scenario: Static text to the Account Page
    Given I am on the Account Page
    Then I can see that all the content on the page is correct


  Scenario: Static text to the Account Page
    Given I am on the Create Account Page
    Then I can see that all the content on the page is correct


  Scenario: Static text to the Account Page
    Given I am on the Create Account Page
    When I fill the page with Data
    Then I can see that all the content on the page is correct


  Scenario: Static text on the My Account Page
    Given I am on the My Account Page
    Then I can see that all the content on the page is correct


  Scenario Outline: Navigation on the My Account Page
    Given I am on the My Account Page
    Then I click the <account option>

  Examples:
    | account option                 |
    | order history button           |
    | my credit slips button         |
    | my addresses button            |
    | my personal information button |
    | my wishlists button            |
