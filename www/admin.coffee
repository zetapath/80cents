"use strict"

Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/admin/:context/:id", (request, response) ->
    Session(request, response, redirect = false).then (error, session) ->
      return response.redirect "/" if not session
      bindings =
        page    : "admin"
        session : session
        asset   : "admin"
        host    : C.HOST[global.ZEN.type.toUpperCase()]
      response.page "base", bindings, []


  zen.get "/admin/:context", (request, response) ->
    Session(request, response, redirect = false).then (error, session) ->
      return response.redirect "/" if not session
      bindings =
        page    : "admin"
        session : session
        asset   : "admin"
        host    : C.HOST[global.ZEN.type.toUpperCase()]
      response.page "base", bindings, []
