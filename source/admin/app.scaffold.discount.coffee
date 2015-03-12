"use strict"

__.scaffold.form_discount =
  endpoint: "discount"
  entity_name: "Discount"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Discount details"
    ,
      "Atom.Text": value: "Define your type of discount for your products."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": value: "Coupon Code"
    ,
      "Atom.Input": name: "code", required: true, events: ["keyup"]
    ,
      "Atom.Label": value: "Description"
    ,
      "Atom.Textarea": name: "description"
    ,
      "Atom.Label": style: "half", value: "Percent of discount"
    ,
      "Atom.Label": style: "half", value: "Amount to discount"
    ,
      "Atom.Input": style: "half", name: "percent"
    ,
      "Atom.Input": style: "half", name: "amount"
    ]
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Specific"
    ,
      "Atom.Text": value: "You can define if discount is in a determinate collection or product."
    ]
  ,
    "Molecule.Form": id: "general", children: [
      "Atom.Label": value: "Collection"
    ,
      "Atom.Select": style: "half", id: "collection", name: "collection_id", options: []
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Visibility"
    ,
      "Atom.Text": value: "Control whether this product can be seen."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": type: "checkbox", name: "active"
    ,
      "Atom.Label": value: "Active"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
