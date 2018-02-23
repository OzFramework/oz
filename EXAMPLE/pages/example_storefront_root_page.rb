

class ExampleStorefrontRootPage < CorePage

  def begin_new_session
    browser.goto(@world.configuration['ENVIRONMENT']["URL"])
    @world.ledger.save_object(:logged_in, false)
    @world.assert_and_set_page(HomePage)
  end

  def create_common_elements
    @sign_in_button = add_button(:sign_in, element_type: :a, class: 'login')
  end

  def on_page_load
    @sign_in_button.activate_if(!@world.ledger.logged_in)
  end

end