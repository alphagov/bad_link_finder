require 'test_helper'
require 'bad_link_finder/result_cache'

describe BadLinkFinder::ResultCache do

  before do
    @cache = BadLinkFinder::ResultCache.new
  end

  it "returns a cache hit for URLs which differ only by anchor" do
    @cache.store('http://www.example.com#test123', 'value')
    assert_equal 'value', @cache.fetch('http://www.example.com#test567')

    @cache.store('http://www.example.com?test=true#test123', 'value')
    assert_equal 'value', @cache.fetch('http://www.example.com?test=true#test567')

    @cache.store('http://www.example.com?test=true#test123', 'value')
    refute_equal 'value', @cache.fetch('http://www.example.com?test=false#test567')
  end

  describe "#store" do
    it "returns the item stored" do
      assert_equal 'value', @cache.store('key', 'value')
    end
  end

  describe "#fetch" do
    it "returns fetched items on a hit" do
      @cache.store('key', 'value')
      assert_equal 'value', @cache.fetch('key')
    end

    it "returns nil on a miss" do
      assert_nil @cache.fetch('missing-key')
    end
  end

end
