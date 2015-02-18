"use strict"

Hope        = require("zenserver").Hope
User        = require "../common/models/user"
Settings    = require "../common/models/settings"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (server) ->

  server.get "/api/settings", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = false, owner = true
    , (error, @session) =>
      Settings.search()
    ]).then (error, settings) =>
      if error
        Settings.create(account_mail: @session.mail).then (error, settings) ->
          response.json settings.parse()
      response.json settings.parse()


  server.put "/api/settings", (request, response) ->
    Hope.shield([ ->
      Session request, response, redirect = false, owner = true
    , (error, @session) =>
      filter = account_mail: @session.mail
      Settings.findAndUpdate filter, request.parameters
    ]).then (error, settings) ->
      response.ok()
