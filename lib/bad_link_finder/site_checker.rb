require 'bad_link_finder/site'
require 'bad_link_finder/result_cache'
require 'bad_link_finder/page_checker'

module BadLinkFinder
  class SiteChecker
    def initialize(mirror_dir, host, csv_builder, start_from = nil, logger = BadLinkFinder::NullLogger.new)
      @mirror_dir = File.expand_path(mirror_dir)
      @host = host
      @csv_builder = csv_builder
      @start_from = start_from
      @result_cache = BadLinkFinder::ResultCache.new
      @logger = logger
    end

    def run
      BadLinkFinder::Site.new(@mirror_dir, @start_from).each do |page|
        page_checker = BadLinkFinder::PageChecker.new(@host, page, @result_cache, @logger)
        @logger.info "Checking page #{page.path} as #{page_checker.page_url}"

        page_checker.bad_links.each do |link|
          @csv_builder << {
            url: page_checker.page_url,
            id: page.id,
            link: link
          }
        end
      end

      nil
    end
  end
end
