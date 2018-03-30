class MyAccountPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY ACCOUNT/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: 'page-heading')
    add_static_text(:welcome, element_type: :p, class: 'info-account')

  end

  def on_page_load
    @world.ledger.save_object(:logged_in, true)
    super
  end

end