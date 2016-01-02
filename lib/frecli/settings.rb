require 'yaml'

class Frecli
  module Settings
    def self.settings(root_path: '/', reload: false)
      if reload || !@settings
        return (@settings = compile_settings(root_path: root_path))
      end

      @settings
    end

    def self.[](key)
      settings[key]
    end

    # Merges .frecli files down from root dir.
    # If .frecli is a dir, it will merge all files within.
    # Relevant ENV vars will always take precedence.
    def self.compile_settings(root_path: '/')
      {}.tap do |settings|
        setting_filenames(root_path: root_path).each do |name|
          settings.merge!(
            Hash[YAML.load(File.open name).map { |(k, v)| [k.to_sym, v] }])
        end

        settings[:api_key] = ENV['FRECKLE_API_KEY'] if ENV.include?('FRECKLE_API_KEY')
      end
    end

    def self.setting_filenames(root_path: '/')
      setting_paths(root_path: root_path).map do |path|
        filename = join_paths(path, '.frecli')

        next unless File.exist?(filename)

        if File.directory?(filename)
          Dir.glob(join_paths(filename, '*'))
        else
          filename
        end
      end.flatten.compact
    end

    # Return all the paths from root_path to the current dir.
    #
    # e.g.
    # ['/', '/Users', '/Users/isaac', '/Users/isaac/project']
    def self.setting_paths(root_path: '/')
      Dir
        .getwd
        .sub(root_path, '/')
        .split('/')
        .reject(&:empty?)
        .inject([root_path]) do |path, wd|
        path << join_paths(path.last, wd)
      end
    end

    def self.join_paths(*paths)
      separator = [*paths].first == '/' ? '' : '/'

      [*paths].join(separator)
    end
  end
end
