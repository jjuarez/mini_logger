$:.unshift( File.join( File.dirname( __FILE__ ), %w[.. .. lib] ) )

require 'test/unit'
require 'mocha'
require 'mini_logger'


class TestMiniLogger < Test::Unit::TestCase
  
  def test_case_all
    fail( "Not implemented yet" )
  end
end