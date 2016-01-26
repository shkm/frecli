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

    def self.time
      projects = Frecli.projects.sort { |x, y| x.name <=> y.name }

      puts "Select a project to time:\n\n"

      projects.each_with_index do |project, i|
        puts "[#{i + 1}] #{project.name}"
      end

      print "\n\nProject: "

      selection = STDIN.gets.chomp.to_i

      unless (1..projects.count).include? selection
        puts "Project invalid."

        return
      end

      project = projects[selection - 1]
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
