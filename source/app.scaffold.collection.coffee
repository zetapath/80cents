"use strict"

__.scaffold.form_collection =
  endpoint: "collection"
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
      "Atom.Textarea": name: "description"
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
    "Molecule.Form": children: [
      "Atom.Label": value: "Page title"
    ,
      "Atom.Input": name: "page_title", placeholder: "less than 70 characters", maxlength: 70
    ,
      "Atom.Label": value: "Meta Description"
    ,
      "Atom.Textarea": name: "meta_description", placeholder: "less than 160 characters", maxlength: 160
    ,
      "Atom.Label": value: "URL & Handle"
    ,
      "Atom.Input": name: "url_handle", placeholder: "/products/"
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
      "Atom.Label": value: "Visible"
    ,
      "Atom.Switch": name: "visibility"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
  ]
