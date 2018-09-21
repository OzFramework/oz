

class HomePage < ExampleStorefrontRootPage

  add_id_element(:div, /Automation Practice Website/, id: 'editorial_block_center')
  add_route(:DressesPage, :dresses_button)
  add_route(:SignInPage, :sign_in_button)
  add_route(:CasualDressesPage, :navigate_to_casual_via_hover)

  def create_elements

    @dresses_button = add_button(:dresses, element_type: :link, xpath: "//div[@id='block_top_menu']/ul/li[2]/a")

    @casual_dresses_button = add_button(:casual_dresses, element_type: :link, xpath: "//div[@id='block_top_menu']/ul/li[2]/ul/li[1]/a")
    @casual_dresses_button.deactivate

    @dresses_button.on_hover do
      @casual_dresses_button.activate
      CoreUtils.wait_until(3) { @casual_dresses_button.present? }
    end

    add_static_text(:phone_info, element_type: :span, class: 'shop-phone')
    add_static_text(:practice_header, element_type: :h1, xpath: "//div[@id='editorial_block_center']/h1")
    add_static_text(:sub_header, element_type: :h2, xpath: "//div[@id='editorial_block_center']/h2")

  end

  def navigate_to_casual_via_hover
    @dresses_button.hover
    @casual_dresses_button.click
  end

end