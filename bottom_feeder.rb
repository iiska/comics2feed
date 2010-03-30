#! /usr/bin/env ruby

require 'yaml'
require 'openuri'

require 'rubygems'
require 'nokogiri'

module BottomFeeder
  class Strip
    # 1. use link format as a erb template binded to this strip
    # config = {'img_url' => ?, 'link' => ?, 'link_format' => ?}
    def initialize(config)
    end

  end

  class Comic
    def initialize(name, config)
      @name = name
      @config = config
      p config
    end

    def parse_strip()
      doc = Nokogiri::HTML(open(@config.url))
      sc = {}
      sc['img_url'] = doc.css(@config['image_selector']).first.src
      if (@config['link_selector'])
        sc['link'] = doc.css(@config['link_selector']).first.href
      else
        sc['link_format'] = @config['link_format']
      end
      Strip.new(sc)
    end

    def load_cache()
      cache = YAML.load_file("#{@config['cache_dir']}/#{@name}.yml")
      @strips = cache.map{|c|Strip.new(c)}
    end

    def write_cache()
      cache = @strips.map{|s|s.config}

    end

    # Check if comic is updated and generate feed if needed.
    def update()
      n = parse_strip
      if not @strips.include?(n)
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
        v['cache_dir'] = config['cache_dir']
        @comics << BottomFeeder::Comic.new(k,v)
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
