"use strict"

fs          = require "fs"
path        = require "path"
Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Collection  = require "../common/models/collection"
Session     = require "../common/session"

IMAGES_PATH = fs.realpathSync "#{__dirname}/../www/assets/uploads/"

module.exports = (server) ->

  server.post "/api/image", (request, response) ->
    if request.required ["id", "file", "entity"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter = _id: request.parameters.id, owner: session._id
        if request.parameters.entity is "Product"
          Product.search filter, limit = 1
        else if request.parameters.entity is "Collection"
          Collection.search filter, limit = 1
      , (error, entity) ->
        _upload request.parameters.file, entity
      ]).then (error, file) ->
        if error then response.unauthorized() else response.json file

  server.delete "/api/image", (request, response) ->
    if request.required ["id", "file", "entity"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter = _id: request.parameters.id, owner: session._id
        if request.parameters.entity is "Product"
          Product.search filter, limit = 1
        else if request.parameters.entity is "Collection"
          Collection.search filter, limit = 1
      ]).then (error, entity) ->
        return response.unauthorized() if error
        index = entity.images.indexOf request.parameters.file
        if index > -1
          entity.images.splice index, 1
          entity.save()
          response.ok()
        else
          response.badRequest()

# -- Private Methods -----------------------------------------------------------
_upload = (file, entity) ->
  promise = new Hope.Promise()
  file_name = "#{entity._id}_#{file.name}".replace(/ /g,"_").toLowerCase()
  destiny = path.join IMAGES_PATH, file_name
  fs.rename file.path, destiny, (error, result)->
    return promise.done true if error?
    entity.images.addToSet file_name
    entity.save()
    promise.done null, name: file_name
  promise
