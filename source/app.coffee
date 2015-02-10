"use strict"

__.scaffold = {}

Atoms.$ ->
  Atoms.Url.options.absolute = true
  page = Atoms.$("body").attr "data-page"

  # -- Landing -----------------------------------------------------------------
  if page is "landing"
    new Atoms.Organism.Session()
    __.Dialog.Session.show()

  if page is "app"
    new Atoms.Organism.AdminAside()
    new Atoms.Organism.AdminArticle()
