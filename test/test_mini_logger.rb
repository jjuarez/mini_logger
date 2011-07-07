$:.unshift(File.join(File.dirname(__FILE__), '..'))
$:.unshift(File.join(File.dirname(__FILE__), %w[.. lib]))

require 'rubygems'
require 'tmpdir'
require 'delorean'
require 'file/tail'
require 'mini_logger'
require 'test/unit_extensions'
require 'test/helpers/tail_file_helper'


class TestMiniLogger < Test::Unit::TestCase
  
  TEST_DATE_TIME = "05/11/1970 00:00"
  TEST_MESSAGE   = "message"


  must "validate loglevel" do

    [:debug, 'info', :warn, 'error', :fatal].each do |l|
      assert(MiniLogger.validate_log_level?(l), "Log level:'#{l} not validated")
    end
    
    [:foo, 'bar', :bazz].each do |l|
      assert(!MiniLogger.validate_log_level?(l), "Log level:'#{l} validated")
    end
  end


  must "standarize log level" do

    ['debug', 'DEBUG', 'DeBuG'].all? { |l| l == MiniLogger::DEBUG }
    ['debug', 'DEBUG', 'DeBuG'].map  { |l| l.to_sym }.all? { |l| l == MiniLogger::DEBUG }

    ['info',  'INFO',  'iNfO' ].all? { |l| l == MiniLogger::INFO  }
    ['info',  'INFO',  'iNfO' ].map  { |l| l.to_sym }.all? { |l| l == MiniLogger::INFO  }

    ['warn',  'WARN',  'WaRn' ].all? { |l| l == MiniLogger::WARN  }
    ['warn',  'WARN',  'WaRn' ].map  { |l| l.to_sym }.all? { |l| l == MiniLogger::WARN  }

    ['error', 'ERROR', 'eRroR'].all? { |l| l == MiniLogger::ERROR }
    ['error', 'ERROR', 'eRroR'].map  { |l| l.to_sym }.all? { |l| l == MiniLogger::ERROR }

    ['fatal', 'DEBUG', 'FaTaL'].all? { |l| l == MiniLogger::FATAL }    
    ['fatal', 'DEBUG', 'FaTaL'].map  { |l| l.to_sym }.all? { |l| l == MiniLogger::FATAL }    
  end


  must "create a logger in debug level by default" do
  
    ##
    # New configuration interface
    test_logger = MiniLogger.configure
    assert(test_logger.debug?, "Log level:'#{test_logger.level}")
    
    ##
    # Old configuration interface
    test_logger = MiniLogger.configure(:log_channel=>STDERR, :log_level=>:info)
    assert(test_logger.info?, "Log level:'#{test_logger.level}'") 
    
    ##
    # New configuration interface
    test_logger = MiniLogger.configure(:dev=>STDERR, :level=>:error)
    assert(test_logger.error?, "Log level:'#{test_logger.level}")
  end
  
  
  must "raise and argument error" do

    [:this, 'set', :of, 'log', :levels, 'are', :evil].each do |l|
      assert_raise(ArgumentError) { MiniLogger.configure(:level=>l) }
    end
  end


  must "create a logger from a configuration file" do

    assert_equal(MiniLogger.configure(File.join(File.dirname(__FILE__), %w[fixtures test_config.yml])).level, MiniLogger::ERROR)
    assert_raise(Errno::ENOENT) { MiniLogger.configure("ThisFileDoNotExist.yml") }
  end
  
      
  must "confire various loggers" do
  
    test_logger = MiniLogger.configure    
    assert(test_logger.debug?)
    assert_equal(test_logger.level, MiniLogger::DEBUG)
  
    test_logger = MiniLogger.configure(:level=>:debug)
    assert(test_logger.debug?)
    assert_equal(test_logger.level, MiniLogger::DEBUG)
  
    test_logger = MiniLogger.configure(:level=>:info)
    assert(test_logger.info?)
    assert_equal(test_logger.level, MiniLogger::INFO)
  
    test_logger = MiniLogger.configure(:level=>:warn)
    assert(test_logger.warn?)
    assert_equal(test_logger.level, MiniLogger::WARN)
  
    test_logger = MiniLogger.configure(:level=>:error)
    assert(test_logger.error?)
    assert_equal(test_logger.level, MiniLogger::ERROR)
  
    test_logger = MiniLogger.configure(:level=>:fatal)
    assert(test_logger.fatal?)
    assert_equal(test_logger.level, MiniLogger::FATAL)
  end
  
  
  must "change log levels" do
    
    test_logger = MiniLogger.configure(:dev=>STDERR, :level=>:debug)
    assert(test_logger.debug?)
  
    test_logger.level = MiniLogger::ERROR
    assert test_logger.error?
    
    test_logger.level=MiniLogger::DEBUG 
    assert test_logger.debug? 

    test_logger.level=MiniLogger::INFO 
    assert test_logger.info? 

    test_logger.level=MiniLogger::WARN 
    assert test_logger.warn? 

    test_logger.level=MiniLogger::ERROR  
    assert test_logger.error?  

    test_logger.level=MiniLogger::FATAL
    assert test_logger.fatal?
  end
  
  
  must "not change to invalid log level" do
    
    test_logger = MiniLogger.configure
  
    assert(test_logger.debug?)
    assert_equal(test_logger.level, MiniLogger::DEBUG)
    
    [:this, :is, :not, :valid, :log, :levels, "and", "strings", "too" ].each do |ll|
      
      assert_raises(ArgumentError) { test_logger.level = ll }
      assert(test_logger.debug?)
      assert_equal(test_logger.level, MiniLogger::DEBUG)
    end
  end
  
  
  must "write messages in diferents log levels" do

    log_file_name = File.join(Dir.tmpdir, 'mini_logger_test.log')
    test_logger   = MiniLogger.configure(:dev=>log_file_name, :level=>:debug)
    log_file      = TailFileHelper.new(log_file_name)
  
    Delorean.time_travel_to(TEST_DATE_TIME)
    test_logger.debug(TEST_MESSAGE)    
    assert(log_file.get_log_line =~ /^D\, \[1970\-05\-11T00:00:\d{2}\.\d{6} #\d(.+){1} DEBUG \-\- : #{TEST_MESSAGE}/)
    
    Delorean.time_travel_to(TEST_DATE_TIME)
    test_logger.info(TEST_MESSAGE)
    assert(log_file.get_log_line =~ /^I\, \[1970\-05\-11T00:00:\d{2}\.\d{6} #\d(.+){1}  INFO \-\- : #{TEST_MESSAGE}/)

    Delorean.time_travel_to(TEST_DATE_TIME)
    test_logger.warn(TEST_MESSAGE)
    assert(log_file.get_log_line =~ /^W\, \[1970\-05\-11T00:00:\d{2}\.\d{6} #\d(.+){1}  WARN \-\- : #{TEST_MESSAGE}/)

    Delorean.time_travel_to(TEST_DATE_TIME)
    test_logger.error(TEST_MESSAGE)
    assert(log_file.get_log_line =~ /^E\, \[1970\-05\-11T00:00:\d{2}\.\d{6} #\d(.+){1} ERROR \-\- : #{TEST_MESSAGE}/)

    Delorean.time_travel_to(TEST_DATE_TIME)
    test_logger.fatal(TEST_MESSAGE)
    assert(log_file.get_log_line =~ /^F\, \[1970\-05\-11T00:00:\d{2}\.\d{6} #\d(.+){1} FATAL \-\- : #{TEST_MESSAGE}/)
  
    File.delete(log_file_name) if File.exist? log_file_name
  end
end