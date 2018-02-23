

class ExampleStorefrontRootPage < CorePage

  def begin_new_session
    browser.goto(@world.configuration['ENVIRONMENT']["URL"])
    @world.assert_and_set_page(HomePage)
  end

  def create_common_elements
    add_button(:sign_in, element_type: :a, class: 'login')
  end

end