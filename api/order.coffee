"use strict"

Hope        = require("zenserver").Hope
Session     = require "../common/session"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Settings    = require "../common/models/settings"
C           = require "../common/constants"
AVAILABLE   = ["comment", "shipping", "billing", "state", "payment_type", "tracking_number"]

module.exports = (server) ->

  # -- Custoner ----------------------------------------------------------------
  server.post "/api/order/line", (request, response) ->
    if request.required ["product", "quantity"]
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        filter = _id: request.parameters.product, visibility: true
        Product.search filter, limit = 1
      , (error, @product) =>
        values =
          user  : @session._id
          state : C.ORDER.STATE.SHOPPING
        Order.findOrRegister values, values
      , (error, @order) =>
        values =
          order   : @order._id
          product : @product._id
          quantity: request.parameters.quantity
          color   : request.parameters.color
          size    : request.parameters.size
          amount  : (@product.price * request.parameters.quantity)
        OrderLine.register values
      , (error, @line) =>
        OrderLine.search order: @order._id
      , (error, @lines) =>
        amount = 0
        amount += line.amount for line in @lines
        @order.amount = amount
        @order.lines.addToSet @line._id
        @order.saveInPromise()
      ]).then (error, value) =>
        if error
          response.json message: error.message, error.code
        else
          response.json @order.parse()

  server.delete "/api/order/line", (request, response) ->
    if request.required ["id", "order"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        OrderLine.delete
          _id   : request.parameters.id
          order : request.parameters.order
      , (error, @line) =>
        Order.search _id: @line.order, limit = 1
      , (error, @order) =>
        @order.amount = @order.amount - @line.amount
        index = @order.lines.indexOf @line._id
        @order.lines.splice index, 1 if index > -1
        @order.saveInPromise()
      ]).then (error, value) ->
        if error
          response.json message: error.message, error.code
        else
          response.ok()

  server.put "/api/order", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        parameters = {}
        for key, value of request.parameters when key in AVAILABLE
          parameters[key] = value
        filter = _id: request.parameters.id
        if session.type is C.USER.TYPE.OWNER
          filter.user = request.parameters.user if request.parameters.user
        else
          filter = user: session._id
        Order.updateAttributes filter, parameters
      ]).then (error, value) ->
        if error
          response.json message: error.code, error.message
        else
          response.json order: value?.parse()

  # -- Owner/Customer ----------------------------------------------------------
  server.get "/api/order", (request, response) ->
    Hope.shield([ ->
      Session request, response, null
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      if @session.type is C.USER.TYPE.OWNER
        filter = state: $gt: C.ORDER.STATE.SHOPPING
        filter.user = request.parameters.user if request.parameters.user
      else
        filter = user: @session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Order.search filter, limit
    , (error, @order) =>
      OrderLine.search order: @order._id
    ]).then (error, @lines) =>
      return response.unauthorized() if error
      if request.parameters.id
        result = @order.parse()
        result.settings = @settings
        result.lines = (line.parse() for line in @lines)
      else
        result = orders: (order.parse() for order in @order)
      response.json result
