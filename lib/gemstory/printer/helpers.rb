module Gemstory
  module Printer
    module Helpers
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

      def status_code
        { up: " \u2191 ", down: " \u2193 ", next: "   \u2192   " }
      end
    end
  end
end