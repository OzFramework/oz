class CreateAccountPage < ExampleStorefrontRootPage

  add_id_element(:h1, /CREATE AN ACCOUNT/, class: 'page-heading')

  def create_elements

    add_static_text(:your_personal_information, element_type: :h3, xpath: "//form[@id='account-creation_form']/div[1]/h3")

    # add_radio_button(:title, id: 'id_gender1') #TODO: add radio button support
    add_text_field(:first_name, id: 'customer_firstname')
    add_text_field(:last_name, id: 'customer_lastname')
    add_text_field(:email, id: 'email')
    add_text_field(:password, id: 'passwd')
                                            #TODO: Select lists aren't working because of the way this site is implemented.
                                            #      Watir sees them as being not visible even when they are visible.
                                            #      This will probably translate into some kind of override for the example select lists.
    # add_select_list(:dob_day, id: 'days') #TODO: Fix these select lists
    # add_select_list(:dob_month, id: 'months')
    # add_select_list(:dob_year, id: 'years')

    # add_checkbox(:newsletter, id: 'newsletter') #TODO: find out why these checkboxes aren't working
    # add_checkbox(:special_offers, id: 'optin')

    add_text_field(:address_firstname, id: 'firstname')
    add_text_field(:address_lastname, id: 'lastname')
    add_text_field(:company, id: 'company')
    add_text_field(:address_1, id: 'address1')
    add_text_field(:address_2, id: 'address2')
    add_text_field(:city, id: 'city')
    # add_select_list(:state, id: 'id_state')
    add_text_field(:zip, id: 'postcode')
    # add_select_list(:country, id: 'id_country')

    # add_text_area(:additional_information, id: 'other') #TODO: add text area support
    add_text_field(:home_phone, id: 'phone')
    add_text_field(:mobile_phone, id: 'phone_mobile')
    add_text_field(:address_alias, id: 'alias')


  end

end