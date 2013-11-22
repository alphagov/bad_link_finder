require 'test_helper'
require 'webmock/minitest'
require 'bad_link_finder/link'

describe BadLinkFinder::Link do

  describe '#valid?' do
    it "approves fully qualified urls which get a good response" do
      stub_url("http://www.example.com", 200)
      link = build_link('http://www.example.com')

      assert link.valid?
    end

    it "approves relative paths which get a good response" do
      stub_url("http://www.example.com/somewhere/an-example-path", 200)
      link = build_link('an-example-path', page_url: 'http://www.example.com/somewhere/')

      assert link.valid?
    end

    it "approves absolute paths which get a good response" do
      stub_url("http://www.example.com/an-example-path", 200)
      link = build_link('/an-example-path', page_url: 'http://www.example.com/somewhere/')

      assert link.valid?
    end

    it "reports malformed links without checking the internet" do
      link = build_link('htt[]://{an-example-path}')

      refute link.valid?
      assert_equal "This link is in a bad format", link.error_message
    end

    it "reports links returning failure status codes" do
      stub_url("http://www.example.com/an-example-path", 404)
      link = build_link('/an-example-path')

      refute link.valid?
      assert_equal "This request returned a 404", link.error_message
    end

    it "reports URLs returning failure status codes" do
      stub_url("https://www.example.net/an-external-failure", 500)
      link = build_link('https://www.example.net/an-external-failure')

      refute link.valid?
      assert_equal "This request returned a 500", link.error_message
    end

    it "retries 405s as GET requests" do
      stub_request(:head, "http://www.example.com/an-example-path").to_return(status: 405)
      stub_request(:get, "http://www.example.com/an-example-path").to_return(status: 200)
      link = build_link('/an-example-path')

      assert link.valid?
    end
  end

  def stub_url(url, status)
    stub_request(:any, url).to_return(status: status)
  end

  def build_link(link_path, opts = {})
    page_url = opts[:page_url] || 'http://www.example.com'
    BadLinkFinder::Link.new(page_url, link_path)
  end

end
