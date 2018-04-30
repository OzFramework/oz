
Feature: Test the content on each of the account pages


  Scenario: Static text on the Sign In Page
    Given I am on the Sign In Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the Create Account Page
    Given I am on the Create Account Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the Create Account Page with page filled
    Given I am on the Create Account Page
    When I fill the page with Data
    Then I can see that all the content on the page is correct


  Scenario: Static text on the My Account Page
    Given I am on the My Account Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the Order History Page
    Given I am on the Order History Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the Credit Slips Page
    Given I am on the Credit Slips Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the My Addresses Page
    Given I am on the My Addresses Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the Personal Information Page
    Given I am on the Personal Information Page
    Then I can see that all the content on the page is correct


  Scenario: Static text on the My Wishlists Page
    Given I am on the My Wishlists Page
    Then I can see that all the content on the page is correct


