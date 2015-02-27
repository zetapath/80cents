"use strict"

__.scaffold.form_order =
  endpoint: "order"
  entity_name: "Order"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Order details"
    ,
      "Atom.Text": value: "Write a name and description for this collection."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": style: "hidden", name: "user"
    ,
      "Atom.Label": style: "half", value: "Id"
    ,
      "Atom.Label": style: "half", value: "Amount"
    ,
      "Atom.Input": style: "half", name: "id", disabled: true
    ,
      "Atom.Input": style: "half big", name: "amount", disabled: true
    ,
      "Atom.Label": value: "Comment"
    ,
      "Atom.Textarea": name: "comment"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Shipping & Billing"
    ,
      "Atom.Text": value: "Addresses for the order"
    ]
  ,
    "Molecule.Address": id: "shipping", style: "half", title: "Shipping Contact"
  ,
    "Molecule.Address": id: "billing", style: "half", title: "Billing Contact"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "State & Payment"
    ,
      "Atom.Text": value: "..."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": style: "quarter", value: "State"
    ,
      "Atom.Label": style: "quarter", value: "Tracking Number"
    ,
      "Atom.Label": style: "quarter", value: "Type"
    ,
      "Atom.Label": style: "quarter", value: "Token"
    ,
      "Atom.Select": style: "quarter", name: "state", options: [
        value: 0, label: "Shopping"
      ,
        value: 1, label: "Purchased"
      ,
        value: 2, label: "Processed"
      ,
        value: 3, label: "sent"
      ,
        value: 4, label: "finished"
      ]
    ,
      "Atom.Input": style: "quarter", name: "tracking_number"
    ,
      "Atom.Input": style: "quarter", name: "payment_type", disabled: true
    ,
      "Atom.Input": style: "quarter", name: "payment_token", disabled: true
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Lines"
    ,
      "Atom.Text": value: "..."
    ]
  ,
    "Molecule.List": events: ["select"], callbacks: ["onOrderLine"], bind:
      entity      : "__.Entity.OrderLine"
      atom        : "Atom.Li"
      events      : ["touch"]
      create      : true
      update      : true
      destroy     : true
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
