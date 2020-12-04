# typed: false
# frozen_string_literal: true

module Gemstory
  module Printer
    # Helper methods for printers
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
      rescue ArgumentError
        :up
      end

      def status_code
        { up: " \033[0;32m\u2191\033[0;m ",
          down: " \033[0;31m\u2193\033[0;m ",
          next: " \033[0;34m \u2192 \033[0;m " }
      end
    end
  end
end
