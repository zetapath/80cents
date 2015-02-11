"use strict"

shortId     = require("shortid")
Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

Collection = new Schema
  owner             : type: Schema.ObjectId, ref: "User"
  # -- Details
  title             : type: String
  description       : type: String
  images            : [type: String]
  # -- Search Engines
  page_title        : type: String
  meta_description  : type: String
  url_handle        : type: String
  # -- Visibility
  visibility        : type: Boolean, default: true
  # -- Dates
  updated_at        : type: Date, default: Date.now
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Collection.statics.create = (values) ->
  promise = new Hope.Promise()
  campaign = db.model "Collection", Collection
  values = __StringToArray values
  new campaign(values).save (error, value) -> promise.done error, value
  promise

Collection.statics.search = (query, limit = 0, page = 1, populate = "", sort = created_at: "desc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

Collection.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  values = __StringToArray values
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Collection.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Collection.methods.parse = ->
  id              : @_id.toString()
  owner             : @owner?.parse?() or @owner
  title             : @title
  description       : @description
  images            : @images
  page_title        : @page_title
  meta_description  : @meta_description
  url_handle        : @url_handle
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Collection", Collection

# -- Private methods -----------------------------------------------------------
__StringToArray = (values) ->
  for key in ["images"]
    values[key] = values[key]?.toLowerCase().replace(/ /g,"").split(",") or []
  values
