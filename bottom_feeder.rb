#! /usr/bin/env ruby

require 'yaml'
require 'erb'
require 'uri'
require 'open-uri'

require 'rubygems'
require 'nokogiri'

module BottomFeeder

  class Strip
    attr_reader :config
    attr_reader :link
    attr_reader :img_url
    attr_reader :title
    # 1. use link format as a erb template binded to this strip
    # config = {'img_url' => ?, 'link' => ?, 'link_format' => ?}
    def initialize(config)
      @title = config['title']
      @img_url = config['img_url']
      @img_basename = File.basename URI.parse(config['img_url']).path, ".*"
      @link = config['link'] ||
        ERB.new(config['link_format']).result(binding)
    end

    def to_yaml(e)
      {'link' => @link, 'title' => @title, 'img_url' => @img_url}.to_yaml(e)
    end

  end

  class Comic
    def initialize(name, config)
      @name = name
      @url = config['url']
      @config = config
      load_cache
    end

    def parse_strip()
      doc = Nokogiri::HTML(open(@url))
      sc = {}
      sc['title'] = doc.css("title").text
      sc['img_url'] = doc.css(@config['image_selector']).attr('src').value
      if (@config['link_selector'])
        sc['link'] = doc.css(@config['link_selector']).attr('href').value
      else
        sc['link_format'] = @config['link_format']
      end
      Strip.new(sc)
    end

    def load_cache()
      f = "#{@config['cache_dir']}/#{@name}.yml"
      if File.exist?(f)
        cache = YAML.load_file(f)
        @strips = cache.map{|c|Strip.new(c)} || []
      else
        @strips = []
      end
    end

    def write_cache()
      File.open("#{@config['cache_dir']}/#{@name}.yml", "w") do |f|
        f.puts @strips.to_yaml
      end
    end

    # Check if comic is updated and generate feed if needed.
    def update()
      n = parse_strip
      if not @strips.include?(n)
        @strips << n
        generate_rss
        write_cache
      end
    end

    def generate_rss
      template = ERB.new(File.open("rss.xml.erb","r").read)
      File.open("#{@name}.xml", "w") do |f|
        f.puts(template.result(binding))
      end
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
      puts config.to_yaml
      @comics = []
      config['comics'].each do |k,v|
        v['cache_dir'] = config['cache_dir']
        @comics << BottomFeeder::Comic.new(k,v)
      end
    end

    def update_comics
      @comics.each do |c|
        c.update
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
  bf.update_comics
end
