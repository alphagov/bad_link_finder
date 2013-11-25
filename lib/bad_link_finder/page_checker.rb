require 'bad_link_finder/link'

module BadLinkFinder
  class PageChecker
    def initialize(host, page, result_cache)
      host = host.chomp('/') + '/'
      @page = page
      @page_url = URI.join(host, page.path).to_s
      @result_cache = result_cache
    end

    attr_reader :page_url

    def bad_links
      @bad_links ||= @page.links.map do |raw_link|
        link = @result_cache.fetch(raw_link) || @result_cache.store(raw_link, BadLinkFinder::Link.new(@page_url, raw_link))

        link unless link.valid?
      end.compact
    end
  end
end
