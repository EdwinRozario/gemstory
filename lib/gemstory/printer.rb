module Gemstory
  class Printer
    attr_reader :history

    STATUS_CODE = { up: " \u2191 ", down: " \u2193 ", next: "   \u2192   " }

    def initialize(history)
      @history = history
    end

    def call
      @history.history.sort.each do |name, changes|
        print "#{name}"

        (@history.max_gem_name_size - name.to_s.length).times { print ' ' }
        
        print ":  "
        
        changes.each do |change|
          date_string = change[:date].strftime('%d.%m.%Y')

          unless changes.index(change).zero?
            print STATUS_CODE[:next]
          end

          print "#{change[:version]}#{STATUS_CODE[change[:change]]}(#{date_string})"
        end

        puts ' '
      end
    end
  end
end