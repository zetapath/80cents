"use strict"

Hope        = require("zenserver").Hope
User        = require "../common/models/user"
C           = require "../common/constants"

module.exports = (id) -> "#{_randomString(8)}#{id}#{_randomString(8)}"

# -- Private Methods -----------------------------------------------------------
_randomString = (length) ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  for i in [0..length]
    text += possible.charAt Math.floor(Math.random() * possible.length)
  text
