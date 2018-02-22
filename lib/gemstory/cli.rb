# frozen_string_literal: true

require 'thor'

module Gemstory
  # Handles the CLI commands
  class Cli < Thor
    attr_reader :history, :printer

    def initialize(argv)
      @history = Reader.new(argv)

      @printer = if argv.empty?
                   Printer::Horizontal
                 elsif argv.length == 1
                   Printer::Vertical
                 else
                   Printer::Horizontal
                 end
    end

    desc 'execute', 'Will print the history of your gems'
    def execute
      @history.call

      @printer.new(@history).call
    end
  end
end
