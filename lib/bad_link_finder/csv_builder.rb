require 'csv'

module BadLinkFinder
  class CSVBuilder
    def initialize(csv_output_file)
      @csv = CSV.new(csv_output_file, encoding: 'UTF-8')

      @csv << ['page_url', 'page_id', 'link', 'error_message', 'raw_error_message']
    end

    def <<(csv_data)
      link = csv_data[:link]

      @csv << [
        csv_data[:url],
        csv_data[:id],
        link.link,
        link.error_message,
        (link.exception.message if link.exception)
      ]
    end
  end
end
