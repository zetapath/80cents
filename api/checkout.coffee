"use strict"
stripe      = require("stripe")
Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Order       = require "../common/models/order"
OrderLine   = require "../common/models/order_line"
Settings    = require "../common/models/settings"
mailer      = require "../common/mailer"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (server) ->

  server.put "/api/order/checkout", (request, response) ->
    if request.required ["id", "token"]
      token = request.parameters.token
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        Settings.cache()
      , (error, @settings) =>
        filter =
          _id           : request.parameters.id
          user          : @session._id
          state         : C.ORDER.STATE.SHOPPING
        values =
          state         : C.ORDER.STATE.PURCHASED
          payment_type  : request.parameters.type
          payment_token : token
        Order.updateAttributes filter, values
      , (error, @order) =>
        OrderLine.search order: @order._id
      , (error, @lines) =>
        promise = new Hope.Promise()
        values =
          amount      : @order.amount.toFixed(2).toString().replace(".", ""),
          currency    : "usd",
          card        : token,
          description : @session.mail
        key = @settings.payments.stripe.secret_key
        stripe(key).charges.create values, (error, charge) =>
          promise.done error, charge
        promise
      ]).then (error, charge) =>
        if error
          response.json message: error.code, error.message
        else
          response.ok()
          mailer @session.mail, "Your order from #{@settings.name}", "order",
            settings  : @settings
            user      : @session
            order     : @order

