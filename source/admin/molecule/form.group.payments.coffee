"use strict"

class Atoms.Molecule.Payments extends Atoms.Molecule.FormGroup

  @default  : __.scaffold.form_payments

  # -- Children Bubble Events --------------------------------------------------
  onSave: ->
    payments = {}
    for form in @children when form.constructor.base is "Form" and form.attributes.id
      payments[form.attributes.id] = form.value()
      for field in form.children when field.attributes.required and field.value() is ""
        field.el.focus()
        delete payments[form.attributes.id]
        break

    payments.stripe.type = 1 if payments.stripe?
    payments.paypal.type = 2 if payments.paypal?
    # -- Format specific values
    properties = payments: payments
    __.proxy("PUT", @attributes.endpoint, properties, true).then (error, response) =>
      @trigger "progress", 100 unless error


  # -- Private Events ----------------------------------------------------------
  fetch: ->
    super
    __.proxy("GET", "settings", null, true).then (error, @entity) =>
      @trigger "progress", 100
      console.log @entity
      for payment in ["paypal", "stripe", "bank_transfer"]
        @[payment]?.value @entity.payments?[payment]
