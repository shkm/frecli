require 'fuzzy_match'

class Frecli
  module Cli
    def self.status
      timer = Frecli.timer_current

      if timer
        puts "Timer running on #{timer.project.name} (#{timer.formatted_time})."
      else
        puts "No timer running."
      end
    end

    def self.time(project_query)
      project = FuzzyMatch
        .new(Frecli.projects, read: :name)
        .find(project_query)

      timer = Frecli.timer_start(project)

      puts "Now timing #{project.name} (#{timer.formatted_time})."
    end

    def self.pause
      timer = Frecli.timer_current

      unless timer
        puts 'No timer running.'
        return
      end

      if Frecli.timer_pause(timer)
        puts "Paused #{timer.project.name} (#{timer.formatted_time})."
      else
        puts 'Could not pause timer.'
      end
    end

    def self.log(description = '')
      timer = Frecli.timer_current

      unless timer
        puts 'No timer running.'
        return
      end

      if Frecli.timer_log(timer, description)
        puts "Logged #{timer.project.name} (#{timer.formatted_time})."
        puts %Q("#{description}") unless description.empty?
      else
        puts 'Could not log timer.'
      end
    end
  end
end
