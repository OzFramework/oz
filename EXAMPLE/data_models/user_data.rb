
UserDOB = Struct.new(:day, :month, :year)

UserPreferences = Struct.new(:wants_newsletter, :wants_special_offers)

UserAddress = Struct.new(:name,
                         :first_name,
                         :last_name,
                         :company,
                         :street_1,
                         :street_2,
                         :city,
                         :state,
                         :zip,
                         :country,
                         :additional_information,
                         :home_phone,
                         :mobile_phone)

CurrentUser = Struct.new(:email,
                         :first_name,
                         :last_name,
                         :gender,
                         :dob,
                         :preferences,
                         :addresses)