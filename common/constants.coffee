"use strict"

module.exports =

  USER:
    TYPE:
      CUSTOMER  : 0
      OWNER     : 1

  ORDER:
    STATE:
      SHOPPING  : 0
      PURCHASED : 1
      PROCESSED : 2
      SENT      : 3
      FINISHED  : 4

    LINE:
      STATE:
        PENDING   : 0

  STATES: ["Shopping", "Purchased", "Processed", "Sent", "Finished"]

  STRIPE:
    KEY: "sk_live_?"
    # KEY: "sk_test_?"

  # -- ENVIRONMENT URL ---------------------------------------------------------
  HOST:
    DEVELOPMENT   : "#{global.ZEN.protocol}://#{global.ZEN.host}:#{global.ZEN.port}/"
    PRODUCTION    : "https://"
