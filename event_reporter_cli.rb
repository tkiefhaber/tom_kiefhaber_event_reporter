require 'logger'
require './command'

module Kernel
  def log(message)
    logger.info("Logger is #{logger.object_id}")
    logger.info(message)
  end

  def logger
    @@logger ||= Logger.new("dev.log")
  end
  
end

module EventReporter
  class EventReporterCLI
    EXIT_COMMANDS = ["quit", "q", "e", "exit"]

    def self.parse_inputs(inputs)
      [ inputs.first.downcase, inputs[1..-1] ]
    end

    def self.prompt_user
      printf "enter command > "
      gets.strip.split
    end

    def self.run
      puts "Welcome to the EventReporter"
      results = ""
      @reporter = Command.new

      while results
        #log "executing a command from CLI.run"
        results = execute_command(prompt_user)
        puts results if results.is_a?(String)
        #log "finished"
      end
    end

    def self.execute_command(inputs)
      if inputs.any?
        command, parameters = parse_inputs(inputs)
        @reporter.execute(command, parameters) unless quitting?(command)
      else
        "No command entered."
      end
    end

    def self.quitting?(command)
      EXIT_COMMANDS.include?(command)
    end
  end
end

EventReporter::EventReporterCLI.run