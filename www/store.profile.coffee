"use strict"

Hope        = require("zenserver").Hope
Order       = require "../common/models/order"
Settings    = require "../common/models/settings"
User        = require "../common/models/user"
Session     = require "../common/session"
C           = require "../common/constants"
helper      = require "../common/helper"

module.exports = (zen) ->

  zen.get "/login", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      return response.redirect "/profile" if session
      response.page "base",
        page        : "login"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        theme       : helper.getTheme()


  zen.get "/logout", (request, response) ->
    response.session null
    response.redirect "/"


  zen.get "/profile", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      Order.search user: @session._id, state: $gt: C.ORDER.STATE.SHOPPING
    ]).then (error, @orders) =>
      return response.redirect "/" if error
      bindings =
        page        : "profile"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session
        settings    : @settings
        orders      : (order.parse() for order in @orders)
        has_orders  : (@orders.length > 0)
        theme       : helper.getTheme()
      response.page "base", bindings, ["store.header", "store.profile", "store.footer"]


  zen.post "/profile", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true
    , (error, session) ->
      User.findAndUpdate _id: session._id, request.parameters
    ]).then (error, user) ->
      response.redirect "/profile"
