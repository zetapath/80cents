"use strict"

class Atoms.Molecule.Page extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_page

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    if @entity
      __.proxy("GET", "page", id: @entity , true).then (error, product) =>
        @trigger "progress", 60
        @entity = __.Entity.Page.createOrUpdate product
        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"
        @search.value @entity.search

        Atoms.Url.path "admin/page/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100
