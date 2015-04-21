"use strict"

__.scaffold.form_review =
  endpoint: "review"
  entity_name: "Review"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Review details"
    ,
      "Atom.Text": value: "Details of review."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": style: "half", value: "Id"
    ,
      "Atom.Label": style: "half", value: "Product"
    ,
      "Atom.Input": style: "half", name: "id", disabled: true
    ,
      "Atom.Input": style: "half big", name: "product", disabled: true
    ,
      "Atom.Label": value: "Title"
    ,
      "Atom.Input": name: "title"
    ,
      "Atom.Label": value: "Description"
    ,
      "Atom.Textarea": name: "description"
    ,
      "Atom.Label": value: "Rating"
    ,
      "Atom.Input": type: "number", name: "rating"
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
