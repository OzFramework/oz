RSpec.configure do |c|
  c.before(:each) do
    set_root_page(ExampleStorefrontRootPage)
    @browser_engine.create_new_browser
  end
end