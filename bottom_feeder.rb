#! /usr/bin/env ruby

require 'yaml'

class BottomFeeder::Strip
  # 1. use link format as a erb template binded to this strip
end

class BottomFeeder::Comic
  def initialize(config)
  end
end

class BottomFeeder::Base
  # 1. Loop through configurated comics
  # 2. Load comic url
  #    - Parse site, find link and image
  #    - If link not found use format string
  # 3. Add to cache if not found
  # 4. Update rss feed if needed
  def initialize(config)
  end
end

def find_config_file(script_dir)
  # 1. ~/.bottom_feeder.yml
  # 2. config.yml
end

if $0 == __FILE__

end
