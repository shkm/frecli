class Frecli
  module Queries
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def api
        @api ||= FreckleApi.new(Settings[:api_key])
      end

      def cache
        @cache ||= Cache.new(Settings[:cache_path], Settings[:cache_ttl])
      end

      def projects(refresh: false)
        cache_or_api(:projects, as: FreckleApi::Project, refresh: refresh)
          .sort_by(&:name)
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

      def cache_or_api(key, refresh: false, as: Hash)
        cache.cache!(key, api.send(key)) if refresh || cache.uncached?(key)

        cache.get(key, as: as)
      end
    end
  end
end
