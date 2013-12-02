require "rubygems"
require 'pathname'
gem "minitest"

base_dir = Pathname.new(File.expand_path(__FILE__)).dirname.parent
lib_dir = base_dir + "lib"
test_dir = base_dir + "test"
$:.unshift(lib_dir.to_s)
$:.unshift(test_dir.to_s)

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'json'
  SimpleCov.start do
    minimum_coverage 100
    add_filter "/test/"
  end
end

require 'coveralls'
if Coveralls.will_run?
  Coveralls.wear!
end

require "minitest/autorun"