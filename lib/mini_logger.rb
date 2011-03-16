require 'rubygems'
require 'logger'


module MiniLogger
  extend self
    
  LLM = {
    :debug  =>Logger::DEBUG,
    :info   =>Logger::INFO,
    :warn   =>Logger::WARN,
    :error  =>Logger::ERROR,
    :faltal =>Logger::FATAL
  }
  
  DEBUG = :debug
  INFO  = :info
  WARN  = :warn
  ERROR = :error
  FATAL = :fatal
  
  private
  def validate_log_level?( log_level )
    LLM.has_key?( log_level )
  end
  
  def get_log_level( log_level )
    LLM[log_level]
  end
  
  
  public
  def configure( atts = { } )
    
    @logger       = Logger.new( atts[:log_channel] ? atts[:log_channel] : STDERR )
    @logger.level = validate_log_level?( atts[:log_level] ) ? get_log_level( atts[:log_level] ) : Logger::INFO
    self
  end

  def level( ) 
    @logger || configure
    @logger.level
  end  
  
  def level=( new_log_level )
    
    @logger || configure
    
    if( validate_log_level?( new_log_level ) )
      @logger.level = get_log_level( new_log_level )
    else  
      raise ArgumentError.new( "Bad log level: #{new_log_level}" )
    end
  end
  
  def method_missing( method, *arguments, &block )

    @logger || configure

    if( [ :debug, :debug?, :info, :info?, :warn, :warn?, :error, :error?, :fatal ].include?( method ) )
      @logger.send( method, *arguments, &block )
    end
  end  
end