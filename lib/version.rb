module MiniLogger
  class Version
  
    INFO = {
      :major =>0,
      :minor =>5,
      :patch =>1
    }

    NAME    = 'mini_logger'
    NUMBER  = INFO.values.join('.')
    VERSION = [NAME, NUMBER].join('-')
  end
end
