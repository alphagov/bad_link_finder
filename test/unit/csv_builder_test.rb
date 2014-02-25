require 'test_helper'
require 'bad_link_finder/csv_builder'

require 'tempfile'
require 'ostruct'
require 'csv'

describe BadLinkFinder::CSVBuilder do

  before do
    @report_output_file = Tempfile.new('csv')
    @report_output_file.unlink
  end

  after do
    @report_output_file.close
  end

  it "writes headers to the output file on creation" do
    BadLinkFinder::CSVBuilder.new(@report_output_file)
    @report_output_file.rewind
    parsed_csv = CSV.parse(@report_output_file.read)

    assert_equal ['page_url', 'page_id', 'bad_link_count', 'link', 'error_message', 'raw_error_message'], parsed_csv.shift
    assert_empty parsed_csv
  end

  describe '#<<' do
    it "writes a link to the CSV" do
      csv_builder = BadLinkFinder::CSVBuilder.new(@report_output_file)

      csv_builder << {
        url: 'http://www.example.com/example/',
        id: 'some-article-id',
        bad_link_count: 1,
        link: mock_link(link: 'https://www.example.net/external-example.html', error_message: "This link returned a 404", exception: TestException.new('404 not found'))
      }

      @report_output_file.rewind
      parsed_csv = CSV.parse(@report_output_file.read)

      parsed_csv.shift # drop headers

      assert_equal [
        'http://www.example.com/example/',
        'some-article-id',
        '1',
        'https://www.example.net/external-example.html',
        'This link returned a 404',
        '404 not found'
      ], parsed_csv.shift
    end

    it "ignores missing exceptions" do
      csv_builder = BadLinkFinder::CSVBuilder.new(@report_output_file)

      csv_builder << {
        url: 'http://www.example.com/example/',
        id: 'some-article-id',
        bad_link_count: 2,
        link: mock_link(link: 'relative-example', error_message: "Nope")
      }

      @report_output_file.rewind
      parsed_csv = CSV.parse(@report_output_file.read)

      parsed_csv.shift # drop headers

      assert_equal [
        'http://www.example.com/example/',
        'some-article-id',
        '2',
        'relative-example',
        'Nope',
        nil
      ], parsed_csv.shift
    end

    it "ignores missing ids" do
      csv_builder = BadLinkFinder::CSVBuilder.new(@report_output_file)

      csv_builder << {
        url: 'http://www.example.com/example/relative-example',
        bad_link_count: 1,
        link: mock_link(
          link: '/example/?test=true&redirect=http://www.example.com/in-param-url/index.html#section-1',
          error_message: 'What even is this?',
          exception: TestException.new('Test exception')
        )
      }

      @report_output_file.rewind
      parsed_csv = CSV.parse(@report_output_file.read)

      parsed_csv.shift # drop headers

      assert_equal [
        'http://www.example.com/example/relative-example',
        nil,
        '1',
        '/example/?test=true&redirect=http://www.example.com/in-param-url/index.html#section-1',
        'What even is this?',
        'Test exception'
      ], parsed_csv.shift
    end
  end

  def mock_link(attrs)
    OpenStruct.new(attrs)
  end

  class TestException < Exception; end

end
