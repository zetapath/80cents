"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  # -- Owners
  tasks.push _signup(user) for user in ZENrequest.OWNERS
  tasks.push _signupAlready(user) for user in ZENrequest.OWNERS
  tasks.push _login(user) for user in ZENrequest.OWNERS
  # -- Customers (normal users)
  tasks.push _signup(user) for user in ZENrequest.USERS
  tasks.push _login(user) for user in ZENrequest.USERS
  tasks.push _update ZENrequest.USERS[0]
  tasks.push _logout ZENrequest.USERS[1]
  tasks

# PROMISES ---------------------------------------------------------------------
_signup = (user) -> ->
  Test "POST", "api/signup", user, null, "User #{user.mail} registered.", 200

_signupAlready = (user) -> ->
  Test "POST", "api/signup", user, null, "User #{user.mail} already registered.", 409

_login = (user) -> ->
  Test "POST", "api/login", user, null, "User #{user.mail} logged.", 200, (response) ->
    user.token = response.token

_update = (user) -> ->
  Test "PUT", "api/profile", user, _session(user), "User #{user.mail} change profile.", 200

_logout = (user) -> ->
  Test "POST", "api/logout", user, _session(user), "User #{user.mail} logged out.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.token? then authorization: user.token else null
