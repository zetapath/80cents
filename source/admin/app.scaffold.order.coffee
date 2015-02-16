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
    "Molecule.Address": id: "shipping", style: "half"
  ,
    "Molecule.Address": id: "billing", style: "half"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "State"
    ,
      "Atom.Text": value: "..."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": style: "half", value: "State"
    ,
      "Atom.Label": style: "half", value: "Tracking Number"
    ,
      "Atom.Select": style: "half", name: "state", options: [
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
      "Atom.Input": style: "half", name: "tracking_number"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Payment"
    ,
      "Atom.Text": value: "..."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": style: "half", value: "Type"
    ,
      "Atom.Label": style: "half", value: "Token"
    ,
      "Atom.Input": style: "half", name: "payment_type"
    ,
      "Atom.Input": style: "half", name: "payment_token"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "cancel", text: "Remove", callbacks: ["onRemove"], disabled: true
    ,
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
