"use strict"

Atoms.$ ->
  if __.page is "login" and not __.session
    dialog = new Atoms.Organism.Session()
    dialog.login()
