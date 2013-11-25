require 'bad_link_finder/site_checker'
require 'bad_link_finder/csv_builder'
require 'pathname'

module BadLinkFinder
  def self.run
    ['MIRROR_DIR', 'REPORT_OUTPUT_FILE', 'SITE_HOST'].each do |var|
      raise EnvironmentVariableError.new("Missing environment variable #{var}") unless ENV.has_key?(var)
    end

    raise EnvironmentVariableError.new("MIRROR_DIR '#{ENV['MIRROR_DIR']}' does not exist") unless Dir.exist?(ENV['MIRROR_DIR'])

    bad_link_map = BadLinkFinder::SiteChecker.new(ENV['MIRROR_DIR'], ENV['SITE_HOST']).run
    csv_builder = CSVBuilder.new(bad_link_map)

    report_path = Pathname.new(ENV['REPORT_OUTPUT_FILE'])
    report_path.parent.mkpath
    report_path.open('w') do |file|
      file.write(csv_builder)
    end
  end

  class EnvironmentVariableError < ArgumentError; end
end
