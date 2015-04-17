"use strict"

class Atoms.Molecule.Networks extends Atoms.Molecule.Form

  @extends  : true

  @default:
    children: [
      "Atom.Label": style: "half", value: "Facebook"
    ,
      "Atom.Label": style: "half", value: "Twitter"
    ,
      "Atom.Input": style: "half", name: "facebook"
    ,
      "Atom.Input": style: "half", name: "twitter"
    ,
      "Atom.Label": style: "half", value: "Pinterest"
    ,
      "Atom.Label": style: "half", value: "Instagram"
    ,
      "Atom.Input": style: "half", name: "pinterest"
    ,
      "Atom.Input": style: "half", name: "instagram"
    ]

  value: (values) ->
    values = super values
    result = {}
    result[@attributes.id] = values
    result
