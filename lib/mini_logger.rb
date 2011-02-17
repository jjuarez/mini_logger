require 'rubygems'
require 'logger'


module MiniLogger
  class << self

    DEFAULT_CONFIGURATION = { :log_channel=>STDERR, :log_level=>::Logger::INFO }
    VALID_METHODS         = [ :debug, :info, :warn, :error, :fatal ]

    def method_missing( method, *arguments, &block )

      self.configure unless @logger
      @logger.send( method, arguments.length == 1 ? arguments[0] : arguments ) if VALID_METHODS.include?( method )
    end
    
    def configure( atts = DEFAULT_CONFIGURATION )
      
      @logger       ||= Logger.new( atts[:log_channel] )
      @logger.level ||= atts[:log_level]
      
      self
    end
  end
end