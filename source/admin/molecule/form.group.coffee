"use strict"

class Atoms.Molecule.FormGroup extends Atoms.Molecule.Div

  # -- Children Bubble Events --------------------------------------------------
  onSave: ->
    @trigger "progress", 0

    properties = {}
    valid = true
    for form in @children when form.constructor.base is "Form" and valid
      for field in form.children when field.attributes.required and field.value() is ""
        valid = false
        field.el.focus()
        break
      properties[key] = value for key, value of form.value()
    @trigger "progress", 20

    if valid
      # -- Format specific values
      method = if @entity then "PUT" else "POST"
      __.proxy(method, @attributes.endpoint, properties, true).then (error, response) =>
        unless error
          __.Entity[@attributes.entity_name]?.createOrUpdate response
          unless @entity
            window.location = "/admin/#{@attributes.endpoint}/#{response.id}"
          @trigger "progress", 100

  onRemove: ->
    __.proxy("DELETE", @attributes.endpoint, id: @entity.id).then =>
      window.location = "/admin/#{@attributes.endpoint}s"

  # -- Private Methods --------------------------------------------------------
  fetch: (@entity) ->
    @trigger "progress", 10
    form.clean() for form in @children when form.constructor.name is "Form"
    @images?.value []
    @search?.clean()
    @address?.clean()
    @networks?.clean()
    @shipping?.clean()
    @billing?.clean()
    @el.find("[data-atom-button].cancel")[if @entity then "removeAttr" else "attr"] "disabled", true
    @el.find(".entity")[if @entity then "show" else "hide"]()
