"use strict"

Hope        = require("zenserver").Hope
Review      = require "../common/models/review"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (server) ->

  server.get "/api/review", (request, response) ->
    limit = 0
    filter = {}
    if request.parameters.id?
      filter._id = request.parameters.id
      limit = 1
    filter.product = request.parameters.product if request.parameters.product?

    Review.search(filter, limit).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = reviews: (review.parse() for review in value) or []
      response.json result


  server.post "/api/review", (request, response) ->
    if request.required ["product"]
      Session(request, response).then (error, session) ->
        values = request.parameters
        values.user = session._id
        Review.create(values).then (error, review) =>
          return response.unauthorized() if error
          review = review.parse()
          review.user = session
          response.json review


  server.put "/api/review", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          user  : session._id
        filter.user = session._id if session.type is C.USER.TYPE.OWNER
        Review.findAndUpdate filter, request.parameters
      ]).then (error, review) ->
        if error then response.unauthorized() else response.json review.parse()


  server.delete "/api/review", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, redirect = false, owner = true
      , (error, session) ->
        Review.search _id: request.parameters.id, limit = 1
      , (error, review) ->
        review.delete()
      ]).then (error, value) ->
        if error then response.unauthorized() else response.ok()
