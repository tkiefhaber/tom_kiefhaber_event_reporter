require './command'
require 'csv'

class Queue

HEADERS = ["regdate", "first_name", "last_name",
              "email_address", "homephone", "street", "city",
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
      parameters.count == 1 || (parameters[1] == "by" && parameters.count == 3)
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
      output = CSV.open(parameters[2], "w", :headers => true,
                        :header_converters => :symbol)
      output << HEADERS
      @queue.each do |attendee|
        output << attendee.identity.collect{|person| attendee.send(person)}
      end
    else queue_output(parameters)
    end
    output.close
    "saving your queue"
  end

  def queue_output(parameters)
    output = CSV.open(parameters[2], "w", :headers => true,
                :header_converters => :symbol)
    output << HEADERS
  end

  def queue_print
    print_headers
    print_format
  end

  def print_headers
    puts "Last Name".ljust(10) + "\t" + "First Name".ljust(10) + "\t" +
          "Email Address".ljust(40) + "\t" + "Zipcode".ljust(10) + "\t" +
          "City".ljust(15) + "\t" + "State".ljust(5) + "\t" +
          "Address".ljust(25) + "\t" + "Phone".ljust(15) + "\t"
  end

  def print_format(queue = @queue)
    queue.each do |attendee|
    puts "#{attendee.last_name}".ljust(10) + "\t" +
              "#{attendee.first_name}".ljust(10) + "\t" +
              "#{attendee.email_address}".ljust(40) + "\t" +
              "#{attendee.zipcode}".ljust(10) + "\t" +
              "#{attendee.city}".ljust(15) + "\t" +
              "#{attendee.state}".ljust(5) + "\t" +
              "#{attendee.street}".ljust(25) + "\t" +
              "#{attendee.phone_number}".ljust(15)
    end
  end

  def queue_print_by(parameters)
    order_by = parameters[2]
    attributes = ["zipcode", "first_name", "last_name",
                  "street", "city", "state", "email_address", "phone_number"]

    if attributes.include? order_by
      sorted_queue = @queue.sort_by{ |attendee| attendee.send(order_by)}
    end
    print_headers
    print_format(sorted_queue)
  end
end