# frozen_string_literal: true

require 'colourize'

module Gemstory
  module Printer
    # Prints history vertically
    class Horizontal
      include Helpers

      attr_reader :history

      def initialize(history)
        @history = history
      end

      def call
        @history.history.sort.each do |gem_name, commits|
          print gem_name.to_s.blue

          (@history.max_gem_name_size - gem_name.length).times { print ' ' }

          print ':  '

          commits.each_with_index do |commit, index|
            version_status = :up
            current_version = commit[:version]

            unless index.zero?
              print status_code[:next]

              last_version = commits[index - 1][:version]
              version_status = compare_version(current_version, last_version)
            end

            date_string = commit[:date].strftime('%d.%m.%Y')

            print "#{current_version.light_blue}#{status_code[version_status]}(#{date_string.yellow})"
          end

          puts ' '
        end
      end
    end
  end
end
