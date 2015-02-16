"use strict"
Hope        = require("zenserver").Hope
Session     = require "../common/session"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
C           = require "../common/constants"
# stripe      = require("stripe")(C.STRIPE.KEY)
AVAILABLE   = ["comment", "shipping", "billing", "state", "tracking_number"]
module.exports = (server) ->

  # -- Order Lines -------------------------------------------------------------
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
          response.json @line.parse()

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

  # -- Order -------------------------------------------------------------------
  server.put "/api/order", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        parameters = {}
        for key, value of request.parameters when key in AVAILABLE
          parameters[key] = value
        Order.updateAttributes _id: request.parameters.id, parameters
      ]).then (error, value) ->
        if error
          response.json message: error.code, error.message
        else
          response.json order: value.parse()

  # -- Order Customer/Owner ----------------------------------------------------
  server.get "/api/order", (request, response) ->
    Hope.shield([ ->
      Session request, response, null, admin = true
    , (error, session) ->
      limit = 0
      filter = state: $gt: C.ORDER.STATE.SHOPPING
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Order.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = orders: (order.parse() for order in value)
      response.json result

  # -- Only for Owner ----------------------------------------------------------
  # server.put "/api/order/state", (request, response) ->
  #   available = (value for key, value of C.ORDER.STATE when C.MESSAGE[key])
  #   if request.required ["id", "state"] and request.parameters.state in available
  #     Hope.shield([ ->
  #       Session request, response
  #     , (error, @session) =>
  #       if @session.role is C.USER.TYPE.OWNER
  #         filter = _id: request.parameters.id
  #       else
  #         filter = user: @session._id, _id: request.parameters.id
  #       Order.updateAttributes filter, state: request.parameters.state
  #     ]).then (error, order) =>
  #       if error
  #         response.json message: error.code, error.message
  #       else
  #         response.ok()
  #         mailer = new Mail
  #         mailer.send
  #           file    : C.ORDER.STATES[request.parameters.state].toLowerCase()
  #           to      : @session.appnima.mail
  #           subject : "Nomada.io order"
  #           user    : @session.parse()
  #           order   : order.parse()

  # server.put "/api/order/purchase", (request, response) ->
  #   if request.required ["id", "token"]
  #     token = request.parameters.token
  #     Hope.shield([ ->
  #       Session request, response
  #     , (error, @session) =>
  #       filter = _id: request.parameters.id, user: @session._id, state: C.ORDER.STATE.SHOPPING
  #       values = state: C.ORDER.STATE.PURCHASED, stripe_token: token
  #       Order.updateAttributes filter, values
  #     , (error, @order) =>
  #       promise = new Hope.Promise()
  #       values =
  #         amount      : @order.amount.toFixed(2).toString().replace(".", ""),
  #         currency    : "usd",
  #         card        : token,
  #         description : @session.appnima.mail
  #       stripe.charges.create values, (error, charge) => promise.done error, charge
  #       promise
  #     ]).then (error, charge) =>
  #       if error
  #         response.json message: error.code, error.message
  #       else
  #         response.ok()
  #         mailer = new Mail
  #         mailer.send
  #           file    : C.ORDER.STATES[C.ORDER.STATE.PURCHASED].toLowerCase()
  #           to      : @session.appnima.mail
  #           subject : "Nomada.io order"
  #           user    : @session.parse()
  #           order   : @order.parse()
