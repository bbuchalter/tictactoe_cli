require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task :coverage do
  Rake::Task['collect_coverage'].invoke
  `open coverage/index.html`
end

task :build do
  Rake::Task['collect_coverage'].invoke
end

task :collect_coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].invoke
end

task :default => :test