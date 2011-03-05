require 'rubygems'
require 'logger'


module MiniLogger
  extend self
  
  DEBUG = ::Logger::DEBUG
  INFO  = ::Logger::INFO
  WARN  = ::Logger::WARN
  ERROR = ::Logger::ERROR
  FATAL = ::Logger::FATAL

  DEFAULT_LOGCHANNEL = STDERR
  DEFAULT_LOGLEVEL   = DEBUG
  VALID_METHODS      = [ :debug, :info, :warn, :error, :fatal ]


  def configure( atts = {} )
    
    atts[:log_channel] ||= DEFAULT_LOGCHANNEL
    atts[:log_channel] ||= DEFAULT_LOGLEVEL

    @logger            ||= ::Logger.new( atts[:log_channel] )
    @logger.level      ||= atts[:log_level]
    
    self
  end

  def debug?
    (@logger.level == DEBUG)
  end

  def level
    @logger.level
  end

  
  def level=( new_level )
    @logger.level=new_level
  end

  
  def method_missing( method, *arguments, &block )

    self.configure unless @logger

    if( VALID_METHODS.include?( method ) )
      if( block_given? )
        @logger.send( method, arguments.length == 1 ? arguments[0] : arguments, block )
      else
        @logger.send( method, arguments.length == 1 ? arguments[0] : arguments )
      end
    end
  end  
end