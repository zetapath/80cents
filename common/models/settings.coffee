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
  language          : type: String, default: "en-US"
  timezone          : type: String
  currency          : type: String
  unit_system       : type: String
  weight_unit       : type: String
  # -- Google Analytics
  google_analytics  : type: String
  # -- Payments
  payments          : type: Object
  # -- Networks
  networks          : type: Object
  # -- Cached Elements
  collections       : type: Array
  pages             : type: Array
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
  @find(query).limit(1).exec (error, value) =>
    if error or value.length is 0
      @create().then (error, value) ->
        error = code: 402, message: "Not found." if value.length is 0
        promise.done error, value
    else
      value = value[0]
      promise.done error, value
  promise

Settings.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  values.updated_at = new Date()
  @findOneAndUpdate filter, values, (error, value) =>
    @cached = value?.parse()
    promise.done error, value
  promise

Settings.statics.cache = ->
  promise = new Hope.Promise()
  if @cached
    promise.done null, @cached
  else
    @search().then (error, value) =>
      value = value?.parse() or {}
      value.networks = (type: type, url: url for type, url of value.networks when url isnt "")
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
  networks          : @networks
  language          : @language
  timezone          : @timezone
  currency          : @currency
  currency_shortcut : _currencyShortcut @currency
  unit_system       : @unit_system
  weight_unit       : @weight_unit
  google_analytics  : @google_analytics
  collections       : @collections
  pages             : @pages
  payments          : @payments
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Settings", Settings

# -- Private methods -----------------------------------------------------------
_currencyShortcut = (currency) ->
  currency = "$" if currency is "USD"
  currency = "€" if currency is "EUR"
  currency
