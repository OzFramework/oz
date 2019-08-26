require_relative 'oz/step_definitions'

Before do |scenario|
  set_root_page(ExampleStorefrontRootPage)
  @browser_engine.create_new_browser
end