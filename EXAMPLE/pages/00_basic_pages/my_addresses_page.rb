

class MyAddressesPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY ADDRESSES/, class: 'page-heading')

  def create_elements

    add_static_text(:description, element_type: :p, xpath: "//div[@id='center_column']/p")
    add_static_text(:your_addresses, element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[1]")
    add_static_text(:be_sure_to_update, element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[2]")

  end

end