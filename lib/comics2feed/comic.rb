require 'hpricot'

require 'erb'
require 'yaml'
require 'open-uri'

require 'comics2feed/strip'

module Comics2Feed

  class Comic
    def initialize(name, config)
      @name = name
      @url = config['url']
      @config = config
      load_cache
    end

    def parse_strip()
      doc = open(@url) {|f| Hpricot(f)}
      sc = {}
      sc['title'] = doc.at("title").inner_text
      sc['img_url'] = doc.at(@config['image_selector'])['src']
      if (@config['link_selector'])
        if (@config['link_attr'])
          link_attr = @config['link_attr']
        else
          link_attr = "href"
        end
        sc['link'] = doc.at(@config['link_selector'])[link_attr]
      else
        sc['link_format'] = @config['link_format']
      end
      sc['date'] = Time.now
      Strip.new(sc)
    end

    def load_cache()
      f = "#{@config['cache_dir']}/#{@name}.yml"
      if File.exist?(f)
        @strips = YAML.load_file(f)
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
        @strips.unshift(n)
        generate_rss
        write_cache
      end
    end

    def generate_rss
      erb_file = File.expand_path('../../../templates/rss.xml.erb', __FILE__)
      template = ERB.new(File.open(erb_file, "r").read)
      File.open("#{@config['output_dir']}/#{@name}.xml", "w") do |f|
        f.puts(template.result(binding))
      end
    end
  end
end
