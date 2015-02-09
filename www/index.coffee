"use strict"

Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/app/:context", (request, response) ->
    Session(request, response, redirect = false).then (error, session) ->
      return response.redirect "/" if not session
      bindings =
        page    : "app"
        session : session
        host    : C.HOST[global.ZEN.type.toUpperCase()]
      response.page "base", bindings, []

  zen.get "/", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      return response.redirect "/app/dashboard" if session
      response.page "base",
        page    : "landing"
        host    : C.HOST[global.ZEN.type.toUpperCase()]
