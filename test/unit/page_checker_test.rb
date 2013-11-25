require 'test_helper'
require 'bad_link_finder/page_checker'
require 'bad_link_finder/page'
require 'bad_link_finder/result_cache'

describe BadLinkFinder::PageChecker do

  describe "#page_url" do
    it "correctly merges the host with the page path" do
      assert_equal 'http://www.example.com/', build_page_checker('index.html').page_url.to_s
      assert_equal 'http://www.example.com/example/', build_page_checker('example/index.html').page_url.to_s
      assert_equal 'http://www.example.com/example/relative-example', build_page_checker('example/relative-example.html').page_url.to_s
    end
  end

  def build_page_checker(path)
    site_mirror = FIXTURES_ROOT+'www.example.com'
    page = BadLinkFinder::Page.new(site_mirror, path)
    BadLinkFinder::PageChecker.new('http://www.example.com/', page, BadLinkFinder::ResultCache.new)
  end

end
