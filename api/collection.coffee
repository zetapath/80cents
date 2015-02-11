"use strict"
Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/collection", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      limit = 0
      filter = owner: session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Collection.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = collections: (c.parse() for c in value) or []
      response.json result


  server.post "/api/collection", (request, response) ->
    Session(request, response).then (error, session) ->
      if request.required ["title"]
        values = request.parameters
        values.owner = session._id
        Collection.create(values).then (error, collection) ->
          if error then response.unauthorized() else response.json collection.parse()


  server.put "/api/collection", (request, response) ->
    Session(request, response).then (error, session) ->
      if request.required ["id"]
        filter =
          _id   : request.parameters.id
          owner : session._id
        Collection.findAndUpdate(filter, request.parameters).then (error, collection) ->
          if error then response.unauthorized() else response.json collection.parse()


  server.delete "/api/collection", (request, response) ->
    Session(request, response).then (error, session) ->
      filter =
          _id   : request.parameters.id
          owner : session._id
      Collection.findAndUpdate(filter, visibility: false).then (error, collection) ->
        if error then response.unauthorized() else response.ok()
