"use strict"
Hope        = require("zenserver").Hope
Session     = require "../common/session"
User        = require "../common/models/user"
C           = require "../common/constants"

module.exports = (server) ->

  server.get "/api/customer", (request, response) ->
    Hope.shield([ ->
      Session request, response, null, owner = true
    , (error, session) ->
      filter = type: C.USER.TYPE.CUSTOMER
      if request.parameters.id
        filter._id = request.parameters.id
        limit = 1
      User.search filter, limit
    ]).then (error, value) ->
      if request.parameters.id
        result = value.parse()
      else
        result = customers: (user.parse() for user in value)
        console.log result
      response.json result

  server.put "/api/customer", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        filter = _id: request.parameters.id, type: C.USER.TYPE.CUSTOMER
        User.findAndUpdate filter, request.parameters
      ]).then (error, user) ->
        if error then response.unauthorized() else response.json user.parse()
