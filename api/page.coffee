"use strict"
Hope        = require("zenserver").Hope
Page        = require "../common/models/page"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/page", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      limit = 0
      filter = owner: session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Page.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = pages: (c.parse() for c in value) or []
      response.json result


  server.post "/api/page", (request, response) ->
    Session(request, response).then (error, session) ->
      if request.required ["title"]
        values = request.parameters
        values.owner = session._id
        console.log values
        Page.create(values).then (error, page) ->
          if error then response.unauthorized() else response.json page.parse()


  server.put "/api/page", (request, response) ->
    Session(request, response).then (error, session) ->
      if request.required ["id"]
        filter =
          _id   : request.parameters.id
          owner : session._id
        Page.findAndUpdate(filter, request.parameters).then (error, page) ->
          if error then response.unauthorized() else response.json page.parse()


  server.delete "/api/page", (request, response) ->
    Session(request, response).then (error, session) ->
      filter =
          _id   : request.parameters.id
          owner : session._id
      Page.findAndUpdate(filter, visibility: false).then (error, page) ->
        if error then response.unauthorized() else response.ok()
