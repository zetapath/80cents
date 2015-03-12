"use strict"

shortId     = require("shortid")
Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

Discount = new Schema
  owner             : type: Schema.ObjectId, ref: "User"
  code              : type: String, unique: true, default: shortId.generate
  description       : type: String
  percent           : type: Number
  amount            : type: Number
  active            : type: Boolean, default: true
  # -- Specific context
  collection_id     : type: Schema.ObjectId, ref: "Collection"
  product           : type: String
  # -- Dates
  updated_at        : type: Date, default: Date.now
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Discount.statics.create = (values) ->
  promise = new Hope.Promise()
  campaign = db.model "Discount", Discount
  new campaign(values).save (error, value) -> promise.done error, value
  promise

Discount.statics.search = (query, limit = 0, page = 1, populate = "", sort = created_at: "asc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

Discount.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  values.updated_at = new Date()
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Discount.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Discount.methods.parse = ->
  id                : @_id.toString()
  owner             : @owner?.parse?() or @owner
  code              : @code
  description       : @description
  percent           : @percent
  amount            : @amount
  active            : @active
  collection_id     : @collection_id
  product           : @product
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Discount", Discount
