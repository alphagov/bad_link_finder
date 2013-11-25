require 'test_helper'
require 'bad_link_finder/csv_builder'
require 'ostruct'
require 'csv'

describe BadLinkFinder::CSVBuilder do

  it "flattens out the bad links map into a CSV structure" do
    bad_link_map = {
      'http://www.example.com/example/' => [
        mock_link(link: 'https://www.example.net/external-example.html', error_message: "This link returned a 404", exception: TestException.new('404 not found')),
        mock_link(link: 'relative-example', error_message: "Nope")
      ],
      'http://www.example.com/example/relative-example' => [
        mock_link(
          link: '/example/?test=true&redirect=http://www.example.com/in-param-url/index.html#section-1',
          error_message: "What even is this?",
          exception: TestException.new('Test exception')
        )
      ]
    }

    csv_builder = BadLinkFinder::CSVBuilder.new(bad_link_map)

    parsed_csv = CSV.parse(csv_builder.to_s)

    headers = parsed_csv.shift
    assert_equal ['page_url', 'link', 'error_message', 'raw_error_message'], headers

    assert_equal bad_link_map.values.flatten.count, parsed_csv.count

    bad_link_map.each do |page_url, links|
      links.each do |link|
        assert parsed_csv.include?([page_url, link.link, link.error_message, (link.exception.message if link.exception)])
      end
    end
  end

  def mock_link(attrs)
    OpenStruct.new(attrs)
  end

  class TestException < Exception; end

end
