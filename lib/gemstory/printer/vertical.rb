# frozen_string_literal: true

require 'colourize'

module Gemstory
  module Printer
    # Prints hostory of a single gem verticalling through commits
    class Vertical
      include Helpers

      attr_reader :history

      def initialize(history)
        @history = history.history
      end

      def call
        if @history.empty?
          puts 'Requested gem dosent exist in the Gemfile.lock'
        else
          gem_name, commits = @history.first

          puts gem_name.to_s.blue
          puts ' '

          commits.each_with_index do |commit, index|
            version_status = :up
            current_version = commit[:version]

            unless index.zero?
              last_version = commits[index - 1][:version]
              version_status = compare_version(current_version, last_version)
            end

            date_string = commit[:date].strftime('%d.%m.%Y')

            puts "#{status_code[version_status]}  #{current_version}  #{date_string}  #{commit[:commit]}  #{commit[:author]}"
          end
        end
      end
    end
  end
end
