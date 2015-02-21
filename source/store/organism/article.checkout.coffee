"use strict"


class Atoms.Organism.Checkout extends Atoms.Organism.Section

  @default:
    style: "active container"
    children: [
      "Molecule.Div": id: "billing", style: "box", data: {column: "4"}, children: [
        "Atom.Heading": value: "Billing Details", size: "h5"
      ,
        "Molecule.Address": id: "address", title: "Contact", required: true
      ]
    ,
      "Molecule.Div": id: "shipping", style: "box", data: {column: "4"}, children: [
        "Atom.Heading": value: "Ship to a different address?", style: "inline", size: "h5"
      ,
        "Atom.Input": id: "different", type: "checkbox", events: ["change"], callbacks: ["onShippingAddress"]
      ,
        "Molecule.Address": id: "address", title: "Contact", required: true, disabled: true
      ]
    ,
      "Molecule.Div": id: "purchase", style: "box", data: {column: "4"}, children: [
        "Atom.Heading": value: "Payment Method", size: "h5"
      ,
        "Atom.Select": id: "payment", name: "payment_type"
      ,
        "Atom.Heading": value: "Review your order", size: "h5"
      ,
        "Atom.Button": id: "submit", style: "primary big anchor", text: "Place order", disabled: true, callbacks: ["onPurchase"]
      ]
    ]

  constructor: ->
    super
    __.proxy("GET", "order", id: __.order).then (error, @order) =>
      @billing.address.value @order.billing or {}
      @shipping.address.value @order.shipping or {}
      @purchase.payment.refresh
        options   : @order.available_payments
        disabled  : (@order.state isnt __.const.ORDER.STATE.SHOPPING)
      @purchase.payment.value @order.payment_type
      do @__validPurchase

    @stripe = StripeCheckout.configure
      # key   : "pk_live_iKiZde4F0KbB8LC1fT5jUeF3"
      key   : "pk_test_pGXz0QlpwU1DBnHYuoJOXbH5"
      image : "/assets/img/payment_stripe.jpg"
      token : (token) =>
        parameters =
          id    : @order.id
          token : token.id
          type  : 1
        __.proxy("PUT", "order/checkout", parameters).then (error, response) ->
          window.location = "/profile"

    window.addEventListener "popstate", => @handler.close()


  # -- Children Bubble Events --------------------------------------------------
  onAddressChange: (event, form) =>
    valid = true
    unless @shipping.different.value()
      @shipping.address.value @billing.address.value().address
    do @__validPurchase

  onShippingAddress: (event, atom) ->
    for child in @shipping.address.children when child.constructor.name is "Input"
      child.el.attr "disabled", not atom.value()

  onPayment: (event, atom) ->
    console.log "onPayment", event, atom

  onPurchase: ->
    parameters =
      id          : __.order
      billing     : @billing.address.value().address
      shipping    : @shipping.address.value().address
      payment_type: @purchase.payment.value()
    __.proxy("PUT", "order", parameters).then (error, response) =>
      console.log "PUT/order", error, response

      amount = @order.amount.toString().replace(".", "")
      @stripe.open
        name        : "Nomada.io"
        description : "#{@order.lines.length} products ($#{amount})"
        amount      : amount
        email       : __.session.mail


  # -- Private Events ----------------------------------------------------------
  __validPurchase: ->
    valid = true
    # -- Address
    for context in ["billing", "shipping"] when valid is true
      for key, value of @[context].address.value().address when value is ""
        valid = false
        break
    # -- Payment method

    @purchase.submit.refresh disabled: (not valid)
    valid


