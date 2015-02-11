"use strict"

fs          = require "fs"
path        = require "path"
Hope        = require("zenserver").Hope
Product     = require "../common/models/product"
Session     = require "../common/session"
IMAGES_PATH = fs.realpathSync "#{__dirname}/../www/assets/img/product/"

module.exports = (server) ->

  server.post "/api/product/image", (request, response) ->
    if request.required ["id", "file"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        Product.search _id: request.parameters.id, owner: session._id, limit = 1
      , (error, product) ->
        _upload request.parameters.file, product
      ]).then (error, file) ->
        if error then response.unauthorized() else response.json file

  # server.delete "/api/product/image", (request, response) ->
  #   if request.required ["id", "url"]
  #     Hope.shield([ ->
  #       Session request, response
  #     , (error, session) ->
  #       Product.search _id: request.parameters.id, owner: session._id, limit = 1
  #     ]).then (error, product) ->
  #       index = product.images.indexOf request.parameters.url
  #       if index > -1
  #         product.images.splice index, 1
  #         product.save()
  #       if error then response.unauthorized() else response.ok()

# -- Private Methods -----------------------------------------------------------
_upload = (file, product) ->
  promise = new Hope.Promise()
  file_name = "#{product._id}_#{file.name}".replace(/ /g,"_").toLowerCase()
  destiny = path.join IMAGES_PATH, file_name
  fs.rename file.path, destiny, (error, result)->
    return promise.done true if error?
    product.images.addToSet file_name
    product.save()
    promise.done null, name: file_name
  promise
