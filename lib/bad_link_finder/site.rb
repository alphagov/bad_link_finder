require 'pathname'
require 'bad_link_finder/page'

module BadLinkFinder
  class Site
    include Enumerable

    def initialize(mirror_dir, start_from = nil)
      @mirror_dir = mirror_dir.is_a?(String) ? Pathname.new(mirror_dir) : mirror_dir
      @start_from = start_from
    end

    def each
      Dir.chdir(@mirror_dir) do
        paths = Dir.glob('**/*').sort
        paths = paths[paths.index(@start_from)..-1] if @start_from

        paths.each do |path|
          next if File.directory?(path)
          yield BadLinkFinder::Page.new(@mirror_dir, path)
        end
      end
    end
  end
end
