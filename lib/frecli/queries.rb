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
        lookup(:projects, as: FreckleApi::Project, refresh: refresh)
          .sort_by(&:name)
      end

      def project(id)
        api.project(id)
      end

      def timers(refresh: refresh)
        lookup(:timers, as: FreckleApi::Timer, refresh: refresh)
          .sort_by { |timer| timer.project.name }
      end

      def timer_log(timer, description = nil)
        timer.log!(api, description: description)
      end

      def timer(project_id = nil)
        api.timer(project_id) || timer_current
      end

      def timer_current(refresh: refresh)
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

      def lookup(key, refresh: false, as: Hash, api_fallback: true)
        if cache.uncached?(key) || refresh
          raise Frecli::Cache::NotCachedError.new(key: key) unless api_fallback

          cache.cache!(key, api.send(key))
        end

        cache.get(key, as: as)
      end
    end
  end
end
