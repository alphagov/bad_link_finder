require 'test_helper'
require 'bad_link_finder/page'

describe BadLinkFinder::Page do

  describe '#path' do
    it "strips index.html and .html" do
      assert_equal '', build_page('index.html').path.to_s
      assert_equal 'example/', build_page('example/index.html').path.to_s
      assert_equal 'example/relative-example', build_page('example/relative-example.html').path.to_s
    end
  end

  describe '#links' do
    it "finds absolute paths, stripping index.html and .html" do
      assert_equal ['/example/'], build_page('index.html').links.map(&:to_s)
    end

    it "finds relative paths, stripping index.html and .html" do
      assert build_page('example/index.html').links.map(&:to_s).include?('relative-example')
    end

    it "finds and preserves external URLs" do
      assert build_page('example/index.html').links.map(&:to_s).include?('https://www.example.net/external-example.html')
    end

    it "preserves params and anchors on internal links" do
      page = build_page('example/relative-example.html')
      assert page.links.map(&:to_s).include?('/example/?test=true&redirect=http://www.example.com/in-param-url/index.html#section-1')
    end

    it "includes links with empty href" do
      assert build_page('example/relative-example.html').links.map(&:to_s).include?('')
    end

    it "excludes links with no href" do
      refute build_page('example/relative-example.html').links.include?(nil)
    end

    it "excludes links with an href containing only an anchor reference" do
      refute build_page('example/relative-example.html').links.map(&:to_s).include?('#section-2')
    end

    it "excludes mailto links" do
      refute build_page('example/relative-example.html').links.map(&:to_s).include?('mailto:test@example.com')
    end
  end

  describe '#page_id' do
    it "returns the id of the first topmost article" do
      assert_equal 'correct-article-id', build_page('example/relative-example.html').id
    end
  end

  def build_page(path)
    site_mirror = FIXTURES_ROOT+'www.example.com'
    BadLinkFinder::Page.new(site_mirror, path)
  end

end
