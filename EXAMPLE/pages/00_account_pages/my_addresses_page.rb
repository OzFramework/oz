

class MyAddressesPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY ADDRESSES/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: "page-heading")
    add_static_text(:description,       element_type: :p, xpath: "//div[@id='center_column']/p")
    add_static_text(:your_addresses,    element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[1]")
    add_static_text(:be_sure_to_update, element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[2]")

    #TODO: Make addresses found here dynamic

    add_static_text(:name, element_type: :h3,   xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[1]/h3")
    add_static_text(:fist_name,    element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[2]/span[1]")
    add_static_text(:last_name,    element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[2]/span[2]")
    add_static_text(:company,      element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[3]/span")
    add_static_text(:street_1,     element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[4]/span[1]")
    add_static_text(:street_2,     element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[4]/span[2]")
    add_static_text(:city,         element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[5]/span[1]")
    add_static_text(:state,        element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[5]/span[2]")
    add_static_text(:zip,          element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[5]/span[3]")
    add_static_text(:country,      element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[6]/span[1]")
    add_static_text(:phone,        element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[7]/span[1]")
    add_static_text(:mobile_phone, element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[8]/span[1]")

    add_button(:update, element_type: :link, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[9]/a[1]")
    add_button(:delete, element_type: :link, xpath: "//div[@class='bloc_adresses row']/div[1]/ul/li[9]/a[2]")


    add_button(:add_address, element_type: :link, xpath: "//div[@id='center_column']/div[2]/a")

  end

end