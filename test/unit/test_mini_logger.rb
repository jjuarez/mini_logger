require 'rubygems'
require 'shoulda'
require 'file/tail'
require 'mini_logger'
require File.join( File.dirname( __FILE__ ), %w[.. helpers tail_file_helper.rb] )


class TestMiniLogger < Test::Unit::TestCase
  
  context "A default configured logger" do

    setup do
      @dl = MiniLogger.configure
    end
    
    should "create a logger in debug level" do
      assert( @dl.debug? )
    end
    
    should "validate diferent log levels" do
      
      MiniLogger::LLM.keys.each do |log_level|
      
        assert( @dl.validate_log_level?( log_level ) )
      end
      
      [:debug, :info, :warn, :error, :fatal].each do |log_level|
      
        assert( @dl.validate_log_level?( log_level ) )
      end
    end

    should "not validate diferent log levels" do
      
      ["foo", "bar", "bazz", :foo, :bar, :bazz].each do |log_level|
      
        assert( ! @dl.validate_log_level?( log_level ) )
      end
    end
  end

  context "A bad configured logger" do

    should "raise and ArgumentError" do
      
      assert_raises( ArgumentError ) { MiniLogger.configure( :log_level=>"bad_log_level" ) }
    end
  end
  
  context "A well configured logger" do
    
    TEST_DEBUG_MESSAGE = "debug message"
    TEST_INFO_MESSAGE  = "info message"
    TEST_WARN_MESSAGE  = "warn message"
    TEST_ERROR_MESSAGE = "error message"
    TEST_FATAL_MESSAGE = "fatal message"
    
    TEST_LOG_FILE_NAME = '/tmp/mini_logger_test.log'
    TEST_LOG_LEVEL     = 'debug'
    
    setup do
      
      @mld      = MiniLogger.configure( :log_channel=>TEST_LOG_FILE_NAME, :log_level=>TEST_LOG_LEVEL )
      @log_file = TailFileHelper.new( TEST_LOG_FILE_NAME )
    end
    
    teardown do    
      
      File.delete( TEST_LOG_FILE_NAME ) if File.exist?( TEST_LOG_FILE_NAME )
    end
    
    should "write >= debug message" do
      
      @mld.debug( TEST_DEBUG_MESSAGE )
      assert( @log_file.get_log_line =~ /^D\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] DEBUG \-\- : #{TEST_DEBUG_MESSAGE}/ )

      @mld.info( TEST_INFO_MESSAGE )
      assert( @log_file.get_log_line =~ /^I\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\]  INFO \-\- : #{TEST_INFO_MESSAGE}/  )
      
      @mld.warn( TEST_WARN_MESSAGE )
      assert( @log_file.get_log_line =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\]  WARN \-\- : #{TEST_WARN_MESSAGE}/  )
      
      @mld.error( TEST_ERROR_MESSAGE )
      assert( @log_file.get_log_line =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] ERROR \-\- : #{TEST_ERROR_MESSAGE}/ )
      
      @mld.fatal( TEST_FATAL_MESSAGE )
      assert( @log_file.get_log_line =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] FATAL \-\- : #{TEST_FATAL_MESSAGE}/ )
    end

    should "write >= info message" do
      
      @mld.info( TEST_INFO_MESSAGE )
      assert( @log_file.get_log_line =~ /^I\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\]  INFO \-\- : #{TEST_INFO_MESSAGE}/  )
      
      @mld.warn( TEST_WARN_MESSAGE )
      assert( @log_file.get_log_line =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\]  WARN \-\- : #{TEST_WARN_MESSAGE}/  )
      
      @mld.error( TEST_ERROR_MESSAGE )
      assert( @log_file.get_log_line =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] ERROR \-\- : #{TEST_ERROR_MESSAGE}/ )
      
      @mld.fatal( TEST_FATAL_MESSAGE )
      assert( @log_file.get_log_line =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] FATAL \-\- : #{TEST_FATAL_MESSAGE}/ )
    end
      
    should "write >= warn message" do
      
      @mld.warn( TEST_WARN_MESSAGE )
      assert( @log_file.get_log_line =~ /^W\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\]  WARN \-\- : #{TEST_WARN_MESSAGE}/  )
      
      @mld.error( TEST_ERROR_MESSAGE )
      assert( @log_file.get_log_line =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] ERROR \-\- : #{TEST_ERROR_MESSAGE}/ )
      
      @mld.fatal( TEST_FATAL_MESSAGE )
      assert( @log_file.get_log_line =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] FATAL \-\- : #{TEST_FATAL_MESSAGE}/ )
    end
      
    should "write >= error message" do
      
      @mld.error( TEST_ERROR_MESSAGE )
      assert( @log_file.get_log_line =~ /^E\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] ERROR \-\- : #{TEST_ERROR_MESSAGE}/ )
      
      @mld.fatal( TEST_FATAL_MESSAGE )
      assert( @log_file.get_log_line =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] FATAL \-\- : #{TEST_FATAL_MESSAGE}/ )
    end
      
    should "write a fatal message" do
      
      @mld.fatal( TEST_FATAL_MESSAGE )
      assert( @log_file.get_log_line =~ /^F\, \[\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6} #\d{5,6}\] FATAL \-\- : #{TEST_FATAL_MESSAGE}/ )
    end


    should "be in DEBUG level" do
      
      assert( @mld.debug? )
      assert_equal( @mld.level, MiniLogger::DEBUG )
    end

    should "change log level to INFO" do
      
      @mld.level = MiniLogger::INFO 

      assert( @mld.info? )
      assert_equal( @mld.level, MiniLogger::INFO )
    end

    should "change log level to WARN" do
      
      @mld.level = MiniLogger::WARN 

      assert( @mld.warn? )
      assert_equal( @mld.level, MiniLogger::WARN )
    end

    should "change log level to ERROR" do
      
      @mld.level = MiniLogger::ERROR

      assert( @mld.error? )
      assert_equal( @mld.level, MiniLogger::ERROR )
    end

    should "change log level to FATAL" do
      
      @mld.level = MiniLogger::FATAL

      assert( @mld.fatal? )
      assert_equal( @mld.level, MiniLogger::FATAL )
    end

    should "not change to invalid log level" do
      
      @mld.level = MiniLogger::DEBUG

      assert( @mld.debug? )
      assert_equal( @mld.level, MiniLogger::DEBUG )
      
      [:this, :is, :not, :valid, :log, :levels].each do |invalid_log_level|
        
        assert_raises( ArgumentError ) { @mld.level = invalid_log_level }
        assert( @mld.debug? )
        assert_equal( @mld.level, MiniLogger::DEBUG ) 
      end
    end
  end
end