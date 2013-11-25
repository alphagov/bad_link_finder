require 'bad_link_finder/site'
require 'bad_link_finder/result_cache'
require 'bad_link_finder/page_checker'

module BadLinkFinder
  class SiteChecker
    def initialize(mirror_dir, host)
      @mirror_dir = File.expand_path(mirror_dir)
      @host = host
      @result_cache = BadLinkFinder::ResultCache.new
    end

    def run
      bad_link_map = {}
      BadLinkFinder::Site.new(@mirror_dir).map do |page|
        page_checker = BadLinkFinder::PageChecker.new(@host, page, @result_cache)
        puts "Checking page #{page.path} as #{page_checker.page_url}"

        bad_links = page_checker.bad_links
        bad_link_map[page_checker.page_url] = bad_links if bad_links.any?
      end

      return bad_link_map
    end
  end
end
