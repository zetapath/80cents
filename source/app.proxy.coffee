"use strict"

window.__ = window.__ or {}

__.proxy = (type, method, parameters = {}, background = false) ->
  promise = new Hope.Promise()
  unless background then __.Dialog.Loading.show()

  if type in ["POST", "PUT"]
    parameters = JSON.stringify parameters
    content_type = "application/json"

  token = if session? then session.token else null
  $.ajax
    url         : "#{__.host}api/#{method}"
    type        : type
    data        : parameters
    dataType    : "json"
    contentType : content_type
    success: (xhr) ->
      unless background then do __.Dialog.Loading.hide
      promise.done null, xhr
    error: (xhr, response) =>
      unless background then do __.Dialog.Loading.hide
      error = code: xhr.status, message: xhr.responseJSON.message
      promise.done error, null
  promise
