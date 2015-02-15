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

    # -- Thirds ----------------------------------------------------------------
    $(".fancybox").fancybox
      padding           : 0
      beforeShow        : -> $.fancybox.wrap.bind "contextmenu", (e) -> false
      openEffect        : 'elastic'
      closeEffect       : 'elastic'
      helpers:
        overlay:
          css:
            background  : 'rgba(0,0,0,0.75) url("/assets/img/overlay.png") repeat 0 0'
