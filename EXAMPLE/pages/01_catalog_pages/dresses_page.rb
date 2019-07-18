

class DressesPage < ExampleStorefrontBasePage

  add_id_element(:h1, /DRESSES \nThere are 5 products./, class: ['page-heading', 'product-listing'])
  add_route(:CasualDressesPage, :casual_dresses_button)
  add_route(:HomePage, :header_logo_button)

  def create_elements

    add_button(:casual_dresses, element_type: :link, xpath: "//div[@id='categories_block_left']/div/ul/li[1]/a")

    add_static_text(:title, element_type: :h1, class: ['page-heading', 'product-listing'])

    add_button(:header_logo, element_type: :div, id: 'header_logo')

  end

end
