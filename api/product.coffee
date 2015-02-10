"use strict"

Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/product", (request, response) ->
    Session(request, response).then (error, session) ->
      Product.search(owner: session._id).then (error, products) ->
        result = []
        for product in (products or [])
          result.push
            id                : product._id.toString()
            title             : product.title
            type              : product.type
            price             : product.price
            default_image     : product.default_image
            collection_id     : product.collection_id
            visibility        : product.visibility
            created_at        : product.created_at
        response.json products: result


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
