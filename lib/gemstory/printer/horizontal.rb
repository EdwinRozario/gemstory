module Gemstory
  module Printer
    class Horizontal
      include Helpers

      attr_reader :history

      def initialize(history)
        @history = history
      end

      def call
        @history.history.sort.each do |name, changes|
          print "#{name}"

          (@history.max_gem_name_size - name.to_s.length).times { print ' ' }
          
          print ":  "
          
          changes.each do |change|
            version_status = :up

            unless changes.index(change).zero?
              print status_code[:next]

              current_version = change[:version]
              last_version = changes[changes.index(change) - 1][:version]
              version_status = compare_version(current_version, last_version)
            end

            date_string = change[:date].strftime('%d.%m.%Y')

            print "#{change[:version]}#{status_code[version_status]}(#{date_string})"
          end

          puts ' '
        end
      end
    end
  end
end