"use strict"

Hope        = require("zenserver").Hope
Mongoose    = require("zenserver").Mongoose
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"
helper      = require "../common/helper"

module.exports = (zen) ->

  zen.get "/login", (request, response) ->
    Settings.cache().then (error, settings) ->
      bindings =
        page        : "login"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        settings    : settings
        theme       : helper.getTheme()
        meta        : settings
      response.page "base", bindings, [
        "store.header"
        "store.login"
        "store.footer"]
