class CreateAccountPage < ExampleStorefrontRootPage

  add_id_element(:h1, /CREATE AN ACCOUNT/, class: 'page-heading')

  def create_elements

    add_static_text(:your_personal_information, element_type: :h3, xpath: "//form[@id='account-creation_form']/div[1]/h3")

  end

end