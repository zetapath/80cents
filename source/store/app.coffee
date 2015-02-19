"use strict"

__.const = {}

Atoms.$ ->
  __.page = Atoms.$("body").attr "data-page"
  unless __.session
    new Atoms.Organism.Session()
    Atoms.$("[data-action=session]").on "click", (event) -> __.Dialog.Session.login()

  # -- Active navigation header element
  if __.page in ["collection", "page"]
    Atoms.$("header a[href='#{window.location.pathname}']").addClass "active"
