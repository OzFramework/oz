

Given /^I have (.*)$/ do |target|
  set_data_target(target.gsub(' ', '_').upcase)
end

Given /^I am on the (.*?) Page(?: by way of the (.*?) Page)?$/ do |target_page, intermediate_page|
    @root_page.begin_new_session
    proceed_to(CoreUtils.find_class(intermediate_page+' Page')) if intermediate_page
    proceed_to(CoreUtils.find_class(target_page+' Page'))
    set_data_target
end



When /^I (?:proceed|go back) to the (.*?) Page(?: by way of the (.*?) Page)?$/ do |target_page, intermediate_page|
    proceed_to(CoreUtils.find_class(intermediate_page+' Page')) if intermediate_page
    proceed_to(CoreUtils.find_class(target_page+' Page'))
    set_data_target
end

When /^I fill the page with (.*)$/ do |data_name|
    @current_page.fill(data_name)
end

When /^I click the (.*)$/ do |element_name|
  @current_page.click_on(element_name.gsub(' ','_').downcase.to_sym)
end

When /^I hover over the (.*)$/ do |element_name|
  @current_page.hover_over(element_name.gsub(' ','_').downcase.to_sym)
end