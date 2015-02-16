"use strict"
Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/collection/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
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
        collections : values[1]
        collection  : values[2]?.parse()
        products    : (product.parse() for product in values[3])
      response.page "base", bindings, ["store.header", "store.collection", "store.footer"]


  zen.get "/product/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
    , ->
      filter = _id: request.parameters.id, visibility: true
      Product.search filter, limit = 1, null, populate = "collection_id"
    ]).then (errors, values) ->
      bindings =
        page        : "product"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collections : values[1]
        product     : values[2]?.parse()
      response.page "base", bindings, ["store.header", "store.product", "store.footer"]


  zen.get "/cart", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true
    , (error, @session) =>
      Collection.search visibility: true
    , (error, @collections) =>
      Order.search user: @session._id, state: C.ORDER.STATE.SHOPPING, limit = 1
    , (error, @order) =>
      OrderLine.search order: @order._id
    ]).then (error, @lines) =>
      return response.redirect "/" unless @session
      bindings =
        page        : "order"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session.parse()
        cart        : true
        collections : @collections
        order       : @order?.parse()
        lines       : (line.parse() for line in @lines or [])
      response.page "base", bindings, ["store.header", "store.order", "store.footer"]



  zen.get "/profile", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
    ]).then (errors, values) ->
      return response.redirect "/" unless values[1]
      bindings =
        page        : "profile"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0].parse()
        collections : values[1]
      response.page "base", bindings, ["store.header", "store.profile", "store.footer"]


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
        products    : (product.parse() for product in values[2])
      response.page "base", bindings, ["store.header", "store.home", "store.footer"]

