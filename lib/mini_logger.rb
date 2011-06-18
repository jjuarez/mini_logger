require 'rubygems'
require 'logger'
require 'yaml'


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
      
  def self.standarize_log_level(ll)

    case ll
      when String then LLM[ll.downcase.to_sym]
      when Symbol then LLM[ll.to_s.downcase.to_sym]
    end
  end
      
      
  def self.validate_log_level?(ll)
    
    case ll
      when String then LLM.has_key?(ll.downcase.to_sym)
      when Symbol then LLM.has_key?(ll.to_s.downcase.to_sym)
      else false
    end
  end

    
  def configure(*arguments)
   
    configuration = {}
    
    case arguments[0]
      when String
        configuration.merge!(YAML.load_file(arguments[0]))
      when Hash                        
        configuration.merge!(arguments[0])
      else 
        configuration = { :dev=>STDERR, :level=>:debug } 
    end

    configuration.merge!({ :log_channel=>STDERR, :log_level=>:debug })  
      
    configuration[:dev]   = configuration[:log_channel] unless configuration[:dev]
    configuration[:level] = configuration[:log_level]   unless configuration[:level]   
    
    raise ArgumentError.new("Invalid log level") unless validate_log_level?(configuration[:level])

    configuration[:dev] = case configuration[:dev]
      when /(STDOUT|stdout)/ then STDOUT
      when /(STDERR|stderr)/ then STDERR
      when :stdout           then STDOUT
      when :stderr           then STDERR
      else configuration[:dev]
    end

    @logger       = ::Logger.new(configuration[:dev])
    @logger.level = standarize_log_level(configuration[:level])
    
    self
  end
  
  def level=(nll)
    
    if @logger
    
      raise ArgumentError.new("Invalid log level #{nll.class.name}:'#{nll}'") unless validate_log_level?(nll)
      @logger.level = standarize_log_level(nll)
      
      self
    end
  end
  
  def level!(nll)
    if @logger
    
      raise ArgumentError.new("Invalid log level #{nll.class.name}:'#{nll}'") unless validate_log_level?(nll)
      @logger.level = standarize_log_level(nll)
      
      self
    end
  end
  
  def level  
    RLLM[@logger.level] if @logger
  end
  
  def method_missing(method, *arguments, &block)
   
    if @logger && [:debug, :info, :warn, :error, :fatal, :debug?, :info?, :warn?, :error?, :fatal?].include?(method)

      @logger.send(method, *arguments, &block)
    end
  end  
end