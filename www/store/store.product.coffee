"use strict"

Hope        = require("zenserver").Hope
Mongoose    = require("zenserver").Mongoose
Page        = require "../../common/models/page"
Product     = require "../../common/models/product"
Settings    = require "../../common/models/settings"
Session     = require "../../common/session"
C           = require "../../common/constants"
helper      = require "../../common/helper"

module.exports = (zen) ->

  zen.get "/product/:id", (request, response) ->
    @session = @settings = @product = undefined
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
      price = @product.price * 0.05
      filter =
        _id           : $nin: [@product._id]
        collection_id : @product.collection_id
        visibility    : true
        $and          : [
          price:  $gte : (@product.price - price)
        ,
          price:  $lte : (@product.price + price)
        ]
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
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session
        settings    : @settings
        product     : product
        products    : (product.parse() for product in products)
        meta        : helper.customizeMeta @settings, @product
        theme       : helper.getTheme()
      response.page "base", bindings, [
        "store.header"
        "store.product"
        "partial.products"
        "store.footer"]
