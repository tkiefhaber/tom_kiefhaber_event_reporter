require './command'
require './queue'

class Search
  def self.for(command, parameters)
    @queue = command.queue
    @attendees = command.attendees
    case parameters[0]
    when "first_name" then first_name_find(parameters[1])
    when "last_name" then last_name_find(parameters[1])
    when "email_address" then email_address_find(parameters[1])
    when "phone_number" then phone_number_find(parameters[1])
    when "street" then street_find(parameters[1])
    when "city" then city_find(parameters[1..-1].join(" "))
    when "state" then state_find(parameters[1])
    when "zipcode" then zipcode_find(parameters[1])
    else 
      "This is a bogus command, please try again."
    end
  end

  def self.valid_parameters?(parameters)
    # TODO: check that attribute is actually valid
    parameters.count >= 2
  end

  def self.first_name_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.first_name =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.last_name_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.last_name =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.email_address_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.email_address =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.phone_number_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.phone_number =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.street_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.street_find =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.city_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.city =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.state_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.state =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end

  def self.zipcode_find(parameters)
    @queue.replace([])
    @attendees.each do |a| 
      @queue << a if a.zipcode =~ /^#{parameters}$/i
    end
    "I found #{@queue.count} records matching your search"
  end
end