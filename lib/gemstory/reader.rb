require 'date'

module Gemstory
  class Reader
    attr_reader :logs, :line, :date, :max_gem_name_size,
                :commit, :section, :history, :author

    SECTIONS = %w[GEM PLATFORMS DEPENDENCIES BUNDLED\ WITH].freeze

    def initialize
      @max_gem_name_size = 0
      puts 'Reading Gemfile.lock history'
      @logs = `git log --reverse --follow -p -- Gemfile.lock`
      @log_count = `git rev-list --all --count Gemfile.lock`
      @history = {}
    end

    def add_line
      ruby_gem = line.slice(1, 1000)
      tab_length = ruby_gem[/\A */].size

      return unless tab_length == 4

      ruby_gem.strip!
      gem_name_part = ruby_gem.match(/(.*)(?= \()/)
      
      if gem_name_part
        gem_name = gem_name_part[0] 
        version = ruby_gem.match(/(?<=\()(.*?)(?=\))/)[0]
      else
        gem_name = ruby_gem
        version = nil
      end

      @max_gem_name_size = gem_name.length if gem_name.length > @max_gem_name_size

      @history[gem_name.to_sym] ||= []

      @history[gem_name.to_sym] << { date: @date, commit: @commit,
                                     version: version, author: @author }
    end

    def gem?
      @line.match(/(.*)(\()(.*?)(\))/)
    end

    def new_line?
      @line.match(/^\+ /)
    end

    def author?
      matches = @line.match(/(?<=^Author: )(.*)/)

      if matches
        @author = matches[0]
        true
      else
        false
      end
    end

    def date?
      matches = @line.match(/(?<=^Date: )(.*)/)

      if matches
        @date = Date.parse(matches[0])
        true
      else
        false
      end
    end

    def commit?
      matches = @line.match(/(?<=^commit )(.*)/)

      if matches
        @commit = matches[0]
        true
      else
        false
      end
    end

    def call
      puts 'Processing history'
      puts ''
      
      @logs.each_line do |line|
        @line = line.strip
        
        next if commit?
        next if date?
        next if author?

        add_line if new_line? && gem?
      end

      @history.each do |gem_name, commits|
        sorted_commits = commits.sort_by { |commit| commit[:date] }

        @history[gem_name] = sorted_commits.each_with_index.map do |commit, index|
          if index.zero?
            commit
          else
            commit unless commit[:version] == sorted_commits[index - 1][:version]
          end
        end.compact
      end

    end    
  end
end
