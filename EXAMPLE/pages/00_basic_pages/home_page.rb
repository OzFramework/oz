

class HomePage < ExampleStorefrontRootPage

  add_id_element(:div, /Automation Practice Website/, id: 'editorial_block_center')
  add_route(:DressesPage, :dresses_button)
  add_route(:SignInPage, :sign_in_button)

  def create_elements

    add_button(:dresses, element_type: :link, xpath: "//div[@id='block_top_menu']/ul/li[2]/a")

    add_static_text(:phone_info, element_type: :span, class: 'shop-phone')
    add_static_text(:practice_header, element_type: :h1, xpath: "//div[@id='editorial_block_center']/h1")
    add_static_text(:sub_header, element_type: :h2, xpath: "//div[@id='editorial_block_center']/h2")

  end

end