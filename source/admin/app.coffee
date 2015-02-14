"use strict"

__.scaffold = {}

Atoms.$ ->
  Atoms.Url.options.absolute = true
  page = Atoms.$("body").attr "data-page"

  # -- Landing -----------------------------------------------------------------
  if page is "session"
    new Atoms.Organism.Session()
    do __.Dialog.Session[if __.owner then "login" else "signup"]

  if page is "admin"
    new Atoms.Organism.AdminAside()
    new Atoms.Organism.AdminArticle()
