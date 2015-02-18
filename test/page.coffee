"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  session = ZENrequest.OWNERS[0]
  tasks.push _create(page, session) for page in ZENrequest.PAGES
  tasks.push _read session
  tasks.push _update ZENrequest.PAGES[0], session
  tasks.push _delete ZENrequest.PAGES[2], session
  tasks

# PROMISES ---------------------------------------------------------------------
_create = (page, user) -> ->
  Test "POST", "api/page", page, _session(user), "Owner create '#{page.title}' page.", 200, (response) ->
    page.id = response.id

_read = (user) -> ->
  Test "GET", "api/page", null, _session(user), "Owner can read him pages.", 200

_update = (page, user) -> ->
  page.title += "+"
  Test "PUT", "api/page", page, _session(user), "Owner updates '#{page.title}' page.", 200

_delete = (page, user) -> ->
  Test "DELETE", "api/page", page, _session(user), "Owner deletes '#{page.title}' page.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.token? then authorization: user.token else null
