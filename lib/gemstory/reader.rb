# typed: false
# frozen_string_literal: true

require 'date'

# module Gemstory
#   module GitCommand
#     def follow_log
#       `git log --reverse --follow -p -- Gemfile.lock`
#     end
#   end
# end

module Gemstory
  # Reads the git logs and produce and Hash
  class Reader
    attr_reader :logs, :line, :date, :max_gem_name_size,
                :commit, :history, :author, :requested_gems

    def initialize(gems = [])
      @requested_gems = gems
      @max_gem_name_size = 0

      puts 'Reading Gemfile.lock history'
      @logs = follow_log

      @history = {}
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

    private

      def follow_log
        `git log --reverse --follow -p -- Gemfile.lock`
      end

      def add_line
        ruby_gem = line.slice(1, 1000)
        tab_length = ruby_gem[/\A */].size

        return unless tab_length == 4

        ruby_gem.strip!
        gem_name_part = ruby_gem.match(/(.*)(?= \()/)

        if gem_name_part
          gem_name = gem_name_part[0].to_sym
          version = ruby_gem.match(/(?<=\()(.*?)(?=\))/)[0]
        else
          gem_name = ruby_gem.to_sym
          version = nil
        end

        unless @requested_gems.empty?
          return unless @requested_gems.include? gem_name.to_s
        end

        @max_gem_name_size = gem_name.length if gem_name.length > @max_gem_name_size
        @history[gem_name] ||= []
        @history[gem_name] << { date: date, commit: commit,
                                       version: version, author: author }
      end

      def gem?
        line.match(/(.*)(\()(.*?)(\))/)
      end

      def new_line?
        line.match(/^\+ /)
      end

      def author?
        matches = line.match(/(?<=^Author: )(.*)/)

        if matches
          @author = matches[0]
          true
        else
          false
        end
      end

      def date?
        matches = line.match(/(?<=^Date: )(.*)/)

        if matches
          @date = Date.parse(matches[0])
          true
        else
          false
        end
      end

      def commit?
        matches = line.match(/(?<=^commit )(.*)/)

        if matches
          @commit = matches[0]
          true
        else
          false
        end
      end
  end
end

# p "====================================="
# p Gemstory::Reader.new.call
