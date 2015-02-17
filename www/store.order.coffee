"use strict"

Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/cart", (request, response) ->
    _showOrder request, response


  zen.get "/order/:id", (request, response) ->
    if request.parameters.id
      _showOrder request, response, request.parameters.id
    else
      response.redirect "/"


# -- Private Methods -----------------------------------------------------------
_showOrder = (request, response, id) =>
  Hope.shield([ =>
    Session request, response, redirect = true
  , (error, @session) =>
    Collection.available()
  , (error, @collections) =>
    filter = user: @session._id
    if id
      filter._id = id
      filter.state = $gt: C.ORDER.STATE.SHOPPING
    else
      filter = state: C.ORDER.STATE.SHOPPING
    Order.search filter, limit = 1
  , (error, @order) =>
    OrderLine.search order: @order._id
  ]).then (error, @lines) =>
    return response.redirect "/" if not @session or not @order
    bindings =
      page        : "order"
      asset       : "store"
      host        : C.HOST[global.ZEN.type.toUpperCase()]
      session     : @session.parse()
      cart        : if id then false else true
      collections : @collections
      order       : @order?.parse()
      lines       : (line.parse() for line in @lines or [])
    response.page "base", bindings, ["store.header", "store.order", "store.footer"]
