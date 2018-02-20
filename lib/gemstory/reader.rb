require 'date'
# require 'progress'

module Gemstory
  class Reader
    attr_reader :logs, :line, :date, :max_gem_name_size,
                :commit, :section, :history, :dates, :log_count

    SECTIONS = %w[GEM PLATFORMS DEPENDENCIES BUNDLED\ WITH].freeze

    def initialize
      @dates = []
      @max_gem_name_size = 0
      @logs = `git log --reverse --follow -p -- Gemfile.lock`
      @log_count = `git rev-list --all --count Gemfile.lock`
      @history = {}
    end

    def compare_version(gem_name, version)
      return :up if @history[gem_name].empty?

      last_version = Gem::Version.new(@history[gem_name].last[:version])
      current_version = Gem::Version.new(version)


      if last_version < current_version 
        :up
      elsif last_version > current_version
        :down
      else
        false
      end
    
    rescue
      :up
    end

    def add_line
      return unless gem?
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

      version_status = compare_version(gem_name.to_sym, version)
      
      return unless version_status

      @history[gem_name.to_sym] ||= []

      @history[gem_name.to_sym] << { date: @date, commit: @commit,
                                     version: version, change: version_status,
                                     hierarchy: tab_length }

      @history[gem_name.to_sym] = @history[gem_name.to_sym].sort_by { |changes| changes[:date] }
    end

    def gem?
      @line.match(/(.*)(\()(.*?)(\))/)
    end

    def new_line?
      @line.match(/^\+ /)
    end

    def date?
      matches = @line.match(/(?<=^Date: )(.*)/)

      if matches
        @date = Date.parse(matches[0])
        @dates << @date
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

    def section?
      sections = SECTIONS.map { |section| section if line.include? section }.compact
      
      unless sections.empty?
        @section = sections.first
        true
      else
        false
      end
    end

    def categorize
      section
    end

    def call
      # @logs.each_line.with_progress('Reading Gemfile.lock history') do |line|
      puts 'Reading Gemfile.lock history'
      @logs.each_line do |line|
        @line = line.strip
        
        next if commit?
        next if date?

        add_line if new_line?
      end
    end    
  end
end
