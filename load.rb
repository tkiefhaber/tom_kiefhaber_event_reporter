require './event_data_parser'
require './queue'
require './help'
require './search'
require './command'
require 'csv'

class Load

  def file_load
    @file = CSV.open(filename, :headers => true,
                                :header_converters => :symbol)
  end