"use strict"

class Atoms.Molecule.Review extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_review

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    __.Entity.OrderLine.destroyAll()
    if @entity
      __.proxy("GET", "review", id: @entity , true).then (error, order) =>
        @trigger "progress", 60
        @entity = __.Entity.Review.createOrUpdate order
        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"

        Atoms.Url.path "admin/review/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100
