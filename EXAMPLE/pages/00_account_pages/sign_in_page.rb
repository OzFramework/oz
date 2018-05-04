

class SignInPage < ExampleStorefrontRootPage

  add_id_element(:h1, /AUTHENTICATION/, class: 'page-heading')

  #TODO: Update the routing here with defaults
  # add_route(:MyAccountPage, :fill_already_registered)
  add_route(:CreateAccountPage, :fill_create_account)

  def create_elements

    #Already registered static text fields
    add_static_text(:already_registered, element_type: :h3, xpath: "//*[@id='login_form']/h3")
    add_static_text(:already_registered_email, element_type: :label, xpath: "//label[@for='email']")
    add_static_text(:already_registered_password, element_type: :label, xpath: "//label[@for='passwd']")

    #Already registered input fields
    add_text_field(:email, element_type: :input, id: 'email')
    add_text_field(:password, element_type: :input, id: 'passwd')
    add_button(:submit_sign_in, id: 'SubmitLogin')

    #Create an account static text fields
    add_static_text(:create_account, element_type: :h3, xpath: "//*[@id='create-account_form']/h3")
    add_static_text(:create_account_please_enter, element_type: :p, xpath: "//*[@id='create-account_form']/div/p")
    add_static_text(:create_account_email, element_type: :label, xpath: "//label[@for='email_create']")

    #Create an account input fields
    add_text_field(:email_create, element_type: :input, id: 'email_create')
    add_button(:create_account, id: 'SubmitCreate')

  end

  def fill_already_registered
    fill('SIGN_IN_DETAILS')
    click_on(:submit_sign_in_button)
  end

  def fill_create_account
    fill('A_NEW_ACCOUNT_EMAIL')
    click_on(:create_account_button)
  end

  def input_data(data_name)
    data = super(data_name)
    if data[:email_create_text_field] == 'DYNAMICALLY_GENERATED'
      data[:email_create_text_field] = "ozframeworktest+#{Time.now.to_i}@gmail.com"
    end
    return data
  end

end