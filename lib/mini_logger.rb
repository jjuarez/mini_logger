require 'rubygems'
require 'logger'


module MiniLogger
  extend self
  
  DEBUG = ::Logger::DEBUG
  INFO  = ::Logger::INFO
  WARN  = ::Logger::WARN
  ERROR = ::Logger::ERROR
  FATAL = ::Logger::FATAL

  DEFAULT_LOGCHANNEL      = STDERR
  DEFAULT_LOGLEVEL        = DEBUG
  DEFAULT_DATETIME_FORMAT = "%Y/%m/%d %H:%M:%S"


  def configure( atts = {} )
    
    @logger                 ||= ::Logger.new( atts[:log_channel] ? atts[:log_channel] : DEFAULT_LOGCHANNEL )
    @logger.level           = atts[:log_level] ? atts[:log_level] : DEFAULT_LOGLEVEL
    @logger.datetime_format = atts[:dt_format] ? atts[:dt_format] : DEFAULT_DATETIME_FORMAT
    
    self
  end

  
  def method_missing( method, *arguments, &block )

    self.configure unless @logger

    return unless( [:debug, :debug?, :info, :info?, :warn, :warn?, :error, :error?, :fatal].include?( method ) )

    case arguments.length
      when 0
        @logger.send( method )
      when 1 
        @logger.send( method, arguments[0] )
      else
        @logger.send( method, arguments )
    end
  end  
end