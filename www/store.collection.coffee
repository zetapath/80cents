"use strict"

Hope        = require("zenserver").Hope
Mongoose    = require("zenserver").Mongoose
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"
helper      = require "../common/helper"

module.exports = (zen) ->

  zen.get "/collection/:id", (request, response) ->
    @session = @settings = @collection = @products = undefined
    Hope.shield([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      filter = visibility: true
      if Mongoose.Types.ObjectId.isValid(request.parameters.id)
        filter["_id"] = request.parameters.id
      else
        filter["search.url_handle"] = request.parameters.id
      Collection.search filter, limit = 1
    , (error, @collection) =>
      Product.search collection_id: @collection, visibility: true
    ]).then (error, @products) =>
      return response.redirect "/" unless @collection
      bindings =
        page        : "collection"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session
        settings    : @settings
        collection  : @collection.parse()
        products    : (product.parse() for product in @products)
        meta        : helper.customizeMeta @settings, @collection
        theme       : helper.getTheme()
      response.page "base", bindings, [
        "store.header"
        "store.collection"
        "partial.products"
        "store.footer"]
