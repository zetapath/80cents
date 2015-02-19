"use strict"
Hope        = require("zenserver").Hope
Session     = require "../common/session"
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
C           = require "../common/constants"
stripe      = require("stripe")(C.STRIPE.KEY)

module.exports = (server) ->

  # -- Only for Owner ----------------------------------------------------------
  server.put "/api/order/state", (request, response) ->
    available = (value for key, value of C.ORDER.STATE when C.MESSAGE[key])
    if request.required ["id", "state"] and request.parameters.state in available
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        if @session.role is C.USER.TYPE.OWNER
          filter = _id: request.parameters.id
        else
          filter = user: @session._id, _id: request.parameters.id
        Order.updateAttributes filter, state: request.parameters.state
      ]).then (error, order) =>
        if error
          response.json message: error.code, error.message
        else
          response.ok()
          mailer = new Mail
          mailer.send
            file    : C.ORDER.STATES[request.parameters.state].toLowerCase()
            to      : @session.appnima.mail
            subject : "Nomada.io order"
            user    : @session.parse()
            order   : order.parse()

  server.put "/api/order/purchase", (request, response) ->
    if request.required ["id", "token"]
      token = request.parameters.token
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        filter = _id: request.parameters.id, user: @session._id, state: C.ORDER.STATE.SHOPPING
        values = state: C.ORDER.STATE.PURCHASED, stripe_token: token
        Order.updateAttributes filter, values
      , (error, @order) =>
        promise = new Hope.Promise()
        values =
          amount      : @order.amount.toFixed(2).toString().replace(".", ""),
          currency    : "usd",
          card        : token,
          description : @session.appnima.mail
        stripe.charges.create values, (error, charge) => promise.done error, charge
        promise
      ]).then (error, charge) =>
        if error
          response.json message: error.code, error.message
        else
          response.ok()
          mailer = new Mail
          mailer.send
            file    : C.ORDER.STATES[C.ORDER.STATE.PURCHASED].toLowerCase()
            to      : @session.appnima.mail
            subject : "Nomada.io order"
            user    : @session.parse()
            order   : @order.parse()
