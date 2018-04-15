

class MyWishlistsPage < ExampleStorefrontRootPage

  add_id_element(:h1, /MY WISHLISTS/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: 'page-heading')
    add_static_text(:new_wishlist, element_type: :h3, class: 'page-subheading')

  end

end