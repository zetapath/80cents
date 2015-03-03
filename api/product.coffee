"use strict"

Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/product", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      limit = 0
      filter = owner: session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Product.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = []
        for product in (value or [])
          result.push
            id                : product._id.toString()
            title             : product.title
            type              : product.type
            price             : product.price
            # @TODO : Use default_image when is ready
            default_image     : product.images[0] or undefined
            collection_id     : product.collection_id
            visibility        : product.visibility
            highlight         : product.highlight
            created_at        : product.created_at
        result = products: result
      response.json result


  server.post "/api/product", (request, response) ->
    if request.required ["title", "description", "price"]
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
