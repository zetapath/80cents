"use strict"

Hope        = require("zenserver").Hope
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"
helper      = require "../common/helper"

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
      Session request, response, redirect = true, owner = false, shopping = true
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
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session
        settings    : @settings
        order       : @order.parse()
        theme       : helper.getTheme()
      response.page "base", bindings, ["store.header", "store.checkout", "store.footer"]

# -- Private Methods -----------------------------------------------------------
_showOrder = (request, response, id) =>
  Hope.shield([ =>
    Session request, response, redirect = true, owner = false, shopping = true
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
    return response.redirect "/" if not @session or not @order or @lines?.length is 0
    bindings =
      page        : "order"
      host        : C.HOST[global.ZEN.type.toUpperCase()]
      session     : @session
      settings    : @settings
      cart        : if id then false else true
      order       : @order?.parse()
      lines       : (line.parse() for line in @lines or [])
      theme       : helper.getTheme()
    response.page "base", bindings, ["store.header", "store.order", "store.footer"]
