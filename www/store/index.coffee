"use strict"

Hope        = require('zenserver').Hope
Mongoose    = require('zenserver').Mongoose
Collection  = require '../../common/models/collection'
Page        = require '../../common/models/page'
Product     = require '../../common/models/product'
Settings    = require '../../common/models/settings'
Session     = require '../../common/session'
C           = require '../../common/constants'
helper      = require '../../common/helper'

module.exports = (zen) ->

  zen.get '/:page', (request, response) ->
    home = request.parameters.page is ''
    Hope.join([ ->
      Session request, response, redirect = true, owner = false, shopping = true
    , ->
      Settings.cache()
    , ->
      Collection.search visibility: true
    , ->
      if home
        query = visibility: true, highlight: true
        Product.search query, limit = 0, page = 1, populate = ['collection_id']
      else
        Page.search 'search.url_handle': request.parameters.page, limit = 1
    ]).then (errors, values) ->
      return response.page 'base', page: 'error', ['404'] if not home and errors[2] isnt null

      bindings =
        page        : if home then 'home' else 'page'
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        asset       : 'store'
        settings    : values[1]
        collections : (collection.parse() for collection in values[2])
        theme       : helper.getTheme()
      if home
        bindings.products = (product.parse() for product in values[3])
      else
        bindings.content = values[3]?.parse()
        bindings.meta = helper.customizeMeta bindings.settings, bindings.content
      partial = if home then 'home' else 'page'
      response.page 'base', bindings, [
        'store.header'
        "store.#{partial}"
        'partial.products'
        'store.footer']
