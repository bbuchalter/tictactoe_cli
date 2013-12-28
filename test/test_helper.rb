require 'rubygems'
require 'pathname'
gem 'minitest'

def base_dir
  Pathname.new(File.expand_path(__FILE__)).dirname.parent
end

def lib_dir
  base_dir + 'lib'
end

def test_dir
  base_dir + 'test'
end

$LOAD_PATH.unshift(lib_dir.to_s)
$LOAD_PATH.unshift(test_dir.to_s)

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'json'
  SimpleCov.start do
    minimum_coverage 100
    add_filter '/test/'
  end
end

require 'coveralls'
Coveralls.wear! if Coveralls.will_run?

require 'minitest/autorun'

def output_scenarios
  f = File.open(test_dir + 'support/output_scenarios.yml')
  y = YAML.load(f)
  f.close
  y
end
