"use strict"

shortId     = require("shortid")
Hope        = require("zenserver").Hope
Schema      = require("zenserver").Mongoose.Schema
db          = require("zenserver").Mongo.connections.primary

array_parse = ["tags", "sizes", "colors", "materials", "images"]

Product = new Schema
  _id               : type: String, unique: true, default: shortId.generate
  owner             : type: Schema.ObjectId, ref: "User"
  # -- Details
  title             : type: String
  description       : type: String
  type              : type: String
  vendor            : type: String
  # -- Inventory & variants
  price             : type: Number
  compare_at_price  : type: Number
  stock             : type: Number
  barcode           : type: String
  tax               : type: Boolean, default: true
  requires_shipping : type: Boolean, default: true
  weight            : type: Number
  # -- Options
  sizes             : [type: String]
  colors            : [type: String]
  materials         : [type: String]
  # -- Images
  default_image     : type: String
  images            : [type: String]
  # -- Collection
  collection_id     : type: Schema.ObjectId, ref: "Collection"
  tags              : [type: String]
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
Product.statics.create = (values) ->
  promise = new Hope.Promise()
  campaign = db.model "Product", Product
  new campaign(values).save (error, value) -> promise.done error, value
  promise

Product.statics.search = (query, limit = 0, page = 1, populate = "", sort = created_at: "desc") ->
  promise = new Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).populate(populate).sort(sort).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "Not found." if value.length is 0
      value = value[0]
    promise.done error, value
  promise

Product.statics.findAndUpdate = (filter, values) ->
  promise = new Hope.Promise()
  # -- Specific formats
  for key in array_parse
    values[key] = values[key]?.toLowerCase().replace(/ /g,"").split(",") or []
  @findOneAndUpdate filter, values, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Product.methods.delete = ->
  promise = new Hope.Promise()
  @remove (error) -> promise.done error, true
  promise

Product.methods.parse = ->
  id                : @_id.toString()
  owner             : @owner?.parse?() or @owner
  title             : @title
  description       : @description
  type              : @type
  vendor            : @vendor
  price             : @price
  compare_at_price  : @compare_at_price
  stock             : @stock
  barcode           : @barcode
  tax               : @tax
  requires_shipping : @requires_shipping
  weight            : @weight
  sizes             : @sizes
  colors            : @colors
  materials         : @materials
  default_image     : @default_image
  images            : @images
  collection_id     : @collection_id
  tags              : @tags
  page_title        : @page_title
  meta_description  : @meta_description
  url_handle        : @url_handle
  visibility        : @visibility
  updated_at        : @updated_at
  created_at        : @created_at

exports = module.exports = db.model "Product", Product
