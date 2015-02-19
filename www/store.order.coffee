"use strict"

Hope        = require("zenserver").Hope
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Settings    = require "../common/models/settings"
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


  zen.get "/checkout", (request, response) ->
    Hope.shield([ =>
      Session request, response, redirect = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      filter =
        user : @session._id
        state: C.ORDER.STATE.SHOPPING
      Order.search filter, limit = 1
    ]).then (error, @order) =>
      return response.redirect "/" if not @session or not @order
      bindings =
        page        : "checkout"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session.parse()
        settings    : @settings
        order       : @order.parse()
      response.page "base", bindings, ["store.header", "store.checkout", "store.footer"]

# -- Private Methods -----------------------------------------------------------
_showOrder = (request, response, id) =>
  Hope.shield([ =>
    Session request, response, redirect = true
  , (error, @session) =>
    Settings.cache()
  , (error, @settings) =>
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
      settings    : @settings
      cart        : if id then false else true
      order       : @order?.parse()
      lines       : (line.parse() for line in @lines or [])
    response.page "base", bindings, ["store.header", "store.order", "store.footer"]
