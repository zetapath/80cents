"use strict"

Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Page        = require "../common/models/page"
Product     = require "../common/models/product"
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/collection/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Settings.cache()
    , ->
      Collection.search _id: request.parameters.id, visibility: true, limit = 1
    , ->
      Product.search collection_id: request.parameters.id, visibility: true
    ]).then (errors, values) ->
      bindings =
        page        : "collection"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        collection  : values[2]?.parse()
        products    : (product.parse() for product in values[3])
      response.page "base", bindings, ["store.header", "store.collection", "store.footer"]


  zen.get "/product/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Settings.cache()
    , ->
      filter = _id: request.parameters.id, visibility: true
      Product.search filter, limit = 1, null, populate = "collection_id"
    ]).then (errors, values) ->
      bindings =
        page        : "product"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        product     : values[2]?.parse()
      response.page "base", bindings, ["store.header", "store.product", "store.footer"]


  zen.get "/:page", (request, response) ->
    home = request.parameters.page is ''
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Settings.cache()
    , ->
      if home
        Product.search visibility: true, highlight: true
      else
        Page.search "search.url_handle": request.parameters.page, limit = 1
    ]).then (errors, values) ->
      bindings =
        page        : if home then "home" else "page"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
      if home
        bindings.products = (product.parse() for product in values[2])
      else
        bindings.content = values[2]?.parse()
        bindings.meta =
          title       : bindings.content?.meta?.page_title or bindings.settings.title
          description : bindings.content?.meta?.meta_description or bindings.settings.description
      response.page "base", bindings, ["store.header", "store.home", "store.footer"]
