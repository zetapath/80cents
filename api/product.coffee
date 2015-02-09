"use strict"

Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/product", (request, response) ->
    Session(request, response).then (error, session) ->
      Product.search(owner: session._id).then (error, products) ->
        response.json products: (c.parse() for c in products) or []


  server.post "/api/product", (request, response) ->
    if request.required ["title", "description", "type", "price"]
      Session(request, response).then (error, session) ->
        values = request.parameters
        values.owner = session._id
        Product.create(values).then (error, product) ->
          if error then response.unauthorized() else response.json product.parse()


  server.put "/api/product", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          owner : session._id
        Product.findAndUpdate filter, request.parameters
      ]).then (error, product) ->
        if error then response.unauthorized() else response.json product.parse()


  server.delete "/api/product", (request, response) ->
    if request.required ["id"]
      Session(request, response).then (error, session) ->
        filter =
            _id   : request.parameters.id
            owner : session._id
        Product.findAndUpdate(filter, visibility: false).then (error, product) ->
          if error then response.unauthorized() else response.ok()
