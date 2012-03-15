require './command'


class Help
  def self.for(parameters)
    if parameters[0] == "load"
      "loads a new file"
    elsif parameters.join(" ") == "queue count"
      "total items in your current queue"
    elsif parameters[0..-1].join(" ") == "queue print"
      "prints the queue"
    elsif parameters[0..-1].join(" ") == "queue print by"
      "prints the queue sorted by your criteria"
    elsif parameters[0..-1].join(" ") == "queue save to"
      "exports queue to a csv"
    elsif parameters[0] == "find"
      "search for criteria in the loaded file"
    elsif parameters[0] == "queue"
      "your search results"
    #elsif parameters[0] == "help"
      #"helps you figure out what commands do"
    end
  end

  def self.valid_parameters?(parameters)
    parameters.empty? || Command.valid?(parameters.join(" "))
  end
end