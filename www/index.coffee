"use strict"

# Session   = require "../common/session"
# C         = require "../common/constants"
# mailer    = require "../common/mailer"

module.exports = (zen) ->

  zen.get "/", (request, response) ->
    response.page "base"#, {}, ["partial.landing"]
