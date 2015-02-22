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
      "Atom.Label": value: "Name"
    ,
      "Atom.Input": name: "name", placeholder: "e.g. Summer collection, Under $100, Staff picks", required: true
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
    "Molecule.Navigation": children: [
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
