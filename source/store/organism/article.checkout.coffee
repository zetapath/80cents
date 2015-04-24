"use strict"

label =
  "1": "Credit Card"
  "2": "Paypal"

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
        "Atom.Heading": value: "Comment", size: "h5"
      ,
        "Atom.Textarea": id: "comment", placeholder: "Write here your observations for your order..."
      ,
        "Atom.Heading": value: "Review your order", size: "h5"
      ,
        "Atom.Button": id: "submit", style: "primary big anchor", text: "Place order", disabled: true, callbacks: ["onPurchase"]
      ]
    ]

  constructor: ->
    super
    __.proxy("GET", "order", id: __.order).then (error, @order) =>
      window.location = "/" if error

      @billing.address.value @order.billing or {}
      @shipping.address.value @order.shipping or {}
      @purchase.payment.refresh
        options   : (label: label[data.type], value: data.type for key, data of @order.settings.payments)
        disabled  : (@order.state isnt __.const.ORDER.STATE.SHOPPING)
      @purchase.payment.value @order.payment_type
      @purchase.comment.value @order.comment
      do @__validPurchase

      if @order.settings.payments.stripe?
        @stripe = StripeCheckout.configure
          key   : @order.settings.payments.stripe.publishable_key
          image : "/img/stripe.png"
          token : (token) =>
            parameters =
              id    : @order.id
              token : token.id
              type  : 1
            __.proxy("PUT", "order/checkout", parameters).then (error, response) ->
              if error
                __.Dialog.Success.show "cross", "Something was wrong"
              else
                __.Dialog.Success.show "checkmark", "Order accepted"
                setTimeout (=> window.location = "/profile"), 3000
        window.addEventListener "popstate", => @stripe.close()


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
      comment     : @purchase.comment.value()
    __.proxy("PUT", "order", parameters).then (error, response) =>
      @stripe.open
        name        : @order.settings.name
        # description : "#{@order.lines.length} products (#{@order.settings.currency}#{@order.amount})"
        amount      : @order.amount.toString().replace(".", "")
        currency    : @order.settings.currency
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
