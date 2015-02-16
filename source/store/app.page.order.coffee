"use strict"

Atoms.$ ->
  if __.page is "order"
    Atoms.$("[data-action=delete]").on "click", (event) ->
      parameters =
        id    : Atoms.$(event.target).parents("[data-line]").attr "data-line"
        order : __.order
      __.proxy("DELETE", "order/line", parameters).then (error, response) ->
        window.location.reload()
