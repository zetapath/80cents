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
        meta        : _customizeMeta values[1], values[2]
      response.page "base", bindings, [
        "store.header"
        "store.collection"
        "partial.products"
        "store.footer"]


  zen.get "/product/:id", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      filter =
        $or: [
          _id                 : request.parameters.id
        ,
          "search.url_handle" : request.parameters.id]
        visibility: true
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
        products    : (product.parse() for product in products)
        meta        : _customizeMeta @settings, @product
      response.page "base", bindings, [
        "store.header"
        "store.product"
        "partial.products"
        "store.footer"]


  zen.get "/tag/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , ->
      Settings.cache()
    , ->
      Product.search
        tags      : $in: [request.parameters.id]
        visibility: true
    ]).then (errors, values) ->
      return response.redirect "/" if values[2].length is 0
      bindings =
        page        : "collection"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        products    : (product.parse() for product in values[2])
        collection  : title: request.parameters.id
      response.page "base", bindings, [
        "store.header"
        "store.collection"
        "partial.products"
        "store.footer"]


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
        bindings.meta = _customizeMeta bindings.settings, bindings.content
      partial = if home then "home" else "page"
      response.page "base", bindings, [
        "store.header"
        "store.#{partial}"
        # "partial.products"
        "store.footer"]


_customizeMeta = (settings, values) ->
  meta =
    title       : values?.search?.page_title or settings.title
    description : values?.search?.meta_description or settings.description
