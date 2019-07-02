class CreateAccountWithParentsPage < ExampleStorefrontRootPage

  add_id_element(:h1, /CREATE AN ACCOUNT/, class: 'page-heading')
  add_route(:MyAccountPage, :register_account, :fill)

  def create_elements

    account_creation_form = add_element(:account_creation_form, element_type: :form, id: 'account-creation_form')
    personal_information_section = add_element(:personal_information_section, element_type: :div, parent: account_creation_form, class: 'account_creation', index: 0)
    address_section = add_element(:address_section, element_type: :div, parent: account_creation_form, class: 'account_creation', index: 1)
    date_of_birth_section = add_element(:date_of_birth_section, parent: personal_information_section, class: 'form-group', index: 4)

    # Due to the fact that there's only one h3 under the personal information section, we don't have to be very specific now.  Only reason we need the class
    # is because oz requires a selector.
    add_static_text(:your_personal_information, element_type: :h3, parent: personal_information_section, class: 'page-subheading')
    # This label is the first one in the section
    add_static_text(:title, element_type: :label, parent: personal_information_section, index: 0)
    add_static_text(:mr, element_type: :label, for: "id_gender1")
    add_static_text(:mrs, element_type: :label, for: "id_gender2")

    add_static_text(:first_name, element_type: :label, for: 'customer_firstname')
    add_static_text(:last_name, element_type: :label, for: 'customer_lastname')
    add_static_text(:email, element_type: :label, for: 'email')
    add_static_text(:password, element_type: :label, for: 'passwd')
    # There are two form_info class'd spans on the page, however there is only one that is a child of the personal information section.
    add_static_text(:password_hint, element_type: :span, parent: personal_information_section, class: 'form_info')
    add_static_text(:dob, element_type: :label, parent: date_of_birth_section, index: 0)
    add_static_text(:newsletter, element_type: :label, for: 'newsletter')
    add_static_text(:special_offers, element_type: :label, for: 'optin')

    add_radio_button(:mr, id: 'id_gender1')
    add_radio_button(:mrs, id: 'id_gender2')
    add_text_field(:first_name, id: 'customer_firstname')
    add_text_field(:last_name, id: 'customer_lastname')
    add_text_field(:email, id: 'email')
    add_text_field(:password, id: 'passwd')
    add_select_list(:dob_day, id: 'days')
    add_select_list(:dob_month, id: 'months')
    add_select_list(:dob_year, id: 'years')

    add_checkbox(:newsletter, id: 'newsletter')
    add_checkbox(:special_offers, id: 'optin')
    
    add_static_text(:address_header, element_type: :h3, parent: address_section, class: 'page-subheading')
    add_static_text(:address_first_name, element_type: :label, for: 'firstname')
    add_static_text(:address_last_name, element_type: :label, for: 'lastname')
    add_static_text(:company, element_type: :label, for: 'company')
    add_static_text(:address_1, element_type: :label, for: 'address1')
    # We can actually constrain x-paths using parents too.
    add_static_text(:address_1_hint, element_type: :span, parent: address_section, xpath: "./p[4]/span")
    add_static_text(:address_2, element_type: :label, for: 'address2')
    add_static_text(:address_2_hint, element_type: :span, parent: address_section, xpath: "./p[5]/span")
    add_static_text(:city, element_type: :label, for: 'city')
    add_static_text(:state, element_type: :label, for: 'id_state')
    add_static_text(:zip, element_type: :label, for: 'postcode')
    add_static_text(:country, element_type: :label, for: 'id_country')
    add_static_text(:additional_information, element_type: :label, for: 'other')
    add_static_text(:home_phone, element_type: :label, for: 'phone')
    add_static_text(:mobile_phone, element_type: :label, for: 'phone_mobile')
    add_static_text(:address_alias, element_type: :label, for: 'alias')
    add_static_text(:required_field, element_type: :span, parent: account_creation_form, xpath: './div[4]/p/span')

    add_text_field(:address_firstname, id: 'firstname')
    add_text_field(:address_lastname, id: 'lastname')
    add_text_field(:company, id: 'company')
    add_text_field(:address_1, id: 'address1')
    add_text_field(:address_2, id: 'address2')
    add_text_field(:city, id: 'city')
    add_select_list(:state, id: 'id_state')
    add_text_field(:zip, id: 'postcode')
    add_select_list(:country, id: 'id_country')

    add_text_area(:additional_information, id: 'other')
    add_text_field(:home_phone, id: 'phone')
    add_text_field(:mobile_phone, id: 'phone_mobile')
    add_text_field(:address_alias, id: 'alias')

    @register_button = add_button(:register, id: 'submitAccount')

  end

  def register_account
    @register_button.click

    page_values = @world.ledger.get_page_values(self.class)

    user_dob = UserDOB.new(
      page_values[:dob_day_select_list],
      page_values[:dob_month_select_list],
      page_values[:dob_year_select_list]
    )

    user_preferences = UserPreferences.new(
      page_values[:newsletter_checkbox],
      page_values[:special_offers_checkbox]
    )

    user_address = UserAddress.new(
      page_values[:address_alias_text_field],
      page_values[:address_firstname_text_field],
      page_values[:address_lastname_text_field],
      page_values[:company_text_field],
      page_values[:address_1_text_field],
      page_values[:address_2_text_field],
      page_values[:city_text_field],
      page_values[:state_select_list],
      page_values[:zip_text_field],
      page_values[:country_select_list],
      page_values[:additional_information_text_field],
      page_values[:home_phone_text_field],
      page_values[:mobile_phone_text_field]
    )

    current_user = CurrentUser.new(
        @world.ledger.get_value(SignInPage, :email_create_text_field),
        page_values[:first_name_text_field],
        page_values[:last_name_text_field],
        page_values[:mr_radio_button] == 'selected' ? :male : :female,
        user_dob,
        user_preferences,
        [user_address]
    )

    @world.ledger.save_object(:current_user, current_user)

  end

end