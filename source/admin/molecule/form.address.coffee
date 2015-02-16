"use strict"

class Atoms.Molecule.FormAddress extends Atoms.Molecule.Form

  @extends  : true

  @default:
    children: [
      "Atom.Label": value: "Contact"
    ,
      "Atom.Input": name: "contact"
    ,
      "Atom.Label": value: "Address"
    ,
      "Atom.Input": name: "address"
    ,
      "Atom.Label": style: "half", value: "City"
    ,
      "Atom.Label": style: "half", value: "ZIP Code"
    ,
      "Atom.Input": style: "half", name: "city"
    ,
      "Atom.Input": style: "half", name: "zip_code"
    ,
      "Atom.Label": style: "half", value: "Country"
    ,
      "Atom.Label": style: "half", value: "Telephone"
    ,
      "Atom.Input": style: "half", name: "country"
    ,
      "Atom.Input": style: "half", name: "tel"
    ]

  value: (values) ->
    values = super values
    result = {}
    result[@attributes.id] = values
    result
