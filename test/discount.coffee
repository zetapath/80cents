"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  session = ZENrequest.OWNERS[0]
  tasks.push _create(discount, session) for discount in ZENrequest.DISCOUNTS
  tasks.push _read session
  tasks.push _update ZENrequest.DISCOUNTS[0], session
  tasks.push _delete ZENrequest.DISCOUNTS[2], session
  tasks

# PROMISES ---------------------------------------------------------------------
_create = (discount, user) -> ->
  discount.collection_id = ZENrequest.COLLECTIONS[0].id if discount.collection_id
  discount.product = ZENrequest.PRODUCTS[0].id if discount.product
  Test "POST", "api/discount", discount, _session(user), "Owner create '#{discount.description}' discount.", 200, (response) ->
    discount.id = response.id

_read = (user) -> ->
  Test "GET", "api/discount", null, _session(user), "Owner can read discounts.", 200

_update = (discount, user) -> ->
  discount.description += "+"
  Test "PUT", "api/discount", discount, _session(user), "Owner updates '#{discount.description}' discount.", 200

_delete = (discount, user) -> ->
  Test "DELETE", "api/discount", discount, _session(user), "Owner deletes '#{discount.description}' discount.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.token? then authorization: user.token else null
