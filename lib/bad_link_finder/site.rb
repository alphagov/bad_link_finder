require 'pathname'
require 'bad_link_finder/page'

module BadLinkFinder
  class Site
    include Enumerable

    def initialize(mirror_dir)
      @mirror_dir = mirror_dir.is_a?(String) ? Pathname.new(mirror_dir) : mirror_dir
    end

    def each
      Dir.chdir(@mirror_dir) do
        Dir.glob('**/*').each do |path|
          next if File.directory?(path)
          yield BadLinkFinder::Page.new(@mirror_dir, path)
        end
      end
    end
  end
end
