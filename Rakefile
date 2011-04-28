$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )

begin
  require 'version'
  
rescue LoadError => le
  fail( "You need to declare the gem version in the file ./lib/version.rb (#{le.message})" )
end


desc "Clean all temporary stuff"
task :clean do

  require 'fileutils'
  
  [ "coverage", "coverage.data", "pkg" ].each { |fd| FileUtils.rm_rf( fd ) }
end


desc "Build the gem"
task :build =>[:clean] do
  begin
    require 'jeweler'

  rescue LoadError => le
    fail( le.message )
  end

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = Version::NAME
    gemspec.version           = Version::NUMBER
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A tiny logger utility for small applications'
    gemspec.description       = 'A minimal standard Logger wrapper perfect for CLI applications'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*.rb' ]    
  end
end
 

desc "Measures unit test coverage"
task :coverage=>[:clean] do

  INCLUDE_DIRECTORIES = "lib:test"
  
  def run_coverage( files )

    fail( "No files were specified for testing" ) if files.length == 0
    sh "rcov --include #{INCLUDE_DIRECTORIES} --exclude gems/*,rubygems/* --sort coverage --aggregate coverage.data #{files.join( ' ' )}"
  end

  run_coverage Dir["test/**/*.rb"]
end


desc "Testing..."
task :test do
  require 'rake/runtest'
 
  Rake.run_tests 'test/unit/test_*.rb'
end


desc "The default task..."
task :default=>[:test]
