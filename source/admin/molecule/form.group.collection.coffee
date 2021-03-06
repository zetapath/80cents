"use strict"

class Atoms.Molecule.Collection extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_collection

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    if @entity
      __.proxy("GET", "collection", id: @entity , true).then (error, collection) =>
        @trigger "progress", 60
        @entity = __.Entity.Collection.createOrUpdate collection
        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"
        @images.value @entity
        @search.value @entity.search
        Atoms.Url.path "admin/collection/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100
