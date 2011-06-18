require 'rubygems'
require 'file/tail'


class TailFileHelper
  
  def initialize(file, options={})

    options   = { :backward=>1 }.merge(options)
    @log_file = File.new(file)
    
    @log_file.extend(File::Tail)
    @log_file.backward(options[:backward])
    
    # Skilp Logger file header
    @log_file.tail(1)
  end
  
  def get_log_line
    @log_file.tail(1)[0].chomp
  end
end