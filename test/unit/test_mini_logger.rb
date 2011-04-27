$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. lib] ) )


require 'rubygems'
require 'shoulda'
require 'config_context'
require 'file/tail'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  context "A default logger" do

    setup do
      @dl = MiniLogger.configure()
    end
    
    should "create a logger in debug level" do
      assert( @dl.debug? )
    end
  end

  
  context "A bad configured logger" do

    should "raise and ArgumentError" do
      
      bad_config_file = File.join( File.dirname( __FILE__ ), %w[.. fixtures bad_test_settings.yml] )
      
      assert_raises( ArgumentError ) { MiniLogger.configure( ConfigContext.load( bad_config_file ) ) }
      assert_raises( ArgumentError ) { MiniLogger.configure( :log_level=>"bad_log_level" ) }
    end
  end
  
  
  context "A well configured logger" do
    
    setup do
      
      config_file  = File.join( File.dirname( __FILE__ ), %w[.. fixtures test_settings.yml] )
      @mld         = MiniLogger.configure( ConfigContext.load( config_file ) )

      class MyLogFile < File
        
        include File::Tail
      end
      
      @log_file          = MyLogFile.new( ConfigContext.log_channel )
      @log_file.interval = 10
      
      @log_file.backward( 1 )
      @log_file.tail(1) #Skip file header
    end
    
    teardown do    
      File.delete( ConfigContext.log_channel ) if File.exist?( ConfigContext.log_channel )
    end
    
    should "write >= debug message" do
      
      assert( @mld.debug( "debug" ) )
      assert( @log_file.tail( 1 )[0] =~ /^D\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)DEBUG \-\- : debug/ )
      assert( @mld.info( "info" ) )
      assert( @log_file.tail( 1 )[0] =~ /^I\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)INFO \-\- : info/ )
      assert( @mld.warn( "warn" ) )
      assert( @log_file.tail( 1 )[0] =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)WARN \-\- : warn/ )
      assert( @mld.error( "error" ) )
      assert( @log_file.tail( 1 )[0] =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)ERROR \-\- : error/ )
      assert( @mld.fatal( "fatal" ) )
      assert( @log_file.tail( 1 )[0] =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)FATAL \-\- : fatal/ )
    end

    should "write >= info message" do
      
      assert( @mld.info( "info" ) )
      assert( @log_file.tail( 1 )[0] =~ /^I\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)INFO \-\- : info/ )
      assert( @mld.warn( "warn" ) )
      assert( @log_file.tail( 1 )[0] =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)WARN \-\- : warn/ )
      assert( @mld.error( "error" ) )
      assert( @log_file.tail( 1 )[0] =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)ERROR \-\- : error/ )
      assert( @mld.fatal( "fatal" ) )
      assert( @log_file.tail( 1 )[0] =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)FATAL \-\- : fatal/ )
    end
      
    should "write >= warn message" do
      
      assert( @mld.warn( "warn" ) )
      assert( @log_file.tail( 1 )[0] =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)WARN \-\- : warn/ )
      assert( @mld.error( "error" ) )
      assert( @log_file.tail( 1 )[0] =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)ERROR \-\- : error/ )
      assert( @mld.fatal( "fatal" ) )
      assert( @log_file.tail( 1 )[0] =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)FATAL \-\- : fatal/ )
    end
      
    should "write >= error message" do
      
      assert( @mld.error( "error" ) )
      assert( @log_file.tail( 1 )[0] =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)ERROR \-\- : error/ )
      assert( @mld.fatal( "fatal" ) )
      assert( @log_file.tail( 1 )[0] =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)FATAL \-\- : fatal/ )
    end
      
    should "write a fatal message" do
      
      assert( @mld.fatal( "fatal" ) )
      assert( @log_file.tail( 1 )[0] =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #(.+)\](\s*)FATAL \-\- : fatal/ )
    end

    should "be in DEBUG level" do
      
      assert( @mld.debug? )
    end

    should "change log level to INFO" do
      
      @mld.level = MiniLogger::INFO 
      assert( @mld.info? )
    end

    should "change log level to WARN" do
      
      @mld.level = MiniLogger::WARN 
      assert( @mld.warn? )
    end

    should "change log level to ERROR" do
      
      @mld.level = MiniLogger::ERROR
      assert( @mld.error? )
    end
  end
end