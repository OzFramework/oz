

Given /^(?:I have|there is a) (.*)$/ do |target|
  set_data_target(target.gsub(' ', '_').upcase)
end

Given /^(?:I am|a user is) on the (.*?) Page(?: by way of the (.*?) Page)?$/ do |target_page, intermediate_page|
    @root_page.begin_new_session
    proceed_to(CoreUtils.find_class(intermediate_page+' Page')) if intermediate_page
    proceed_to(CoreUtils.find_class(target_page+' Page'))
    set_data_target
end

When /^(?:I|the user) (?:proceed(?:s|)|go(?:es|) back) to the (.*?) Page(?: by way of the (.*?) Page)?$/ do |target_page, intermediate_page|
    proceed_to(CoreUtils.find_class(intermediate_page+' Page')) if intermediate_page
    proceed_to(CoreUtils.find_class(target_page+' Page'))
    set_data_target
end

When /^(?:I|they) fill the page with (.*)$/ do |data_name|
    @current_page.fill(data_name)
end

When /^(?:I|they) click the (.*)$/ do |element_name|
  @current_page.click_on(element_name.gsub(' ','_').downcase.to_sym)
end

When /^(?:I|they) hover over the (.*)$/ do |element_name|
  @current_page.hover_over(element_name.gsub(' ','_').downcase.to_sym)
end