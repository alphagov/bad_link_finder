require 'bundler/setup'
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("..", __FILE__)

require 'minitest/autorun'
require 'support/matchers'

require 'pathname'
APP_ROOT = Pathname.new(File.join(File.dirname(__FILE__), '..'))
FIXTURES_ROOT = APP_ROOT+'test/fixtures'
TMP_ROOT = APP_ROOT+'tmp'
