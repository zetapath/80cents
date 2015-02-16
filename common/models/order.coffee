"use strict"

shortId     = require("shortid")
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
  discount        : type: Number, default: 0
  payment_type    : type: String
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

Order.statics.search = (query, limit = 0, populate = "lines", sort = "created_at") ->
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
  amount          : (@amount - ((@amount * @discount) / 100)).toFixed(2)
  comment         : @comment
  shipping        : @shipping
  billing         : @billing
  discount        : @discount
  discount_amount : ((@amount * @discount) / 100).toFixed(2)
  payment_type    : @payment_type
  payment_token   : @payment_token
  tracking_number : @tracking_number
  state           : @state
  updated_at      : @updated_at
  created_at      : @created_at

exports = module.exports = db.model "Order", Order
