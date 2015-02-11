"use strict"

class Atoms.Molecule.Product extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_product

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    @trigger "progress", 10
    form.clean() for form in @children when form.constructor.name is "Form"
    @images.value []

    __.proxy("GET", "collection", null, true).then (error, @collections) =>
      @trigger "progress", 30
      if @entity
        __.proxy("GET", "product", id: @entity, true).then (error, product) =>
          @trigger "progress", 60
          @entity = __.Entity.Product.createOrUpdate product
          @el.show()
          # -- Format specific values
          @entity[key] = @entity[key].join ", " for key in ["sizes", "materials", "colors", "tags"]
          @images.value @entity
          @collection.id.refresh
            options: (label: c.title, value: c.id for c in @collections.collections)
          form.value @entity for form in @children when form.constructor.name is "Form"

          Atoms.Url.path "admin/product/#{@entity.id}"
          @trigger "progress", 100
      else
        @el.show()
        @trigger "progress", 100
