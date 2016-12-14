class Frecli
  class Cache
    class PathNotFoundError < StandardError
      def initialize(message = nil, key: nil)
        message ||= if key
                      "No such cache path found: `#{key}`."
                    else
                      'No such cache path found.'
                    end

        super(message)
      end
    end

    class NotCachedError < StandardError
      def initialize(message = nil, key: nil)
        message ||= if key
                      "No such cache available: `#{key}`."
                    else
                      'No such cache available.'
                    end
      end
    end

    PATHS = {
      projects: '/projects.json'
    }.freeze

    def initialize(cache_path, ttl)
      @cache_path = cache_path.sub(/^~/, Dir.home)
      @ttl = ttl # cache ttl in minutes

      FileUtils.mkdir_p @cache_path
    end

    def cached?(key)
      path = cache_path(key)

      File.exist?(path) && within_ttl?(path)
    end

    def uncached?(key)
      !cached?(key)
    end

    def get(key, as: Hash)
      raise NotCachedError.new(key: key) if uncached?(key)

      File.open(cache_path(key)) do |file|
        collection = JSON.load(file)

        return collection.map do |record|
          record.is_a?(as) ? record : as.new(record)
        end
      end
    end

    def cache!(key, objects)
      File.open(cache_path(key), 'w+') do |file|
        JSON.dump objects, file
      end
    end

    private

    def cache_path(key = nil)
      return @cache_path unless key
      raise PathNotFoundError.new(key: key) unless PATHS.key?(key)

      [@cache_path.sub(%r{/\Z}, ''), PATHS[key]].join '/'
    end

    def within_ttl?(path)
      (Time.now - File.mtime(path)) <= ttl_in_seconds
    end

    def ttl_in_seconds
      @ttl * 60
    end
  end
end
