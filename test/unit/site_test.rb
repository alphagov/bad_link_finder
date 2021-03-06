require 'test_helper'
require 'bad_link_finder/site'

describe BadLinkFinder::Site do

  before do
    @site_mirror = FIXTURES_ROOT+'www.example.com'
  end

  describe '#each' do
    it "loads all files from a directory and passes on the host" do
      site_map = [
        '',
        'example/',
        'example/relative-example'
      ]

      assert_same_elements site_map, BadLinkFinder::Site.new(@site_mirror).map { |page| page.path.to_s }
    end

    it "starts from a specific path if given" do
      site_map = [
        'example/relative-example',
        ''
      ]

      site = BadLinkFinder::Site.new(@site_mirror, 'example/relative-example.html')
      assert_equal site_map, site.map { |page| page.path.to_s }
    end
  end

end
