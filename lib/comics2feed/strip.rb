require 'uri'
require 'erb'

module Comics2Feed

  class Strip
    attr_reader :config
    attr_reader :link
    attr_reader :img_url
    attr_reader :title
    attr_reader :date
    # 1. use link format as a erb template binded to this strip
    # config = {'img_url' => ?, 'link' => ?, 'link_format' => ?}
    def initialize(config)
      @title = config['title']
      @img_url = config['img_url']
      @img_basename = File.basename URI.parse(config['img_url']).path, ".*"
      @date = config['date']
      @link = config['link'] ||
        ERB.new(config['link_format']).result(binding)
    end

    def hash
      @link.hash
    end

    def eql?(a)
      self == a
    end

    def equal?(a)
      self == a
    end

    def ==(a)
      @link == a.link and @img_url == a.img_url
    end

    def to_yaml(e)
      {'link' => @link, 'title' => @title, 'img_url' => @img_url,
        'date' => @date}.to_yaml(e)
    end

  end
end
