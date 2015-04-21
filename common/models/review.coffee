"use strict"

shortId     = require("shortid")
Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

Review = new Schema
  user              : type: Schema.ObjectId, ref: "User"
  product           : type: String, ref: "Product"
  # -- Details
  title             : type: String
  description       : type: String
  rating            : type: Number
  # -- Dates
  updated_at        : type: Date, default: Date.now
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Review.statics.create = (values) ->
  promise = new Hope.Promise()
  review = db.model "Review", Review
  new review(values).save (error, value) -> promise.done error, value
  promise

Review.statics.search = (query, limit = 0, page = 1, populate = "user", sort = created_at: "asc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

Review.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  values.updated_at = new Date()
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Review.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Review.methods.parse = ->
  id                : @_id.toString()
  user              : @user?.parse?() or @user
  product           : @product?.parse?() or @product
  title             : @title
  description       : @description
  rating            : @rating
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Review", Review
