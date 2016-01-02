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

      def timer(id)
        api.timer(id)
      end
    end
  end
end
