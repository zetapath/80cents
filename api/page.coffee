"use strict"

Hope        = require("zenserver").Hope
Page        = require "../common/models/page"
Settings    = require "../common/models/settings"
Session     = require "../common/session"

module.exports = (server) ->

  server.get "/api/page", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      limit = 0
      filter = owner: session._id
      if request.parameters.id?
        filter._id = request.parameters.id
        limit = 1
      Page.search filter, limit
    ]).then (error, value) ->
      return response.unauthorized() if error
      if request.parameters.id
        result = value.parse()
      else
        result = pages: (c.parse() for c in value) or []
      response.json result


  server.post "/api/page", (request, response) ->
    if request.required ["title"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        values = request.parameters
        values.owner = session._id
        Page.create values
      , (error, @page) =>
        Page.search visibility: true
      , (error, pages) ->
        pages = (title: p.title, header: p.header, url_handle: p.search?.url_handle for p in pages)
        Settings.findAndUpdate {}, pages: pages
      ]).then (error, value) =>
        if error then response.unauthorized() else response.json @page.parse()


  server.put "/api/page", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        filter =
          _id   : request.parameters.id
          owner : session._id
        Page.findAndUpdate filter, request.parameters
      , (error, @page) =>
        Page.search visibility: true
      , (error, pages) ->
        pages = (title: p.title, header: p.header, url_handle: p.search?.url_handle for p in pages)
        Settings.findAndUpdate {}, pages: pages
      ]).then (error, value) =>
        if error then response.unauthorized() else response.json @page.parse()


  server.delete "/api/page", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response, null, owner = true
      , (error, session) ->
        Page.search _id: request.parameters.id, owner: session, limit = 1
      , (error, page) ->
        page.delete()
      ]).then (error, value)->
        if error then response.unauthorized() else response.ok()
