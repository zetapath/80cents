"use strict"
Test = require("zenrequest").Test

module.exports = ->
  customer = ZENrequest.USERS[0]
  tasks = []
  # -- Lines
  for order in ZENrequest.ORDERS
    tasks.push _addLine customer, line, index for line, index in order.lines
    tasks.push _removeLine customer, line
  # -- Order
  tasks.push _update customer, order for order in ZENrequest.ORDERS
  # -- Order (owner)
  tasks

# -- Tasks ---------------------------------------------------------------------
_addLine = (user, line, index) -> ->
  line.product = ZENrequest.PRODUCTS[index].id
  Test "POST", "api/order/line", line, _session(user), "#{user.mail} added a new line #{line.id} x #{line.quantity}", 200, (response) ->
    line.id = response.id
    line.order = response.order

_removeLine = (user, line) -> ->
  Test "DELETE", "api/order/line", line, _session(user), "#{user.mail} added a new line #{line.id} x #{line.quantity}", 200

_update = (user, order) -> ->
  order.id = order.lines[0].order
  Test "PUT", "api/order", order, _session(user), "#{user.mail} update order #{order.id}"

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.id? then authorization: user.id else null
