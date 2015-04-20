"use strict"

Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

Page = new Schema
  owner             : type: Schema.ObjectId, ref: "User"
  # -- Details
  title             : type: String
  content           : type: String
  # -- Search Engines
  search            : type: Object
  # -- Visibility
  header            : type: Boolean, default: false
  visibility        : type: Boolean, default: true
  # -- Dates
  updated_at        : type: Date, default: Date.now
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Page.statics.create = (values) ->
  promise = new Hope.Promise()
  page = db.model "Page", Page
  new page(values).save (error, value) -> promise.done error, value
  promise

Page.statics.search = (query, limit = 0, page = 1, populate = "", sort = created_at: "asc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

Page.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  values.updated_at = new Date()
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Page.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Page.methods.parse = ->
  id                : @_id.toString()
  owner             : @owner?.parse?() or @owner
  title             : @title
  content           : @content
  search            : @search
  header            : @header
  visibility        : @visibility
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Page", Page
