#! /usr/bin/env ruby

require 'yaml'

require 'comics2feed/comic'

module Comics2Feed

  class Base
    # 1. Loop through configurated comics
    # 2. Load comic url
    #    - Parse site, find link and image
    #    - If link not found use format string
    # 3. Add to cache if not found
    # 4. Update rss feed if needed
    def initialize
      config = YAML.load_file(find_config_file)
      @comics = []
      config['comics'].each do |k,v|
        v['cache_dir'] = config['cache_dir']
        v['output_dir'] = config['output_dir']
        @comics << Comic.new(k,v)
      end
    end

    def update_comics
      @comics.each do |c|
        c.update
      end
    end

    def find_config_file
      [File.join(Dir.home, ".comics2feed.yml"),
       File.join(Dir.pwd, "config.yml")].select do |f|
        File.exist?(f)
      end.first
    end
  end
end
