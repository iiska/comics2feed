require 'test_helper'

module Comics2Feed
  class StripTest < MiniTest::Unit::TestCase

    def setup
      @strip = Strip.new("title" => "Example strip",
                                      "img_url" => "example_img_url.png",
                                      "link" => "example_link")
    end

    def test_equals
      @another = Strip.new("title" => "Other strip",
                           "img_url" => "example_img_url.png",
                           "link" => "example_link")
      assert @strip == @another

      @diff_link = Strip.new("title" => "Another strip",
                             "img_url" => "example_img_url.png",
                             "link" => "different_link")
      @diff_img = Strip.new("title" => "Yet another strip",
                            "img_url" => "different.png",
                            "link" => "example_link")
      @diff = Strip.new("title" => "Other strip",
                        "img_url" => "diff_img_url.png",
                        "link" => "different_link")

      refute @strip == @diff_link
      refute @strip == @diff_img
      refute @strip == @diff
    end

  end
end
