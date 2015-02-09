"use strict"

module.exports =

  USER:
    TYPE:
      CUSTOMER  : 0
      OWNER     : 1

  # -- ENVIRONMENT URL ---------------------------------------------------------
  HOST:
    DEVELOPMENT   : "#{global.ZEN.protocol}://#{global.ZEN.host}:#{global.ZEN.port}/"
    PRODUCTION    : "https://"
