

class HomePage < ExampleRootPage

  add_id_element(:div, /Automation Practice Website/, id: 'editorial_block_center')

  def create_elements

    add_static_text(:phone_info, element_type: :span, class: 'shop-phone')
    add_static_text(:practice_header, element_type: :h1, xpath: "//div[@id='editorial_block_center']/h1")
    add_static_text(:sub_header, element_type: :h2, xpath: "//div[@id='editorial_block_center']/h2")

  end

end