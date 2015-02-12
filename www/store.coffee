"use strict"
Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
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
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search()
    , ->
      Product.search()
    ]).then (errors, values) ->
      bindings =
        page        : "landing"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collections : values[1]
        products    : values[2]
      response.page "base", bindings, ["store.header", "store.landing", "store.footer"]

