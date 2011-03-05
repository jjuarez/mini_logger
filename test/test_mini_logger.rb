$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. lib] ) )


require 'rubygems'
require 'shoulda'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  context "A Default Logger" do
    
    setup do
      MiniLogger.configure( :log_channel=>STDOUT, :log_level=>MiniLogger::DEBUG )
    end
  
    should "be level DEBUG" do
      assert( MiniLogger.debug? )
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

    should "change log level" do
      MiniLogger.level = MiniLogger::ERROR
      assert_equal( MiniLogger.level, MiniLogger::ERROR )
    end
  end
end