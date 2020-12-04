# typed: false
# frozen_string_literal: true

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

          puts "\033[0;33m#{gem_name}\033[0;m"
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
