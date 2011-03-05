$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. lib] ) )


require 'rubygems'
require 'shoulda'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  context "A Default Logger" do
    
    setup do
      MiniLogger.configure( :log_channel=>"/dev/null", :log_level=>MiniLogger::DEBUG )
    end
  
    should "write a debug line" do
      assert( MiniLogger.debug( "debug" ) )
    end  

    should "write a info line" do
      assert( MiniLogger.info( "info" ) )
    end  
  
    should "write a warn line" do
      assert( MiniLogger.warn( "warn" ) )
    end  
  
    should "write a error line" do
      assert( MiniLogger.error( "error" ) )
    end  
  
    should "write a fatal line" do
      assert( MiniLogger.fatal( "fatal" ) )
    end

    should "log level ERROR" do
      MiniLogger.configure( :log_level=>MiniLogger::ERROR )
      assert( MiniLogger.error? )
    end

    should "log level WARN" do
      MiniLogger.configure( :log_level=>MiniLogger::WARN )
      assert( MiniLogger.warn? )
    end

    should "log level INFO" do
      MiniLogger.configure( :log_level=>MiniLogger::INFO )
      assert( MiniLogger.info? )
    end

    should "log level DEBUG" do
      MiniLogger.configure( :log_level=>MiniLogger::DEBUG )
      assert( MiniLogger.debug? )
    end
  end
end