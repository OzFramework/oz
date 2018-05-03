

class CreditSlipsPage < ExampleStorefrontRootPage

  add_id_element(:h1, /CREDIT SLIPS/, class: 'page-heading')

  def create_elements

    add_static_text(:title, element_type: :h1, class: 'page-heading')
    add_static_text(:description, element_type: :p, xpath: "//div[@id='center_column']/p[@class='info-title']")
    add_static_text(:no_credit_slips, element_type: :p, xpath: "//div[@id='block-history']/p")

    add_button(:back_to_account, element_type: :span, xpath: "//ul[@class='footer_links clearfix']/li/a/span")
    add_button(:home, element_type: :span, xpath: "//ul[@class='footer_links clearfix']/li[2]/a/span")

  end

end