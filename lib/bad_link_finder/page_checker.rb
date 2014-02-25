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

    def each_bad_link(&block)
      if @bad_links
        @bad_links.each(&block)
      else
        @bad_links = @page.links.map do |raw_link|
          link = @result_cache.fetch(raw_link) || @result_cache.store(raw_link, BadLinkFinder::Link.new(@page_url, raw_link))

          unless link.valid?
            yield link
            next link
          end
        end.compact
      end
    end

    def bad_link_count
      each_bad_link {|_|} unless @bad_links
      @bad_links.size
    end
  end
end
