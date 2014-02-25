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

  describe "#bad_link_count" do
    before do
      stub_request(:any, 'http://www.example.com/example/').to_return(status: 200)
      stub_request(:any, 'http://www.example.com/example/relative-example').to_return(status: 302, headers: {'Location' => 'http://www.example.com/example/'})
      stub_request(:any, 'https://www.example.net/external-example.html').to_return(status: 500)
      stub_request(:any, 'http://www.example.com/example/?test=true&redirect=http://www.example.com/in-param-url/index.html').to_return(status: 404)
    end

    it "returns the number of bad links found on the page" do
      assert_equal 1, build_page_checker('example/index.html').bad_link_count
    end
  end

  def build_page_checker(path)
    site_mirror = FIXTURES_ROOT+'www.example.com'
    page = BadLinkFinder::Page.new(site_mirror, path)
    BadLinkFinder::PageChecker.new('http://www.example.com/', page, BadLinkFinder::ResultCache.new)
  end

end
