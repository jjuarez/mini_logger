begin
  require 'jeweler'
  require 'fileutils'
  require 'file/tail'
  require 'config_context'
  
rescue LoadError => le
  fail( le.message )
end

$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )

begin
  require 'version'
  
rescue LoadError => le
  fail( "You need to declare the gem version in the file ./lib/version.rb (#{le.message})" )
end


desc "Clean all temporary stuff..."
task :clean do
  
  begin    
    FileUtils.remove_dir( File.join( File.dirname( __FILE__ ), 'pkg' ), true )
  rescue Exception => e
    fail( e.message )
  end
end


desc "Build the gem"
task :build =>[:clean] do

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = Version::NAME
    gemspec.version           = Version::NUMBER
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A tiny logger utility for small applications'
    gemspec.description       = 'A minimal standard Logger wrapper perfect for minimal CLI applications'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*.rb' ]    
  end
end


desc "Testing..."
task :test => [:build] do 
  require 'rake/runtest'

  Rake.run_tests 'test/unit/test_*.rb'
end


desc "The default task..."
task :default=>[:test]
