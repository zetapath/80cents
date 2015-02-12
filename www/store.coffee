"use strict"

Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/store/collection/:id", (request, response) ->
    response.ok()


  zen.get "/store/product/:id", (request, response) ->
    response.ok()


  zen.get "/store/profile", (request, response) ->
    response.ok()


  zen.get "/store", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      bindings =
        page    : "landing"
        asset   : "store"
        host    : C.HOST[global.ZEN.type.toUpperCase()]
      response.page "base", bindings, ["partial.store"]

