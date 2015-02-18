"use strict"

Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

Settings = new Schema
  # -- Details
  name              : type: String
  title             : type: String
  description       : type: String
  account_mail      : type: String
  customer_mail     : type: String
  # -- Store Address
  address           : type: Object
  # -- Standards & Formats
  timezone          : type: String
  currency          : type: String
  unit_system       : type: String
  weight_unit       : type: String
  # -- Google Analytics
  google_analytics  : type: String
  # -- Dates
  updated_at        : type: Date, default: Date.now
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Settings.statics.create = (values) ->
  promise = new Hope.Promise()
  campaign = db.model "Settings", Settings
  new campaign(values).save (error, value) -> promise.done error, value
  promise

Settings.statics.search = (query) ->
  promise = new Hope.Promise()
  @find(query).limit(1).exec (error, value) ->
    if error or value.length is 0
      error = code: 402, message: "Not found." if value.length is 0
    else
      value = value[0]
    promise.done error, value
  promise

Settings.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

Settings.statics.cache = ->
  promise = new Hope.Promise()
  if @cached
    promise.done null, @cached
  else
    @search(visibility: true).then (error, value) =>
      promise.done error, @cached = value
  promise

# -- Instance methods ----------------------------------------------------------
Settings.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Settings.methods.parse = ->
  id                : @_id.toString()
  name              : @name
  title             : @title
  description       : @description
  account_mail      : @account_mail
  customer_mail     : @customer_mail
  address           : @address
  timezone          : @timezone
  currency          : @currency
  unit_system       : @unit_system
  weight_unit       : @weight_unit
  google_analytics  : @google_analytics
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Settings", Settings
