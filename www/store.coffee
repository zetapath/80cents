"use strict"
Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/collection/:id", (request, response) ->
    response.json collection: request.parameters.id


  zen.get "/product/:id", (request, response) ->
    response.json product: request.parameters.id


  zen.get "/profile", (request, response) ->
    response.json page: "profile"


  zen.get "/about", (request, response) ->
    response.json page: "about"


  zen.get "/", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
    , ->
      Product.search visibility: true, highlight: true
    ]).then (errors, values) ->
      bindings =
        page        : "home"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collections : values[1]
        products    : values[2]
      response.page "base", bindings, ["store.header", "store.landing", "store.footer"]

