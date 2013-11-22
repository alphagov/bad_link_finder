require 'csv'

module BadLinkFinder
  class CSVBuilder
    def initialize(bad_link_map)
      @bad_link_map = bad_link_map
    end

    def to_s
      @to_s ||= CSV.generate(encoding: 'UTF-8') do |csv|
        csv << ['page_url', 'link', 'error_message', 'raw_error_message']

        @bad_link_map.each do |page_url, bad_links|
          bad_links.each do |bad_link|
            exception_message = bad_link.exception.message if bad_link.exception
            csv << [page_url, bad_link.link, bad_link.error_message, exception_message]
          end
        end
      end
    end
  end
end
