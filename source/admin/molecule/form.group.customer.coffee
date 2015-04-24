"use strict"

class Atoms.Molecule.Customer extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_customer

  # -- Private Events ----------------------------------------------------------
  fetch: (@entity) ->
    super
    @options.cancel.refresh
      style: "cancel", text: "Deactivate", callbacks: ["onRemove"], disabled: false
    __.Entity.Customer.destroyAll()
    if @entity
      Hope.join([ =>
        __.proxy "GET", "customer", id: @entity, true
      , =>
        __.proxy "GET", "order", user: @entity, true
      ]).then (errors, values) =>
        # -- Customer
        @trigger "progress", 60
        @entity = __.Entity.Customer.createOrUpdate values[0]
        if @entity.active is false
          @options.cancel.refresh
            style: "accept", text: "Activate", callbacks: ["onActivate"]
        @el.show()
        form.value @entity for form in @children when form.constructor.name is "Form"
        # -- Orders
        __.Entity.Order.createOrUpdate order for order in values[1].orders

        Atoms.Url.path "admin/customer/#{@entity.id}"
        @trigger "progress", 100
    else
      @el.show()
      @trigger "progress", 100

  onActivate: (event) ->
    event.preventDefault()
    parameters = id: @entity.id, active: true
    @trigger "progress", 20
    __.proxy("DELETE", "customer", parameters, true).then (error, response) =>
      unless error
        window.location = "/admin/customers"
        @trigger "progress", 100
