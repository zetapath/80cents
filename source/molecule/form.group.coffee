"use strict"

class Atoms.Molecule.FormGroup extends Atoms.Molecule.Div

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
      __.proxy(method, @attributes.endpoint, properties, true).then (error, response) =>
        unless error
          __.Entity[@attributes.entity_name].createOrUpdate response
          @trigger "progress", 100
