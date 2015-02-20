"use strict"

Hope        = require("zenserver").Hope
Order       = require "../common/models/order"
User        = require "../common/models/user"
C           = require "../common/constants"

module.exports = (request, response, redirect = false, owner = false, shopping = false) ->
  promise = new Hope.Promise()
  token = request.session
  if token
    filter = "token": token
    filter.type = C.USER.TYPE.OWNER if owner
    User.search(filter, limit = 1).then (error, session) ->
      unless session?
        if redirect then promise.done true else do response.unauthorized
      else if shopping
        Order.shopping(session._id).then (error, shopping) ->
          session.shopping = shopping
          promise.done error, session
      else
        promise.done error, session
  else
    if redirect
      promise.done true
    else
      do response.logout
      do response.unauthorized
  promise
