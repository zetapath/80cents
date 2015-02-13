"use strict"

$ ->
  page = $("body").attr "data-page"
  # -- Product -----------------------------------------------------------------
  if page is "product"
    console.log ">session<", __.session
    el =
      quantity: $ "input#quantity"
    $("button[data-action]").on "click", (event) ->
      event.preventDefault()
      method = $(event.target).attr "data-action"
      if method is "add"
        if __.session
          console.log ">>>", el.quantity.val()
        else
          console.error ">>>", el.quantity.val()

      else if method is "minus" and parseInt(el.quantity.val()) > 1
        el.quantity.val parseInt(el.quantity.val()) - 1
      else if method is "plus"
        el.quantity.val parseInt(el.quantity.val()) + 1
