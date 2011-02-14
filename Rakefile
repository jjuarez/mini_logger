$:.unshift( File.join( File.dirname( __FILE__ ), 'lib' ) )


begin
  require 'version'
rescue LoadError => le
  fail( "You need to declare the NAME and the VERSION of your gem in lib/version.rb file (le.message)" )
end


begin  
  require 'metric_fu'  
rescue LoadError => le
  fail( "You need metric_fu gem: #{le.message}" )
end


task :clean do
  
  begin
    require 'fileutils'
    
    [ './tmp', './pkg' ].each { |dir| FileUtils.remove_dir( dir, true ) }
  rescue LoadError => le
    fail( "You need fileutils gem: #{e.message}" )
  end
end


task :build =>[:clean] do
  begin
    require 'jeweler'
  rescue LoadError => e
    fail "Jeweler not available. Install it with: gem install jeweler( #{e.message} )"
  end

  Jeweler::Tasks.new do |gemspec|

    gemspec.name              = Version::NAME
    gemspec.version           = Version::INFO
    gemspec.rubyforge_project = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.license           = 'MIT'
    gemspec.summary           = 'A Config Context for little applications'
    gemspec.description       = 'My config DSL'
    gemspec.email             = 'javier.juarez@gmail.com'
    gemspec.homepage          = "http://github.com/jjuarez/#{Version::NAME}"
    gemspec.authors           = ['Javier Juarez']
    gemspec.files             = Dir[ 'lib/**/*.rb' ] + Dir[ 'test/**/*rb' ]
    
    gemspec.add_dependency 'config_context'
  end

  Jeweler::GemcutterTasks.new
end


task :test => [:clean, :build] do 
  require 'rake/runtest'
  Rake.run_tests 'test/unit/tc_*.rb'
end


task :default=>[:build]
