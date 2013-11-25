require 'test_helper'
require 'webmock/minitest'
require 'bad_link_finder'

describe BadLinkFinder do

  before do
    stub_request(:any, 'http://www.example.com/example/').to_return(status: 200)
    stub_request(:any, 'http://www.example.com/example/relative-example').to_return(status: 302, headers: {'Location' => 'http://www.example.com/example/'})
    stub_request(:any, 'https://www.example.net/external-example.html').to_return(status: 500)
    stub_request(:any, 'http://www.example.com/example/?test=true&redirect=http://www.example.com/in-param-url/index.html').to_return(status: 404)

    ENV['MIRROR_DIR'] = (FIXTURES_ROOT+'www.example.com').to_s
    ENV['REPORT_OUTPUT_FILE'] = (TMP_ROOT+'bad_links.csv').to_s
    ENV['SITE_HOST'] = 'http://www.example.com/'
  end

  it "finds all broken links and exports to a CSV" do
    BadLinkFinder.run

    csv_string = File.read(ENV['REPORT_OUTPUT_FILE'])

    assert_match 'http://www.example.com/example/', csv_string
  end

  it "complains if key variables are missing" do
    ['MIRROR_DIR', 'REPORT_OUTPUT_FILE', 'SITE_HOST'].each do |var|
      ENV.delete(var)

      assert_raises(BadLinkFinder::EnvironmentVariableError) do
        BadLinkFinder.run
      end
    end
  end

  it "complains if the MIRROR_DIR does not exist" do
    ENV['MIRROR_DIR'] = (FIXTURES_ROOT+'this_does_not_exist').to_s

    assert_raises(BadLinkFinder::EnvironmentVariableError) do
      BadLinkFinder.run
    end
  end

end
