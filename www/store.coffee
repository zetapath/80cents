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
      Session request, response, redirect = true, owner = false, shopping = true
    , ->
      Settings.cache()
    , ->
      Collection.search _id: request.parameters.id, visibility: true, limit = 1
    , ->
      Product.search collection_id: request.parameters.id, visibility: true
    ]).then (errors, values) ->
      return response.redirect "/" unless values[2]
      bindings =
        page        : "collection"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        collection  : values[2].parse()
        products    : (product.parse() for product in values[3])
      response.page "base", bindings, ["store.header", "store.collection", "store.footer"]


  zen.get "/product/:id", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      filter = _id: request.parameters.id, visibility: true
      Product.search filter, limit = 1, null, populate = "collection_id"
    , (error, @product) =>
      filter =
        _id           : $nin: [@product._id]
        collection_id : @product.collection_id
        visibility    : true
      Product.search filter, limit = 4
    ]).then (error, products) =>
      return response.redirect "/" if error
      product = @product.parse()
      product.images.shift()
      product.if = {}
      for condition in ["colors", "sizes", "materials", "tags"]
        product.if[condition] = product[condition].length > 0
      bindings =
        page        : "product"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session
        settings    : @settings
        product     : product
        related     : (product.parse() for product in products)
      response.page "base", bindings, ["store.header", "store.product", "store.footer"]


  zen.get "/:page", (request, response) ->
    home = request.parameters.page is ''
    Hope.join([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , ->
      Settings.cache()
    , ->
      Collection.search visibility: true
    , ->
      if home
        Product.search visibility: true, highlight: true
      else
        Page.search "search.url_handle": request.parameters.page, limit = 1
    ]).then (errors, values) ->
      return response.page "base", page: "error", ["404"] if not home and errors[2] isnt null
      bindings =
        page        : if home then "home" else "page"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        collections : (collection.parse() for collection in values[2])
      if home
        bindings.products = (product.parse() for product in values[3])
      else
        bindings.content = values[3]?.parse()
        bindings.meta =
          title       : bindings.content?.meta?.page_title or bindings.settings.title
          description : bindings.content?.meta?.meta_description or bindings.settings.description
      partial = if home then "home" else "page"
      response.page "base", bindings, ["store.header", "store.#{partial}", "store.footer"]
