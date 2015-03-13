"use strict"

Atoms.$ ->
  if __.page is "order"
    Atoms.$("[data-action=delete]").on "click", (event) ->
      parameters =
        id    : Atoms.$(event.target).parents("[data-line]").attr "data-line"
        order : __.order
      __.proxy("DELETE", "order/line", parameters).then (error, response) ->
        window.location.reload()

    Atoms.$("[data-action=discount]").on "click", (event) ->
      parameters =
        order : __.order
        code  : Atoms.$("input")?.val()
      if parameters.code isnt ""
        __.proxy("PUT", "order/discount", parameters).then (error, response) ->
          return __.Dialog.Success.show "cross", "Coupon not found" if error
          window.location.reload()
