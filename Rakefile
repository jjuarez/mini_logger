$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

begin
  require 'version'
  
rescue LoadError => le
  fail("You need to declare the gem version in the file ./lib/version.rb (#{le.message})")
end


desc "Clean all temporary stuff"
task :clean do
  require 'fileutils'
  
  ["coverage", "coverage.data", "pkg"].each { |fd| FileUtils.rm_rf(fd) }
end


desc "Build the gem"
task :build =>:clean do
  begin
    require 'jeweler'

  rescue LoadError=>e
    fail(e.message)
  end

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = MiniLogger::Version::NAME
    gemspec.version           = MiniLogger::Version::NUMBER
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{MiniLogger::Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A tiny logger utility for small applications'
    gemspec.description       = 'A minimal standard Logger wrapper perfect for CLI applications'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{MiniLogger::Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']    
  end
end
 

desc "Measures unit test coverage"
task :coverage=>:clean do
  require 'rcov'
  
  system("rcov --include lib:test --exclude gems/* --sort coverage --aggregate coverage.data #{Dir['test/**/*.rb'].join(' ')}")
end


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|

  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = false
end

task :default=>:test
