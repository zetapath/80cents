"use strict"

class Atoms.Molecule.Settings extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_settings

  # -- Private Events ----------------------------------------------------------
  fetch: ->
    super
    __.proxy("GET", "settings", null, true).then (error, @entity) =>
      @trigger "progress", 100
      form.value @entity for form in @children when form.constructor.name is "Form"
      @address.value @entity.address
      @networks.value @entity.networks
