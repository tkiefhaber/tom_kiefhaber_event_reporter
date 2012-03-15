require './command'

class Attendee
  attr_accessor :registration_date, :first_name, :last_name, :email_address, 
                :phone_number, :street, :city, :state, :zipcode, :identity

  INVALID_ZIPCODE = "00000"
  IDENTITY = ["registration_date", "first_name", "last_name",
              "email_address", "phone_number", "street", "city", 
              "state", "zipcode"]
  

  def initialize(data)
    self.registration_date = data[:regdate]
    self.first_name = data[:first_name]
    self.last_name = data[:last_name]
    self.email_address = data[:email_address]
    self.phone_number = phone_number_clean(data[:homephone])
    self.street = data[:street]
    self.city = data[:city]
    self.state = data[:state]
    self.zipcode = zipcode_clean(data[:zipcode])
    self.identity = IDENTITY
  end

  def zipcode_clean(zipcode)
    zipcode.nil? ? INVALID_ZIPCODE : "%05d" % zipcode.to_s
  end

  def phone_number_clean(phone_number)
    phone_number = phone_number.scan(/\d/).join

    if phone_number.length == 10
      phone_number
    elsif phone_number.length == 11 && phone_number.start_with?("1")
      phone_number[1..-1]
    else
      "0"*10
    end
  end

end

