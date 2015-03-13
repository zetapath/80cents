"use strict"

Hope        = require("zenserver").Hope
Session     = require "../common/session"
Discount    = require "../common/models/discount"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Settings    = require "../common/models/settings"
User        = require "../common/models/user"
mailer      = require "../common/mailer"
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
      , (error, value) =>
        _amountDiscount @order
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
      , (error, value) =>
        _amountDiscount @order
      ]).then (error, value) ->
        if error
          response.json message: error.message, error.code
        else
          response.ok()

  server.put "/api/order/discount", (request, response) ->
    if request.required ["code", "order"]
      @discount = undefined
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter =
          code  : request.parameters.code
          active: true
        Discount.search filter, limit = 1
      , (error, @discount) =>
        Order.search _id: request.parameters.order, limit = 1
      , (error, @order) =>
        _amountDiscount @order, @discount
      ]).then (error, value) =>
        return response.unauthorized() if error
        response.json @discount.parse()

  server.put "/api/order", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        Settings.cache()
      , (error, @settings) =>
        parameters = {}
        for key, value of request.parameters when key in AVAILABLE
          parameters[key] = value
        filter = _id: request.parameters.id
        if @session.type is C.USER.TYPE.OWNER
          filter.user = request.parameters.user if request.parameters.user
        else
          filter = user: @session._id
        Order.updateAttributes filter, parameters
      , (error, @order) =>
        OrderLine.search order: @order._id
      , (error, @lines) =>
        User.search _id: @order.user, limit = 1
      ]).then (error, @user) =>
        if error
          response.json message: error.code, error.message
        else
          response.json order: @order.parse()
          if @session.type is C.USER.TYPE.OWNER
            order = @order.parse()
            mailer @user.mail, "#{@settings.name} - Order #{order.id} #{order.state_label}", "order",
              settings  : @settings
              user      : @user
              host      : C.HOST[global.ZEN.type.toUpperCase()]
              order     : order
              lines     : (line.parse() for line in @lines)

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

_amountDiscount = (order, discount) ->
  promise = new Hope.Promise()
  if order.discount or discount
    order.discount = discount._id if discount
    filter =
      _id   : order.discount
      active: true
    Discount.search(filter, limit = 1).then (error, discount) ->
      return promise.done error, null if error
      if discount.percent
        order.amount_discount = (order.amount * discount.percent) / 100
      else if discount.amount
        order.amount_discount = discount.amount
      order.saveInPromise().then (error, value) -> promise.done error, value
  else
    promise.done false, true
  promise
