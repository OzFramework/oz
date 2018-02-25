

class CasualDressesPage < ExampleStorefrontBasePage

  add_id_element(:h1, /CASUAL DRESSES/, class: ['page-heading', 'product-listing'])

  def create_elements

    add_static_text(:title, element_type: :h1, class: ['page-heading', 'product-listing'])
  end

end
