require 'logger'
require 'yaml'
require 'forwardable'


class MiniLogger
  extend Forwardable
  
  def_delegators :@logger, :debug, :info, :warn, :error, :fatal, :debug?, :info?, :warn?, :error?, :fatal?
  
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
  
  private
  def self.standarize_log_level(level)

    case level
      when String then LLM[level.downcase.to_sym]
      when Symbol then LLM[level.to_s.downcase.to_sym]
      else ::Logger::INFO
    end
  end
      
      
  public    
  def self.validate_log_level?(level)
    
    case level
      when String then LLM.has_key?(level.downcase.to_sym)
      when Symbol then LLM.has_key?(level.to_s.downcase.to_sym)
      else false
    end
  end

    
  def self.configure(*arguments)
   
    configuration = Hash.new
    
    case arguments[0]
      when String then configuration.merge!(YAML.load_file(arguments[0]))
      when Hash   then configuration.merge!(arguments[0])
      else configuration = { :dev=>STDERR, :level=>:debug }
    end

    configuration = { :log_channel=>STDERR, :log_level=>:info }.merge(configuration)  
      
    configuration[:dev]   ||= configuration[:log_channel]
    configuration[:level] ||= configuration[:log_level]   
    
    raise ArgumentError.new("Invalid log level") unless validate_log_level?(configuration[:level])

    configuration[:dev] = case configuration[:dev].to_s.downcase
      when /stdout/ then STDOUT
      when /stderr/ then STDERR
      else configuration[:dev]
    end

    self.new(configuration)
  end
  
  def initialize(options)
    
    @logger       = ::Logger.new(options[:dev])
    @logger.level = MiniLogger.standarize_log_level(options[:level])
    
    self 
  end
  
  def level=(level)
    
    raise ArgumentError.new("Invalid log level #{level.class.name}:'#{level}'") unless MiniLogger.validate_log_level?(level)
    @logger.level = MiniLogger.standarize_log_level(level)

    self
  end
  
  def level
     
    RLLM[@logger.level]
  end
end