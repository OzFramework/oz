

class ExampleStorefrontBasePage < ExampleStorefrontRootPage

  add_route(:HomePage, :your_logo_button)

  def create_common_elements
    super

    add_button(:your_logo, element_type: :div, id: 'header_logo')
  end

end