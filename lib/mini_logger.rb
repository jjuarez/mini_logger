require 'rubygems'
require 'logger'
require 'config_context'


module MiniLogger
  class << self

    LOG_CHANNEL_KEY       = :log_channel
    LOG_LEVEL_KEY         = :log_level
    DEFAULT_CONFIGURATION = { LOG_CHANNEL_KEY=>STDERR, LOG_LEVEL_KEY=>::Logger::DEBUG }
    VALID_METHODS         = [:debug, :info, :warn, :error, :fatal]


    def method_missing( method, *arguments, &block )

      self.configure unless @logger
      @logger.send( method, arguments ) if VALID_METHODS.include?( method )
    end
    
    
    def configure( options=DEFAULT_CONFIGURATION )
      
      ConfigContext.configure do |config|
                    
        options.keys.each { |property| config[property] = options[property] }
      end
      
      @logger       ||= Logger.new( ConfigContext[LOG_CHANNEL_KEY] )
      @logger.level ||= ConfigContext[LOG_LEVEL_KEY]
      
      self
    end
  end
end