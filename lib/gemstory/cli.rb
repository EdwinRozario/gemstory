require 'thor'

module Gemstory
  class Cli < Thor
    attr_reader :history, :printer

    def initialize(argv)
      @history = Reader.new(argv)

      if argv.empty?
        @printer = Printer::Horizontal
      elsif argv.length == 1
        @printer = Printer::Vertical
      else
        @printer = Printer::Horizontal
      end
    end

    desc "execute", "Will print the history of your gems"
    def execute
      @history.call

      @printer.new(@history).call
    end
  end
end