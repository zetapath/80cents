"use strict"

Hope        = require("zenserver").Hope
User        = require "../common/models/user"
Settings    = require "../common/models/settings"
mailer      = require "../common/mailer"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (server) ->

  server.post "/api/signup", (request, response) ->
    if request.required ["mail", "password"]
      Hope.chain([ ->
        Settings.cache()
      , (error, @settings) =>
        User.search type: C.USER.TYPE.OWNER
      , (error, users) ->
        if users.length > 0
          request.parameters.type = C.USER.TYPE.CUSTOMER
        else
          request.parameters.type = C.USER.TYPE.OWNER
        User.signup request.parameters
      ]).then (error, @user) =>
        return response.conflict() if error?
        response.session @user.token
        user = @user.parse()
        user.token = @user.token
        response.json user
        if @user.type isnt C.USER.TYPE.OWNER
          mailer @user.mail, "Welcome to #{@settings.name}", "welcome",
            settings  : @settings
            host      : C.HOST[global.ZEN.type.toUpperCase()]
            user      : @user


  server.post "/api/login", (request, response) ->
    if request.required ["mail", "password"]
      User.login(request.parameters).then (error, user) ->
        return response.unauthorized() if error
        response.session user.token
        result = user.parse()
        result.token = user.token
        response.json result


  server.post "/api/logout", (request, response) ->
    response.logout()
    response.ok()


  server.get "/api/profile", (request, response) ->
    Session(request, response).then (error, session) ->
      response.json session.parse()


  server.put "/api/profile", (request, response) ->
    Session(request, response).then (error, session) ->
      parameters = {}
      keys = ["first_name", "last_name", "avatar"]
      for key in keys when request.parameters[key]?
        parameters[key] = request.parameters[key]
      User.findAndUpdate(_id: session._id, parameters).then (error, user) ->
        if error?
          response.json message: error.message, error.code
        else
          response.json user.parse()
