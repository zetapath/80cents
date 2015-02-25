"use strict"

shortId     = require("shortid")
moment      = require("moment")
Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary
C           = require "../constants"

Order = new Schema
  _id             : type: String, unique: true, default: shortId.generate
  user            : type: Schema.ObjectId, ref: "User"
  lines           : [type: Schema.ObjectId, ref: "OrderLine"]
  amount          : type: Number, default: 0
  comment         : type: String
  shipping        : type: Object
  billing         : type: Object
  payment_type    : type: Number
  payment_token   : type: String
  tracking_number : type: String
  state           : type: Number, default: C.ORDER.STATE.SHOPPING
  updated_at      : type: Date
  created_at      : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Order.statics.findOrRegister = (query, attributes) ->
  promise = new Hope.Promise()
  @findOne query, (error, result) ->
    if result or error
      promise.done error, result
    else
      order = db.model "Order", Order
      new order(attributes).save (error, value) -> promise.done error, value
  promise

Order.statics.search = (query, limit = 0, populate = [], sort = created_at: "desc") ->
  promise = new Hope.Promise()
  @find(query).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Order not found." if value.length is 0
      value = value[0] if value.length isnt 0
    promise.done error, value
  promise

Order.statics.updateAttributes = (query, parameters) ->
  promise = new Hope.Promise()
  parameters.updated_at = new Date()
  @findOneAndUpdate query, parameters, (error, value) -> promise.done error, value
  promise

Order.statics.shopping = (session) ->
  promise = new Hope.Promise()
  if session
    @search(user: session, state: C.ORDER.STATE.SHOPPING).then (error, orders) ->
      order = if orders?.length > 0 then orders[0].parse()  else null
      promise.done error, order
  else
    promise.done true, null
  promise

# -- Instance methods ----------------------------------------------------------
Order.methods.saveInPromise = (parameters = {}) ->
  promise = new Hope.Promise()
  @[key] = value for key, value of parameters
  @.save (error) ->
    promise.done (if error then true else error), true
  promise

Order.methods.parse = ->
  id              : @_id.toString()
  user            : @user.parse?() or @user
  lines           : @lines
  amount          : @amount?.toFixed(2)
  comment         : @comment
  shipping        : @shipping
  billing         : @billing
  payment_type    : @payment_type
  payment_token   : @payment_token
  tracking_number : @tracking_number
  state           : @state
  state_label     : C.ORDER.STATES[@state]
  updated_at      : moment(@updated_at).format("MMMM Do YYYY")
  created_at      : moment(@created_at).format("MMMM Do YYYY")

exports = module.exports = db.model "Order", Order
