"use strict"

class Atoms.Molecule.Collection extends Atoms.Molecule.Div

  @default  : __.scaffold.form_collection

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
      __.proxy(method, "collection", properties, true).then (error, response) =>
        unless error
          @entity.updateAttributes response
          @trigger "progress", 100

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    __.proxy("GET", "collection", id: @entity , true).then (error, product) =>
      @trigger "progress", 60
      @entity = __.Entity.Collection.createOrUpdate product
      @el.show()
      form.value @entity for form in @children when form.constructor.name is "Form"
      console.log @entity
      @images.value @entity

      Atoms.Url.path "admin/collection/#{@entity.id}"
      @trigger "progress", 100
