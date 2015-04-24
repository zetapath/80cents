"use strict"

__.scaffold.form_payments =
  endpoint: "settings"
  entity_name: "Settings"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Paypal"
    ,
      "Atom.Text": value: "Your store accepts PayPal payments with PayPal Express Checkout. A PayPal button will display during checkout."
    ]
  ,
    "Molecule.Form": id: "paypal", children: [
      "Atom.Label": style: "half", value: "Token"
    ,
      "Atom.Label"
    ,
      "Atom.Input": name: "token", required: true, disabled: true
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Stripe"
    ,
      "Atom.Text": value: "Settings."
    ]
  ,
    "Molecule.Form": id: "stripe", children: [
      "Atom.Label": style: "half", value: "Secret Key"
    ,
      "Atom.Label": style: "half", value: "Publishable Key"
    ,
      "Atom.Input": style: "half", name: "secret_key", required: true
    ,
      "Atom.Input": style: "half", name: "publishable_key", required: true
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
