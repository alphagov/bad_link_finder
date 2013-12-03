require 'nokogiri'

module BadLinkFinder
  class Page
    def initialize(mirror_dir, path)
      @path = strip_html_ending(path)

      file = mirror_dir + path
      @doc = Nokogiri::HTML(file.read)
      file.close
    end

    attr_reader :path

    def links
      @links ||= @doc.css('a').map do |a|
        strip_html_ending(a['href']) unless ignore_link?(a['href'])
      end.compact
    end

    def id
      @id ||= begin
        if (article = @doc.xpath('(//article[not(ancestor::article)])').first)
          article['id']
        end
      end
    end

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
