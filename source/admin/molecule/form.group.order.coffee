"use strict"

class Atoms.Molecule.Order extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_order

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    __.Entity.OrderLine.destroyAll()
    if @entity
      __.proxy("GET", "order", id: @entity , true).then (error, product) =>
        @trigger "progress", 60
        @entity = __.Entity.Order.createOrUpdate product

        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"
        @shipping.value @entity.shipping
        @billing.value @entity.billing

        __.Entity.OrderLine.createOrUpdate line for line in @entity.lines

        Atoms.Url.path "admin/order/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100
