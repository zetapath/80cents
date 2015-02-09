"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  session = ZENrequest.OWNERS[0]
  tasks.push _create(product, session) for product in ZENrequest.PRODUCTS
  tasks.push _read session
  tasks.push _update ZENrequest.PRODUCTS[1], session
  tasks.push _delete ZENrequest.PRODUCTS[1], session
  tasks

# PROMISES ---------------------------------------------------------------------
_create = (product, user) -> ->
  Test "POST", "api/product", product, _session(user), "Owner create '#{product.title}' product.", 200, (response) ->
    product.id = response.id

_read = (user) -> ->
  Test "GET", "api/product", null, _session(user), "Owner can read him products.", 200

_update = (product, user) -> ->
  product.title += "+"
  Test "PUT", "api/product", product, _session(user), "Owner updates '#{product.title}' product.", 200

_delete = (product, user) -> ->
  Test "DELETE", "api/product", product, _session(user), "Owner deletes '#{product.title}' product.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.id? then authorization: user.id else null
