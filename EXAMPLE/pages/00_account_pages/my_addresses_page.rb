

class MyAddressesPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY ADDRESSES/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: "page-heading")
    add_static_text(:description,       element_type: :p, xpath: "//div[@id='center_column']/p")
    add_static_text(:your_addresses,    element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[1]")
    add_static_text(:be_sure_to_update, element_type: :p, xpath: "//div[@id='center_column']/div[@class='addresses']/p[2]")

    address_count = @world.ledger.current_user.addresses.length + 1
    address_groups = []

    1.upto(address_count) do |index|
      address_groups << group(
        add_static_text(:"address_#{index}_name",         element_type: :h3,   xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[1]/h3"),
        add_static_text(:"address_#{index}_fist_name",    element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[2]/span[1]"),
        add_static_text(:"address_#{index}_last_name",    element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[2]/span[2]"),
        add_static_text(:"address_#{index}_company",      element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[3]/span"),
        add_static_text(:"address_#{index}_street_1",     element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[4]/span[1]"),
        add_static_text(:"address_#{index}_street_2",     element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[4]/span[2]"),
        add_static_text(:"address_#{index}_city",         element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[5]/span[1]"),
        add_static_text(:"address_#{index}_state",        element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[5]/span[2]"),
        add_static_text(:"address_#{index}_zip",          element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[5]/span[3]"),
        add_static_text(:"address_#{index}_country",      element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[6]/span[1]"),
        add_static_text(:"address_#{index}_phone",        element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[7]/span[1]"),
        add_static_text(:"address_#{index}_mobile_phone", element_type: :span, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[8]/span[1]"),

        add_button(:"address_#{index}_update", element_type: :link, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[9]/a[1]"),
        add_button(:"address_#{index}_delete", element_type: :link, xpath: "//div[@class='bloc_adresses row']/div[#{index}]/ul/li[9]/a[2]")
      )
    end

    address_groups.each_with_index do |address, index|
      address.deactivate if index + 1 >= address_count
    end

    add_button(:add_address, element_type: :link, xpath: "//div[@id='center_column']/div[2]/a")

  end

  def expected_data(data_name = 'DEFAULT')
    data = super(data_name)
    user_addresses = @world.ledger.current_user.addresses
    user_addresses.each_with_index do |address_data, index|
      data[:"address_#{index+1}_name_static_text"] = address_data.name.upcase
      data[:"address_#{index+1}_fist_name_static_text"] = address_data.first_name
      data[:"address_#{index+1}_last_name_static_text"] = address_data.last_name
      data[:"address_#{index+1}_company_static_text"] = address_data.company
      data[:"address_#{index+1}_street_1_static_text"] = address_data.street_1
      data[:"address_#{index+1}_street_2_static_text"] = address_data.street_2
      data[:"address_#{index+1}_city_static_text"] = address_data.city + ','
      data[:"address_#{index+1}_state_static_text"] = address_data.state
      data[:"address_#{index+1}_zip_static_text"] = address_data.zip
      data[:"address_#{index+1}_country_static_text"] = address_data.country
      data[:"address_#{index+1}_phone_static_text"] = address_data.home_phone
      data[:"address_#{index+1}_mobile_phone_static_text"] = address_data.mobile_phone
    end
    return data
  end

end