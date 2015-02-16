"use strict"

Atoms.$ ->
  if __.page is "collection"
    Atoms.$("header a[href='/collection/#{__.collection}']").addClass "active"
