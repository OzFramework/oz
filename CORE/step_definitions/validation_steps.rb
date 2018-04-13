
### CORE Validation Steps ###
#############################


    #Tags: @static_text
    # Checks all of the static_text objects on the page to make sure they are present and contain the proper text.
    # The data used for checking is defined in the page class and/or in the page class's .yml file.
Then /^I can see that all the content on the page is correct$/ do
  @current_page.validate_content
end


    #Tags: @navigation
    # Checks that the application is on the specified page.
Then /^I should see the (.*) Page$/ do |page|
  page_class = CoreUtils.find_class(page+' Page')
  validate_application_is_on_page(page_class)
end

