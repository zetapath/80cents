"use strict"

Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary
PassHash    = require "password-hash"
C           = require "../constants"
token       = require "../token"

User = new Schema
  type            : type: Number, default: C.USER.TYPE.CUSTOMER
  mail            : type: String, unique: true
  password        : type: String
  first_name      : type: String
  last_name       : type: String
  phone           : type: String
  homepage        : type: String
  bio             : type: String
  avatar          : type: String, default: "avatar.jpg"
  # -- Security
  token           : type: String
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
  promise = new Hope.Promise()
  @findOne(mail: values.mail).exec (error, value) ->
    return promise.done true if value?
    user = db.model "User", User
    values.password = PassHash.generate values.password
    new user(values).save (error, value) -> promise.done error, value
  promise

User.statics.login = (values) ->
  promise = new Hope.Promise()
  @findOne mail: values.mail, (error, user) =>
    if user is null or not PassHash.verify values.password, user.password
      promise.done true
    else
      user.token = token user._id
      user.save()
      promise.done error, user
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
  first_name    : @first_name
  last_name     : @last_name
  phone         : @phone
  homepage      : @homepage
  bio           : @bio
  avatar        : @avatar
  updated_at    : @updated_at
  created_at    : @created_at

exports = module.exports = db.model "User", User
