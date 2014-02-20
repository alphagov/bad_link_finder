# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bad_link_finder/version'
require 'pathname'

Gem::Specification.new do |spec|
  spec.name          = "bad_link_finder"
  spec.version       = BadLinkFinder::VERSION
  spec.authors       = ["Elliot Crosby-McCullough"]
  spec.email         = ["elliot.cm@gmail.com"]
  spec.summary       = "Tests links in static site mirrors"
  spec.description   = "Crawls a static site mirror testing all links.  Reports links which don't return 200 or redirect to a 200."
  spec.homepage      = "http://github.com/alphagov/bad_link_finder"
  spec.license       = "MIT"

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w(README.md LICENCE.txt)
  spec.executables   = ['bad_link_finder']
  spec.test_files    = Dir.glob('test/**/*')
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "~> 2.7"
  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "gem_publisher", "1.3.0"
end
