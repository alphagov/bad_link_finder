require 'nokogiri'

module BadLinkFinder
  class Page
    def initialize(mirror_dir, path)
      @path = strip_html_ending(path)

      file = mirror_dir + path
      doc = Nokogiri::HTML(file.read)
      @links = doc.css('a').map do |a|
        strip_html_ending(a['href']) unless ignore_link?(a['href'])
      end.compact
    end

    attr_reader :path, :links

  protected

    def strip_html_ending(href)
      if href.start_with?('http')
        href
      else
        href.sub(%r{(?<!\?)(?:index\.html|\.html)(.*)}, '\1')
      end
    end

    def ignore_link?(href)
      href.nil? || href.start_with?('#', 'mailto:')
    end
  end
end
