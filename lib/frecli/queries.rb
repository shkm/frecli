class Frecli
  module Queries
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def api
        @api = FreckleApi.new(Settings[:api_key])
      end

      def projects
        api.projects
      end

      def project(id)
        api.project(id)
      end

      def timers
        api.timers
      end

      def timer_log(timer, description = nil)
        timer.log!(api, description: description)
      end

      def timer(project_id = nil)
        api.timer(project_id) || timer_current
      end

      def timer_current
        timers.detect { |timer| timer.state == :running }
      end

      def timer_start(project)
        FreckleApi::Timer.new(project: project).tap do |timer|
          timer.start!(api)
        end
      end

      def timer_pause(timer)
        timer.pause!(api)
      end
    end
  end
end
