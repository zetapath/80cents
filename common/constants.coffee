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
    STATES: ["Shopping", "Purchased", "Processed", "Sent", "Finished"]
    LINE:
      STATE:
        PENDING   : 0

    PAYMENT:
      UNDEFINED     : 0
      CREDIT_CARD   : 1
      PAYPAL        : 2
      BANK_TRANSFER : 3

  STRIPE:
    KEY: "sk_live_?"
    # KEY: "sk_test_?"

  # -- ENVIRONMENT URL ---------------------------------------------------------
  HOST:
    DEVELOPMENT   : "#{global.ZEN.protocol}://#{global.ZEN.host}:#{global.ZEN.port}/"
    PRODUCTION    : "https://"
