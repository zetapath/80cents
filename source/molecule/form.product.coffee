"use strict"

class Atoms.Molecule.Product extends Atoms.Molecule.Div

  @extends  : true
  @default  : __.scaffold.form_product

  # -- Children Bubble Events --------------------------------------------------
  onSave: ->
    properties = {}
    valid = true
    for form in @children when form.constructor.name is "Form" and valid
      for field in form.children when field.attributes.required and field.value() is ""
        valid = false
        break

      if form.attributes.id is "search"
        properties.search = form.value()
      else
        properties[key] = value for key, value of form.value()

    console.log properties if valid
