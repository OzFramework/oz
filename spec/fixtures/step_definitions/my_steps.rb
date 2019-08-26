Given(/^I have (\d+)$/) do |value|
  @value1 = value
end

When(/^I add it to (\d+)$/) do |value|
  @value1 += value
end

Then(/^I should have (\d+)$/) do |value|
  raise 'HOW DO MATH?!' unless @value1 == value
end