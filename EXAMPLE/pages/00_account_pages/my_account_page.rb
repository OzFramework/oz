class MyAccountPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY ACCOUNT/, class: 'page-heading')
  add_route(:OrderHistoryPage, :order_history_button)
  add_route(:CreditSlipsPage, :my_credit_slips_button)
  add_route(:MyAddressesPage, :my_addresses_button)
  add_route(:PersonalInformationPage, :my_personal_information_button)
  add_route(:MyWishlistsPage, :my_wishlists_button)

  def create_elements

    add_static_text(:title, element_type: :h1, class: 'page-heading')
    add_static_text(:welcome, element_type: :p, class: 'info-account')

    add_static_text(:order_history, element_type: :span, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[1]/a/span")
    add_static_text(:my_credit_slips, element_type: :span, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[2]/a/span")
    add_static_text(:my_addresses, element_type: :span, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[3]/a/span")
    add_static_text(:my_personal_information, element_type: :span, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[4]/a/span")
    add_static_text(:my_wishlists, element_type: :span, xpath: "//div[@class='row addresses-lists']/div[2]/ul/li[1]/a/span")

    add_button(:order_history,           element_type: :link, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[1]/a")
    add_button(:my_credit_slips,         element_type: :link, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[2]/a")
    add_button(:my_addresses,            element_type: :link, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[3]/a")
    add_button(:my_personal_information, element_type: :link, xpath: "//div[@class='row addresses-lists']/div[1]/ul/li[4]/a")
    add_button(:my_wishlists,            element_type: :link, xpath: "//div[@class='row addresses-lists']/div[2]/ul/li[1]/a")

  end

  def on_page_load
    @world.ledger.save_object(:logged_in, true)
    super
  end

end