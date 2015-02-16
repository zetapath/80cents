"use strict"

Atoms.$ ->
  console.log "0"
  __.page = Atoms.$("body").attr "data-page"
  unless __.session
    new Atoms.Organism.Session()
    Atoms.$("[data-action=session]").on "click", (event) -> __.Dialog.Session.login()
