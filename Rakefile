# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "meteoub-gem"
  gem.homepage = "http://github.com/apuratepp/meteoub-gem"
  gem.license = "MIT"
  gem.summary = %Q{A rewrite of the MeteoUB library wich gets, parses and stores weather data from infomet.am.ub.es}
  gem.description = %Q{A rewrite of the MeteoUB library wich gets, parses and stores weather data from infomet.am.ub.es}
  gem.email = "apuratepp@gmail.com"
  gem.authors = ["Josep"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
