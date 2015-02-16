"use strict"

__.scaffold.form_collection =
  endpoint: "collection"
  entity_name: "Collection"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Collection details"
    ,
      "Atom.Text": value: "Write a name and description for this collection."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": value: "Title"
    ,
      "Atom.Input": name: "title", placeholder: "e.g. Summer collection, Under $100, Staff picks", required: true
    ,
      "Atom.Label": value: "Description"
    ,
      "Atom.Wysihtml5": name: "description", id: "collection"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Images"
    ,
      "Atom.Text": value: "Upload and edit images of this product. Drag to reorder images."
    ]
  ,
    "Molecule.Images": id: "images"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Search engines"
    ,
      "Atom.Text": value: "Set up the page title, meta description and handle. These help define how this product shows up on search engines."
    ]
  ,
    "Molecule.SearchEngine": id: "search"
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
      "Atom.Label": value: "Visible"
    ,
      "Atom.Switch": name: "visibility"
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
