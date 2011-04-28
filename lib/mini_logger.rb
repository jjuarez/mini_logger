require 'rubygems'
require 'logger'


module MiniLogger
  extend self
    
  DEBUG = :debug
  INFO  = :info
  WARN  = :warn
  ERROR = :error
  FATAL = :fatal

  LLM = {
    :debug =>::Logger::DEBUG,
    :info  =>::Logger::INFO,
    :warn  =>::Logger::WARN,
    :error =>::Logger::ERROR,
    :fatal =>::Logger::FATAL
  }  

  RLLM = {
    ::Logger::DEBUG => DEBUG,
    ::Logger::INFO  => INFO,
    ::Logger::WARN  => WARN,
    ::Logger::ERROR => ERROR,
    ::Logger::FATAL => FATAL
  }  
  
  DEFAULT_LOG_CHANNEL = STDERR
  DEFAULT_LOG_LEVEL   = DEBUG
  VALID_METHODS       = [ :debug, :info, :warn, :error, :fatal, :debug?, :info?, :warn?, :error?, :fatal? ]
  
  
  def validate_log_level?( log_level )
    
    LLM.has_key?( log_level )
  end
  
  
  def configure( attributes = { } )
    
    log_channel = attributes[:log_channel] ? attributes[:log_channel] : DEFAULT_LOG_CHANNEL
    log_level   = attributes[:log_level] ? attributes[:log_level].to_sym : DEFAULT_LOG_LEVEL
    
    raise ArgumentError.new( "Invalid log level: #{log_level}" ) unless( validate_log_level?( log_level ) )  

    @logger       = Logger.new( log_channel )
    @logger.level = LLM[log_level]

    self
  end


  def level( )
    
    @logger || configure
    
    RLLM[@logger.level]
  end  

  
  def level=( new_log_level )
    
    @logger || configure
    
    if( validate_log_level?( new_log_level ) )
      
      @logger.level = LLM[new_log_level]
    else
      
      raise ArgumentError.new( "Bad log level: #{new_log_level}" )
    end
  end
  
  
  def method_missing( method, *arguments, &block )

    @logger || configure
    
    @logger.send( method, *arguments, &block ) if( VALID_METHODS.include?( method ) )
  end  
end