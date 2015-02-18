"use strict"

__.scaffold = {}
__.const = {}

Atoms.$ ->
  Atoms.Url.options.absolute = true
  page = Atoms.$("body").attr "data-page"

  # -- Landing -----------------------------------------------------------------
  if page is "session"
    new Atoms.Organism.Session()
    do __.Dialog.Session[if __.owner then "login" else "signup"]

  if page is "admin"
    new Atoms.Organism.Menu()
    new Atoms.Organism.Content()
    new Atoms.Organism.Profile()
