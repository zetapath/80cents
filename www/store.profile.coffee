"use strict"

Hope        = require("zenserver").Hope
Order       = require "../common/models/order"
Settings    = require "../common/models/settings"
User        = require "../common/models/user"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/profile/logout", (request, response) ->
    response.session null
    response.redirect "/"


  zen.get "/profile", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true
    , (error, @session) =>
      Settings.cache()
    , (error, @settings) =>
      Order.search user: @session._id, state: $gt: C.ORDER.STATE.SHOPPING
    ]).then (error, orders) =>
      return response.redirect "/" if error
      bindings =
        page        : "profile"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : @session.parse()
        settings    : @settings
        orders      : (order.parse() for order in orders)
      response.page "base", bindings, ["store.header", "store.profile", "store.footer"]


  zen.post "/profile", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = true
    , (error, session) ->
      User.findAndUpdate _id: session._id, request.parameters
    ]).then (error, user) ->
      response.redirect "/profile"
