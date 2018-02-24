

class SignInPage < ExampleStorefrontRootPage

  add_id_element(:h1, /AUTHENTICATION/, class: 'page-heading')
  add_route(:AccountPage, :submit_sign_in_button, :fill)

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

end