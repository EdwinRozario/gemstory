require 'thor'

module Gemstory
  class Cli < Thor
    desc "execute", "Will print the history of your gems"

    def execute
      puts 'IN RUN COMMAND'
      puts `git log --reverse --follow -p -- Gemfile.lock`
    end
  end
end