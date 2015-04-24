"use strict"

__.scaffold.form_customer =
  endpoint: "customer"
  entity_name: "Customer"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Customer details"
    ,
      "Atom.Text": value: "..."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": style: "half", value: "First Name"
    ,
      "Atom.Label": style: "half", value: "Last Name"
    ,
      "Atom.Input": style: "half", name: "first_name"
    ,
      "Atom.Input": style: "half", name: "last_name"
    ,
      "Atom.Label": value: "Mail"
    ,
      "Atom.Input": name: "mail", disabled: true
    ,
      "Atom.Label": value: "Avatar url"
    ,
      "Atom.Input": name: "avatar"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Orders"
    ,
      "Atom.Text": value: "List of orders."
    ]
  ,
    "Molecule.List": events: ["select"], callbacks: ["onOrder"], bind:
      entity      : "__.Entity.Order"
      atom        : "Atom.Li"
      events      : ["touch"]
      create      : true
      update      : true
      destroy     : true
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": id: "options", children: [
      "Atom.Button": id: "cancel", style: "cancel", text: "Deactivate", callbacks: ["onRemove"], disabled: true
    ,
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
