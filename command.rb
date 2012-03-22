require './event_data_parser'
require './help'
require './queue'
require './search'
require './attendee'

class Command
  ALL_COMMANDS = {"load" => "loads a new file",
                    "help" => "shows a list of available commands",
                    "queue" => "a set of data",
                    "queue count" => "total items in the queue",
                    "queue clear" => "empties the queue",
                    "queue print" => "prints to the queue",
                    "queue print by" => "prints the specified attribute",
                    "queue save to" => "exports queue to a CSV",
                    "find" => "load the queue with matching records"}

  attr_accessor :queue, :attendees

  def initialize
    @queue = []
    @attendees = []
  end

  def execute(command, parameters)
    if command == "load" && parameters[0] ||= "event_attendees.csv"
      validate(command, parameters)
    elsif command == "queue" && Queue.valid_parameters?(parameters)
      Queue.new.call(self, parameters)
    elsif command == "help" && parameters.count == 0
      "here are a list of commands you can use: #{ALL_COMMANDS.keys}"
    elsif command == "help" && Help.valid_parameters?(parameters)
      Help.for(parameters)
    elsif command == "find" && Search.valid_parameters?(parameters)
      Search.for(self, parameters)
    else error_message_for(command)
    end
  end

  def error_message_for(command)
    "Sorry, you specified invalid arguments for #{command}."
  end

  def parse_load(command, parameters)
    if EventDataParser.valid_parameters?(parameters)
        @attendees = EventDataParser.file_load(parameters[0])
        "Parsed #{@attendees.count} attendees from the file."
    end
  end

  def validate(command, parameters)
    if EventDataParser.valid_parameters?(parameters)
        parse_load(command, parameters)
    end
  end
end