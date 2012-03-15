require './command'
require './attendee'
require 'csv'

class EventDataParser

  def self.file_load(filename)
    puts "Loading #{filename}"
    @file = CSV.open(filename, :headers => true,
                                :header_converters => :symbol)
    @file.collect{|line| Attendee.new(line) }
  end


  def self.valid_parameters?(parameters)
    parameters.count == 1 && parameters[0] =~ /\.csv$/
  end

end