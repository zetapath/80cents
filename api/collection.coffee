"use strict"

Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Settings    = require "../common/models/settings"
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
    if request.required ["title"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        values = request.parameters
        values.owner = session._id
        Collection.create values
      , (error, @collection) =>
        Collection.search visibility: true
      , (error, collections) ->
        collections = (id: c._id, title: c.title for c in collections)
        Settings.findAndUpdate {}, collections: collections
      ]).then (error, value) =>
        if error then response.unauthorized() else response.json @collection.parse()


  server.put "/api/collection", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          owner : session._id
        Collection.findAndUpdate filter, request.parameters
      , (error, @collection) =>
        Collection.search visibility: true
      , (error, collections) ->
        collections = (id: c._id, title: c.title for c in collections)
        Settings.findAndUpdate {}, collections: collections
      ]).then (error, value) =>
        if error then response.unauthorized() else response.json @collection.parse()


  server.delete "/api/collection", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        Collection.search _id: request.parameters.id, owner: session, limit = 1
      , (error, collection) ->
        collection.delete()
      ]).then (error, value)->
        if error then response.unauthorized() else response.ok()
