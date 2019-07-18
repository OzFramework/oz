Feature: Test
  @tagged
  Scenario: One Plus Two
    Given I have 1
    When I add it to 2
    Then I should have 3