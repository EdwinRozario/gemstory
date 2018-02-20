require 'thor'

module Gemstory
  class Cli < Thor
    attr_reader :history

    def initialize(argv)
      @history = Gemstory::Reader.new
    end

    desc "execute", "Will print the history of your gems"
    def execute
      @history.call
      Gemstory::Printer.new(@history).call
    end
  end
end