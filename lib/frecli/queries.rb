class Frecli
  module Queries
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def api
        @api = FreckleApi.new(Settings[:api_key])
      end

      # The project which is currently being timed.
      def project_current
        project_id = timer_current.project.id

        # TODO: use a reload method instead.
        sleep 0.5
        project(project_id)
      end

      def projects
        api.projects
      end

      def project(id)
        api.project(id)
      end

      def timer_current
        timers.detect { |timer| timer.state == :running }
      end

      def timers
        api.timers
      end

      def timer(project_id)
        api.timer(project_id)
      end

    end
  end
end
