require 'pry'

module Gemstory
  module Printer
    class Vertical
      attr_reader :history

      STATUS_CODE = { up: " \u2191 ", down: " \u2193 ", next: "   \u2192   " }

      def initialize(history)
        @history = history
      end

      def compare_version(current_version, last_version)
        last_version = Gem::Version.new(last_version)
        current_version = Gem::Version.new(current_version)

        if last_version < current_version 
          :up
        elsif last_version > current_version
          :down
        else
          :same
        end
      
      rescue
        :up
      end

      def call
        binding.pry
        @history.history.sort.each do |name, changes|
          print "#{name}"

          (@history.max_gem_name_size - name.to_s.length).times { print ' ' }
          
          print ":  "
          
          changes.each do |change|
            version_status = :up

            unless changes.index(change).zero?
              print STATUS_CODE[:next]

              current_version = change[:version]
              last_version = changes[changes.index(change) - 1][:version]
              version_status = compare_version(current_version, last_version)
            end

            date_string = change[:date].strftime('%d.%m.%Y')

            print "#{change[:version]}#{STATUS_CODE[version_status]}(#{date_string})"
          end

          puts ' '
        end
      end
    end
  end
end