

class OrderHistoryPage < ExampleStorefrontRootPage

  add_id_element(:h1, /ORDER HISTORY/, class: 'page-heading')

  def create_elements

    add_static_text(:description, element_type: :p, xpath: "//div[@id='center_column']/p[@class='info-title']")

  end

end