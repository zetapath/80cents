"use strict"

class Atoms.Molecule.Discount extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_discount

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    __.proxy("GET", "collection", null, true).then (error, @collections) =>
      @trigger "progress", 30
      options = (label: c.title, value: c.id for c in @collections.collections)
      options.splice 0, 0, {label: "Select...", value: 0}
      @general.collection.refresh options: options
      if @entity
        __.proxy("GET", "discount", id: @entity , true).then (error, product) =>
          @trigger "progress", 60
          @entity = __.Entity.Discount.createOrUpdate product
          @el.show()
          form.value @entity for form in @children when form.constructor.name is "Form"

          Atoms.Url.path "admin/discount/#{@entity.id}"
          @trigger "progress", 100
      else
        @el.show()
        @trigger "progress", 100
