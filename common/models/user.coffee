"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary
C       = require "../constants"

User = new Schema
  mail            : type: String, unique: true
  password        : type: String
  name            : type: String
  avatar          : type: String
  type            : type: Number, default: C.USER.TYPE.CUSTOMER
  # -- Dates
  updated_at      : type: Date
  created_at      : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
User.statics.create = (values) ->
  promise = new Hope.Promise()
  user = db.model "User", User
  new user(values).save (error, value) -> promise.done error, value
  promise

User.statics.signup = (values) ->
  # @TODO: Security password
  promise = new Hope.Promise()
  @findOne(mail: values.mail).exec (error, value) ->
    return promise.done true if value?
    user = db.model "User", User
    new user(values).save (error, value) -> promise.done error, value
  promise

User.statics.login = (values) ->
  # @TODO: Security password
  promise = new Hope.Promise()
  filter =
    mail    : values.mail
    password: values.password
  @findOneAndUpdate filter, values, upsert: true, (error, value) =>
    if not value?
      @signup(values).then (error, value) -> promise.done error, value
    else
      promise.done error, value
  promise

User.statics.search = (query, limit = 0, page = 1, sort = created_at: "desc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "User not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

User.statics.findAndUpdate = (filter, parameters) ->
  promise = new Hope.Promise()
  parameters.updated_at = new Date()
  @findOneAndUpdate filter, parameters, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
User.methods.parse = ->
  id            : @_id.toString()
  mail          : @mail
  name          : @name
  avatar        : @avatar
  updated_at    : @updated_at
  created_at    : @created_at

exports = module.exports = db.model "User", User
