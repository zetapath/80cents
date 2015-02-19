"use strict"

Atoms.$ ->
  if __.page is "checkout"
    new Atoms.Organism.Checkout container: "article#checkout"
