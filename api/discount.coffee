"use strict"

Hope        = require("zenserver").Hope
Discount    = require "../common/models/discount"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/discount", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      limit = 0
      filter = owner: session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Discount.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = discounts: (d.parse() for d in value) or []
      response.json result


  server.post "/api/discount", (request, response) ->
    Hope.shield([ ->
      Session request, response, null, owner = true
    , (error, session) ->
      values = request.parameters
      values.owner = session._id
      values.collection_id = undefined if values.collection_id is ""
      Discount.create values
    ]).then (error, discount) ->
      if error then response.unauthorized() else response.json discount.parse()


  server.put "/api/discount", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          owner : session._id
        request.parameters.collection_id = undefined if request.parameters.collection_id is ""
        Discount.findAndUpdate filter, request.parameters
      ]).then (error, discount) ->
        if error then response.unauthorized() else response.json discount.parse()


  server.delete "/api/discount", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          owner : session
        Discount.findAndUpdate filter, active: false
      ]).then (error, value)->
        if error then response.unauthorized() else response.ok()
