"use strict"

Hope        = require("zenserver").Hope
User        = require "../common/models/user"
C           = require "../common/constants"

module.exports = (request, response, redirect = false, owner = false) ->
  promise = new Hope.Promise()
  token = request.session
  if token
    filter = "token": token
    filter.type = C.USER.TYPE.OWNER if owner
    User.search(filter, limit = 1).then (error, user) ->
      unless user?
        if redirect then promise.done true else do response.unauthorized
      else
        promise.done error, user
  else
    if redirect
      promise.done true
    else
      do response.logout
      do response.unauthorized
  promise
