"use strict"

__.scaffold.form_page =
  endpoint: "page"
  entity_name: "Page"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Page details"
    ,
      "Atom.Text": value: "Write a name and description for this page."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": value: "Title"
    ,
      "Atom.Input": name: "title", placeholder: "e.g. Summer page, Under $100, Staff picks", required: true, events: ["keyup"]
    ,
      "Atom.Label": value: "Content"
    ,
      "Atom.Wysihtml5": name: "content", id: "page"
    ]
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
      "Atom.Input": type: "checkbox", name: "visibility"
    ,
      "Atom.Label": value: "Visible"
    ,
      "Atom.Input": type: "checkbox", name: "header"
    ,
      "Atom.Label": value: "Header menu"
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
