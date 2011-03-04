$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )


begin
  require 'version'
rescue LoadError => le
  fail( le.message )
end


begin  
  require 'metric_fu'  
rescue LoadError => le
  fail( "You need metric_fu gem: #{le.message}" )
end


desc "Clean all temporary stuffs"
task :clean do
  
  begin
    require 'fileutils'
    
    [ './tmp', './pkg' ].each { |dir| FileUtils.remove_dir( dir, true ) }
  rescue LoadError => le
    fail( "You need fileutils gem: #{e.message}" )
  end
end


desc "Build the gem"
task :build =>[:clean] do

  begin
    require 'jeweler'
  rescue LoadError => e
    fail "Jeweler not available. Install it with: gem install jeweler( #{e.message} )"
  end

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = MiniLogger::Version::NAME
    gemspec.version           = MiniLogger::Version::VERSION
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{MiniLogger::Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A real simple logger utility'
    gemspec.description       = 'My tiny logger'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{MiniLogger::Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*rb' ]    
  end

  Jeweler::GemcutterTasks.new
end


desc "Testing..."
task :test => [:clean, :build] do 

  require 'rake/runtest'
  Rake.run_tests 'test/unit/tc_*.rb'
end


task :default=>[:build]