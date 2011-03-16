$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. lib] ) )


require 'rubygems'
require 'shoulda'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  context "A Default Logger" do
    
    setup do
      @mini_logger_debug = MiniLogger.configure( :log_channel=>"/dev/null", :log_level=>MiniLogger::DEBUG )
    end
    
    should "a info log level" do
      assert( MiniLogger.configure.info? )
    end
    
    should "write a debug line" do
      assert( @mini_logger_debug.debug( "debug" ) )
    end  

    should "write a info line" do
      assert( @mini_logger_debug.info( "info" ) )
    end  
  
    should "write a warn line" do
      assert( @mini_logger_debug.warn( "warn" ) )
    end  
  
    should "write a error line" do
      assert( @mini_logger_debug.error( "error" ) )
    end  
  
    should "write a fatal line" do
      assert( @mini_logger_debug.fatal( "fatal" ) )
    end

    should "change log level to ERROR" do
      
      @mini_logger_debug.level = MiniLogger::ERROR
      assert( @mini_logger_debug.error? )
    end

    should "change log level to WARN" do
      
      @mini_logger_debug.level = MiniLogger::WARN 
      assert( @mini_logger_debug.warn? )
    end

    should "change log level to INFO" do
      
      @mini_logger_debug.level = MiniLogger::INFO 
      assert( @mini_logger_debug.info? )
    end

    should "change log level to DEBUG" do
      
      @mini_logger_debug.level = MiniLogger::DEBUG 
      assert( @mini_logger_debug.debug? )
    end

    should "raise an ArgumentError" do
      
      assert_raise( ArgumentError ) { @mini_logger_debug.level = "bad value" }
    end
  end
end