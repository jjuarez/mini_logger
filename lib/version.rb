module MiniLogger
  class Version
  
    INFO = {
      :major =>0,
      :minor =>5,
      :patch =>1
    }

    def self.number(version_info=INFO)

      if RUBY_VERSION =~ /1\.8\.\d/
        [version_info[:major], version_info[:minor],version_info[:patch]].join('.')
      else
        version_info.values.join('.')
      end
    end


    NAME    = 'mini_logger'
    NUMBER  = "#{number()}"  
    VERSION = [NAME, NUMBER].join('-')
  end
end