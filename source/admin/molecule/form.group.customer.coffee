"use strict"

class Atoms.Molecule.Customer extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_customer

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    __.Entity.Order.destroyAll()
    if @entity
      Hope.join([ =>
        __.proxy "GET", "customer", id: @entity, true
      , =>
        __.proxy "GET", "order", user: @entity, true
      ]).then (errors, values) =>
        # -- Customer
        @trigger "progress", 60
        @entity = __.Entity.Customer.createOrUpdate values[0]
        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"
        # -- Orders
        __.Entity.Order.createOrUpdate order for order in values[1].orders
        console.log __.Entity.Order.all()

        Atoms.Url.path "admin/customer/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100
