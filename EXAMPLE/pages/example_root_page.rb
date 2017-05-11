

class ExampleRootPage < CorePage

  def begin_new_session
    browser.goto(@world.configuration['ENVIRONMENT']["URL"])
    @world.assert_and_set_page(HomePage)
  end

end