require 'rubygems'
require 'file/tail'


class TailFileHelper
  
  DEFAULT_BACKWARD = 1
  
  def initialize( log_file_name, backward=DEFAULT_BACKWARD )

    @log_file = File.new( log_file_name )
    
    @log_file.extend( File::Tail )
    @log_file.backward( backward )
    
    # Skilp Logger file header
    @log_file.tail( 1 )
  end
  
  def get_log_line( )
    
    @log_file.tail( 1 )[0]
  end
end