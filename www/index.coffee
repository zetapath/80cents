"use strict"

Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      return response.redirect "/admin/dashboard" if session
      response.page "base",
        page    : "landing"
        asset   : "admin"
        host    : C.HOST[global.ZEN.type.toUpperCase()]
