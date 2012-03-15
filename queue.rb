require './command'
require 'csv'

class Queue

HEADERS = ["registration_date", "first_name", "last_name",
              "email_address", "phone_number", "street", "city", 
              "state", "zipcode"]

  attr_accessor :registration_date, :first_name, :last_name, :email_address, 
                :phone_number, :street, :city, :state, :zipcode

  def call(command, parameters)
    @queue = command.queue
    case parameters[0..1].join(" ")
    when "print by" 
      queue_print_by(parameters)
    when "save to"
      queue_save(parameters)
    else
      call_2(command, parameters)
    end
  end

  def call_2(command, parameters)
    case parameters[0]
    when "count" then queue_count(command)
    when "clear" then queue_clear
    when "print" then queue_print
    else
      "Running Queue sub-function #{parameters[0]}"
    end
  end

  def self.valid_parameters?(parameters)
    if !%w(count clear print save).include?(parameters[0])
      false
    elsif parameters[0] == "print"
      parameters.count == 1 || (parameters[1] == "by" && parameters.count == 3 )
    elsif parameters[0] == "save"
      parameters[1] == "to" && parameters.count == 3
    else
      true
    end
  end

  def queue_count(command)
    "there are #{command.queue.size} items in your queue."
  end

  def queue_clear
    @queue.replace([])
  end 

  def queue_save(parameters) 
    unless @queue.empty?
      
      output = CSV.open(parameters[2], "w", :headers => true, :header_converters => :symbol)
      output << @queue.first.identity
      
      @queue.each do |attendee|
        output << attendee.identity.collect{|person| attendee.send(person)}
      end
    else
      output = CSV.open(parameters[2], "w", :headers => true, :header_converters => :symbol)
      output << HEADERS
    end
    output.close
    "saving your queue"
  end

  def queue_print
    puts puts "Last Name".ljust(15) + "\t" +
          "First Name".ljust(15) + "\t" +
          "Email Address".ljust(40) + "\t" +
          "Zipcode".ljust(15) + "\t" +
          "City".ljust(15) + "\t" +
          "State".ljust(30) + "\t" +
          "Address".ljust(15) + "\t" +
          "Phone".ljust(15) + "\t"

    @queue.each do |attendee|
      puts "#{attendee.last_name}".ljust(15) + "\t" + 
              "#{attendee.first_name}".ljust(15) + "\t" +
              "#{attendee.email_address}".ljust(40) + "\t" +
              "#{attendee.zipcode}".ljust(15) + "\t" + 
              "#{attendee.city}".ljust(15) + "\t" +
              "#{attendee.state}".ljust(15) + "\t" +
              "#{attendee.street}".ljust(15) + "\t" + 
              "#{attendee.phone_number}".ljust(15)
    end
  end

  def queue_print_by(parameters)
    order_by = parameters[2]
    case order_by
    when "zipcode" 
      sorted_queue = @queue.sort_by{ |attendee| attendee.zipcode}
    when "first_name"
      sorted_queue = @queue.sort_by{ |attendee| attendee.first_name}
    when "last_name"
      sorted_queue = @queue.sort_by{ |attendee| attendee.last_name}
    when "street" 
      sorted_queue = @queue.sort_by{ |attendee| attendee.street}
    when "city"
      sorted_queue = @queue.sort_by{ |attendee| attendee.city}
    when "state"
      sorted_queue = @queue.sort_by{ |attendee| attendee.state}
    when "email_address"
      sorted_queue = @queue.sort_by{ |attendee| attendee.email_address}
    when "phone_number"
      sorted_queue = @queue.sort_by{ |attendee| attendee.phone_number}
    end

    puts "Last Name".ljust(15) + "\t" +
          "First Name".ljust(15) + "\t" +
          "Email Address".ljust(40) + "\t" +
          "Zipcode".ljust(15) + "\t" +
          "City".ljust(15) + "\t" +
          "State".ljust(30) + "\t" +
          "Address".ljust(15) + "\t" +
          "Phone".ljust(15) + "\t"

    sorted_queue.each do |attendee|
      puts "#{attendee.last_name}".ljust(15) + "\t" + 
              "#{attendee.first_name}".ljust(15) + "\t" +
              "#{attendee.email_address}".ljust(40) + "\t" +
              "#{attendee.zipcode}".ljust(15) + "\t" + 
              "#{attendee.city}".ljust(15) + "\t" +
              "#{attendee.state}".ljust(30) + "\t" +
              "#{attendee.street}".ljust(15) + "\t" + 
              "#{attendee.phone_number}".ljust(15)
    end
  end
end