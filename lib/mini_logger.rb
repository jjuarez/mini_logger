require 'rubygems'
require 'logger'


module MiniLogger
  extend self

  DEFAULT_CONFIGURATION = { :log_channel=>STDERR, :log_level=>::Logger::INFO }
  VALID_METHODS         = [ :debug, :info, :warn, :error, :fatal ]

  def configure( atts = DEFAULT_CONFIGURATION )
    
    @logger       ||= ::Logger.new( atts[:log_channel] )
    @logger.level ||= atts[:log_level]
    
    self
  end

  def method_missing( method, *arguments, &block )

    self.configure unless @logger

    if( VALID_METHODS.include?( method ) )
      if( block_given? )
        @logger.send( method, arguments, block )
      else
        @logger.send( method, arguments )
      end
    end
  end  
end