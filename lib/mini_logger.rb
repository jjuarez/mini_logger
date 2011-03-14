require 'rubygems'
require 'logger'


module MiniLogger
  extend self
    
  LOG_LEVEL_MAP = {
    :debug   =>::Logger::DEBUG,
    :info    =>::Logger::INFO,
    :warn    =>::Logger::WARN,
    :error   =>::Logger::ERROR,
    :faltal  =>::Logger::FATAL
  }
  
  DEBUG   = LOG_LEVEL_MAP[:debug]
  INFO    = LOG_LEVEL_MAP[:info]
  WARN    = LOG_LEVEL_MAP[:warn]
  ERROR   = LOG_LEVEL_MAP[:error]
  FATAL   = LOG_LEVEL_MAP[:fatal]

  DEFAULT_LOGCHANNEL      = STDERR
  DEFAULT_LOGLEVEL        = LOG_LEVEL_MAP[:info]
  DEFAULT_DATETIME_FORMAT = "%Y/%m/%d %H:%M:%S"


  def configure( atts = {} )
    
    log_channel = atts[:log_channel] ? atts[:log_channel] : DEFAULT_LOGCHANNEL
    log_level   = LOG_LEVEL_MAP.has_value?( atts[:log_level] ) ? atts[:log_level] : DEFAULT_LOGLEVEL
    dt_format   = atts[:dt_format] ? atts[:dt_format] : DEFAULT_DATETIME_FORMAT  
      
    @logger                 ||= ::Logger.new( log_channel )
    @logger.level           ||= log_level
    @logger.datetime_format ||= dt_format
    
    self
  end


  def level( )
    self.configure unless @logger
    
    @logger.level
  end
  
  
  def level=( new_log_level )
    
    self.configure unless @logger

    if LOG_LEVEL_MAP.has_value?( new_log_level )
      @logger.level = new_log_level
    else
      raise ArgumentError.new( "Bad log level: #{new_log_level}" )
    end 
  end
  
  
  def method_missing( method, *arguments, &block )

    self.configure unless @logger

    return unless( [:debug, :debug?, :info, :info?, :warn, :warn?, :error, :error?, :fatal].include?( method ) )
    @logger.send( method, *arguments, &block )
  end  
end