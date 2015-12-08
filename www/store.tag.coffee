"use strict"

Hope        = require("zenserver").Hope
Mongoose    = require("zenserver").Mongoose
Product     = require "../common/models/product"
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"
helper      = require "../common/helper"

module.exports = (zen) ->

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
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        settings    : values[1]
        products    : (product.parse() for product in values[2])
        collection  : title: request.parameters.id
        theme       : helper.getTheme()
      response.page "base", bindings, [
        "store.header"
        "store.collection"
        "partial.products"
        "store.footer"]
