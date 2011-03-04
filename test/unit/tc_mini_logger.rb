$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )


require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  context "A Logger" do
    
    MiniLogger.configure( :log_channel=>STDOUT, :log_level=>::Logger::DEBUG )
  end
  
  should "Debug" do
    
    assert( MiniLogger.debug( "debug XXX" ) )
  end  

  should "Info" do
    
    assert( MiniLogger.info( "info XXX" ) )
  end  
  
  should "Warn" do
    
    assert( MiniLogger.warn( "warn XXX" ) )
  end  
  
  should "Error" do
    
    assert( MiniLogger.error( "error XXX" ) )
  end  
  
  should "Fatal" do
    
    assert( MiniLogger.fatal( "fatal XXX" ) )
  end
end