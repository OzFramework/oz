

class PersonalInformationPage < ExampleStorefrontRootPage

  add_id_element(:h1, /YOUR PERSONAL INFORMATION/, class: 'page-subheading')

  def create_elements

    add_static_text(:update_information, element_type: :p, xpath: "//div[@id='center_column']/div/p[@class='info-title']")
    add_static_text(:required_field, element_type: :p, xpath: "//div[@id='center_column']/div/p[@class='required']")

  end

end