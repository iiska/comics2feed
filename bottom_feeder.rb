#! /usr/bin/env ruby

require 'yaml'

module BottomFeeder
  class Strip
    # 1. use link format as a erb template binded to this strip
    def initialize(img_url, link, cache_dir)
    end

    def cache()
    end
  end

  class Comic
    def initialize(config)
      p config
    end
  end

  class Base
    # 1. Loop through configurated comics
    # 2. Load comic url
    #    - Parse site, find link and image
    #    - If link not found use format string
    # 3. Add to cache if not found
    # 4. Update rss feed if needed
    def initialize(config)
      @comics = []
      config['comics'].each do |k,v|
        @comics << BottomFeeder::Comic.new(v)
      end
    end
  end
end

def find_config_file()
  ["~/.bottom_feeder.yml", "config.yml"].select{|f|
    File.exist?(f)
  }.first
end

if $0 == __FILE__
  bf = BottomFeeder::Base.new(YAML.load_file(find_config_file))
end
