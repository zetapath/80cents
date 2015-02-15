"use strict"

Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary
C           = require "../constants"

OrderLine = new Schema
  order           : type: String, ref: "Order"
  product         : type: String, ref: "Product"
  quantity        : type: Number, default: 0
  amount          : type: Number
  state           : type: Number, default: C.ORDER.LINE.STATE.PENDING
  tracking_number : type: String
  updated_at      : type: Date
  created_at      : type: Date, default: Date.now


# -- Static methods ------------------------------------------------------------
OrderLine.statics.register = (attributes) ->
  promise = new Hope.Promise()
  orderline = db.model "OrderLine", OrderLine
  new orderline(attributes).save (error, value) -> promise.done error, value
  promise

OrderLine.statics.search = (query, limit = 0, populate = "product") ->
  promise = new Hope.Promise()
  @find(query).limit(limit).populate(populate).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Order Line not found." if value.length is 0
      value = value[0] if value.length isnt 0
    promise.done error, value
  promise

OrderLine.statics.updateAttributes = (id, parameters) ->
  promise = new Hope.Promise()
  parameters.updated_at = new Date()
  @findByIdAndUpdate id, parameters, (error, value) -> promise.done error, value
  promise

OrderLine.statics.delete = (query) ->
  promise = new Hope.Promise()
  @findOneAndRemove query, (error, value) ->
    error = code: 402, message: "Order Line not found." if error or value is null
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
OrderLine.methods.parse = ->
  id              : @_id.toString()
  order           : @order
  product         : @product
  price           : @price
  quantity        : @quantity
  amount          : @amount
  state           : @state
  tracking_number : @tracking_number
  updated_at      : @updated_at
  created_at      : @created_at

exports = module.exports = db.model "OrderLine", OrderLine
