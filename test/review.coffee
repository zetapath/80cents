"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  session = ZENrequest.OWNERS[0]
  product = ZENrequest.PRODUCTS[0]
  tasks.push _create(review, product, session) for review in ZENrequest.REVIEWS
  tasks.push _read session
  tasks.push _update ZENrequest.REVIEWS[1], session
  tasks.push _delete ZENrequest.REVIEWS[1], session
  tasks

# PROMISES ---------------------------------------------------------------------
_create = (review, product, user) -> ->
  review.product = product.id
  Test "POST", "api/review", review, _session(user), "User create '#{review.description}' review.", 200, (response) ->
    review.id = response.id

_read = (user) -> ->
  Test "GET", "api/review", null, _session(user), "Any user can read reviews of a determinate product.", 200

_update = (review, user) -> ->
  review.title += "+"
  Test "PUT", "api/review", review, _session(user), "Owner updates '#{review.title}' review.", 200

_delete = (review, user) -> ->
  Test "DELETE", "api/review", review, _session(user), "Owner deletes '#{review.title}' review.", 200

# -- Private methods -----------------------------------------------------------
_session = (user = undefined) ->
  if user?.token? then authorization: user.token else null
