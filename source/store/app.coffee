"use strict"

Atoms.$ ->
  page = Atoms.$("body").attr "data-page"
  unless __.session
    new Atoms.Organism.Session()
    # __.Dialog.Session.login()
    Atoms.$("[data-action=session]").on "click", (event) ->
      __.Dialog.Session.login()

  # -- Product -----------------------------------------------------------------
  if page is "product"
    el = quantity: Atoms.$ "input#quantity"
    Atoms.$("article button[data-action]").on "click", (event) ->
      event.preventDefault()
      method = $(event.target).attr "data-action"
      quantity = parseInt(el.quantity.val())
      if method is "add"
        if __.session
          console.log ">>>", el.quantity.val()
        else
          console.error ">>>", el.quantity.val()
      else if method is "minus" and quantity > 1
        el.quantity.val quantity - 1
      else if method is "plus" and quantity < 100
        el.quantity.val quantity + 1
