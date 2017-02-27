

class ExampleBasePage < ExampleRootPage

  add_route(:HomePage, :banner_home_button)

  def create_common_elements
    super

    add_button(:banner_home, element_type: :div, id: 'header_logo')
  end

end