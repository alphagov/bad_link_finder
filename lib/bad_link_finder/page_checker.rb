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
      @bad_links ||= @page.links.map { |link| fetch_or_build(link) }.reject(&:valid?)
    end

  private

    def fetch_or_build(link)
      @result_cache.fetch(link) || @result_cache.store(link, BadLinkFinder::Link.new(@page_url, link))
    end
  end
end
