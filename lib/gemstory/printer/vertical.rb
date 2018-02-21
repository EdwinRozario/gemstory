module Gemstory
  module Printer
    class Vertical
      include Helpers

      attr_reader :history

      def initialize(history)
        @history = history
      end

      def call
        if @history.history.empty?
          puts 'Requested gem dosent exist in the Gemfile.lock'
        else
          gem_name = @history.history.first.first
          commits = @history.history.first.last

          puts gem_name
          puts ' '

          commits.each do |commit|
            version_status = :up

            unless commits.index(commit).zero?
              current_version = commit[:version]
              last_version = commits[commits.index(commit) - 1][:version]
              version_status = compare_version(current_version, last_version)
            end

            date_string = commit[:date].strftime('%d.%m.%Y')

            puts "#{status_code[version_status]}  #{commit[:version]}  #{date_string}  #{commit[:commit]}  #{commit[:author]}"
          end
        end
      end
    end
  end
end