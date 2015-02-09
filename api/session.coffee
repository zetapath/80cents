"use strict"
Hope        = require("zenserver").Hope
User        = require "../common/models/user"
Session     = require "../common/session"

module.exports = (server) ->

  server.post "/api/signup", (request, response) ->
    if request.required ["mail", "password"]
      User.signup(request.parameters).then (error, user) ->
        return response.conflict() if error?
        user = user.parse()
        response.json user
        # mailer user.mail, "Welcome to shopio", "welcome", user


  server.post "/api/login", (request, response) ->
    if request.required ["mail", "password"]
      User.login(request.parameters).then (error, user) ->
        if error then response.unauthorized() else response.json user.parse()


  server.post "/api/logout", (request, response) ->
    response.logout()
    response.ok()


  server.put "/api/profile", (request, response) ->
    Session(request, response).then (error, session) ->
      parameters = {}
      for key in [ "name", "avatar"] when request.parameters[key]?
        parameters[key] = request.parameters[key]
      User.findAndUpdate(_id: session._id, parameters).then (error, user) ->
        if error?
          response.json message: error.message, error.code
        else
          response.json user.parse()
