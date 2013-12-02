require 'bad_link_finder/site'
require 'bad_link_finder/result_cache'
require 'bad_link_finder/page_checker'

module BadLinkFinder
  class SiteChecker
    def initialize(mirror_dir, host, csv_builder)
      @mirror_dir = File.expand_path(mirror_dir)
      @host = host
      @csv_builder = csv_builder
      @result_cache = BadLinkFinder::ResultCache.new
    end

    def run
      BadLinkFinder::Site.new(@mirror_dir).each do |page|
        page_checker = BadLinkFinder::PageChecker.new(@host, page, @result_cache)
        puts "Checking page #{page.path} as #{page_checker.page_url}"

        page_checker.each_bad_link do |link|
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
