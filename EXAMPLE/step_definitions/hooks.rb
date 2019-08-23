require_relative '../../CORE/step_definitions'

Before do |scenario|
  set_root_page(ExampleStorefrontRootPage)
  @browser_engine.create_new_browser
end