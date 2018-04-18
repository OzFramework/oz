

class OrderHistoryPage < ExampleStorefrontRootPage

  add_id_element(:h1, /ORDER HISTORY/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: "page-heading")
    add_static_text(:description, element_type: :p, xpath: "//div[@id='center_column']/p[@class='info-title']")
    add_static_text(:no_orders, element_type: :p, xpath: "//div[@id='block-history']/p")

    add_button(:back, element_type: :span, xpath: "//div[@id='center_column']/ul/li[1]/a/span")
    add_button(:home, element_type: :span, xpath: "//div[@id='center_column']/ul/li[2]/a/span")

  end

end