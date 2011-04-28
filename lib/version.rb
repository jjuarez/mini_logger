module Version
  INFO = {
    :major =>0,
    :minor =>4,
    :patch =>3
  }

  NAME   = 'mini_logger'
  NUMBER = [INFO[:major], INFO[:minor], INFO[:patch]].join( '.' )
end