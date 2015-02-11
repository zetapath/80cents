"use strict"

class Atoms.Molecule.Product extends Atoms.Molecule.Div

  @default  : __.scaffold.form_product

  # -- Children Bubble Events --------------------------------------------------
  onSave: ->
    properties = {}
    valid = true
    for form in @children when form.constructor.name is "Form" and valid
      for field in form.children when field.attributes.required and field.value() is ""
        valid = false
        break
      properties[key] = value for key, value of form.value()

    if valid
      # -- Format specific values
      properties.images = @images.value().join ", "

      method = if @entity then "PUT" else "POST"
      __.proxy(method, "product", properties, true).then (error, response) =>
        unless error
          @entity.updateAttributes response
          @trigger "progress", 100
          # setTimeout (=> @trigger "save"), 500

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    @trigger "progress", 20
    __.proxy("GET", "product/#{@entity}", null ,true).then (error, product) =>
      @trigger "progress", 40
      @entity = __.Entity.Product.createOrUpdate product
      @el.show()
      # -- Format specific values
      @entity[key] = @entity[key].join ", " for key in ["sizes", "materials", "colors", "tags"]
      @images.value @entity
      form.value @entity for form in @children when form.constructor.name is "Form"

      Atoms.Url.path "admin/product/#{@entity.id}"
      @trigger "progress", 100
