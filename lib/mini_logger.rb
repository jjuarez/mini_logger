require 'rubygems'
require 'logger'


module MiniLogger
  class << self

    LOG_CHANNEL_KEY       = :log_channel
    LOG_LEVEL_KEY         = :log_level
    DEFAULT_CONFIGURATION = { LOG_CHANNEL_KEY=>STDERR, LOG_LEVEL_KEY=>::Logger::INFO }
    VALID_METHODS         = [:debug, :info, :warn, :error, :fatal]


    def method_missing( method, *arguments, &block )

      self.configure unless @logger
      @logger.send( method, arguments ) if VALID_METHODS.include?( method )
    end
    
    
    def configure( options=DEFAULT_CONFIGURATION )
      
      @logger       ||= Logger.new( options[LOG_CHANNEL_KEY] )
      @logger.level ||= options[LOG_LEVEL_KEY]
      
      self
    end
  end
end