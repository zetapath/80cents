"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  session = ZENrequest.OWNERS[0]
  tasks.push _create(collection, session) for collection in ZENrequest.COLLECTIONS
  tasks.push _read session
  tasks.push _update ZENrequest.COLLECTIONS[0], session
  tasks.push _delete ZENrequest.COLLECTIONS[2], session
  tasks

# PROMISES ---------------------------------------------------------------------
_create = (collection, user) -> ->
  Test "POST", "api/collection", collection, _session(user), "Owner create '#{collection.title}' collection.", 200, (response) ->
    collection.id = response.id

_read = (user) -> ->
  Test "GET", "api/collection", null, _session(user), "Owner can read him collections.", 200

_update = (collection, user) -> ->
  collection.title += "+"
  Test "PUT", "api/collection", collection, _session(user), "Owner updates '#{collection.title}' collection.", 200

_delete = (collection, user) -> ->
  Test "DELETE", "api/collection", collection, _session(user), "Owner deletes '#{collection.title}' collection.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.id? then authorization: user.id else null
