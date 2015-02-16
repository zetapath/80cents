"use strict"

class Atoms.Molecule.SearchEngine extends Atoms.Molecule.Form

  @extends  : true

  @default:
    children: [
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
      "Atom.Input": name: "url_handle", placeholder: "http://"
    ]

  value: (values) ->
    values = super values
    result = {}
    result[@attributes.id] = values
    result
