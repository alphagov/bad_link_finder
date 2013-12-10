require 'bad_link_finder/site_checker'
require 'bad_link_finder/csv_builder'
require 'pathname'

module BadLinkFinder
  def self.run
    ['MIRROR_DIR', 'REPORT_OUTPUT_FILE', 'SITE_HOST'].each do |var|
      raise EnvironmentVariableError.new("Missing environment variable #{var}") unless ENV.has_key?(var)
    end

    raise EnvironmentVariableError.new("MIRROR_DIR '#{ENV['MIRROR_DIR']}' does not exist") unless Dir.exist?(ENV['MIRROR_DIR'])

    report_path = Pathname.new(ENV['REPORT_OUTPUT_FILE'])
    report_path.parent.mkpath

    csv_file = report_path.open('w')
    csv_builder = BadLinkFinder::CSVBuilder.new(csv_file)

    BadLinkFinder::SiteChecker.new(ENV['MIRROR_DIR'], ENV['SITE_HOST'], csv_builder, ENV['START_FROM']).run

    csv_file.close

    nil
  end

  class EnvironmentVariableError < ArgumentError; end
end
