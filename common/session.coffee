"use strict"
Hope  = require("zenserver").Hope
User  = require "../common/models/user"

module.exports = (request, response, redirect = false) ->
  promise = new Hope.Promise()
  token = request.session
  if token
    User.search("_id": token, limit = 1).then (error, user) ->
      unless user?
        if redirect then promise.done true else do response.unauthorized
      else
        promise.done error, user
  else
    if redirect then promise.done true else do response.unauthorized
  promise
