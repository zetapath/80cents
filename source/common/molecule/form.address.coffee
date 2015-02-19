"use strict"

class Atoms.Molecule.Address extends Atoms.Molecule.Form

  @extends  : true

  @default:
    children: [
      "Atom.Label": value: "Contact"
    ,
      "Atom.Input": name: "contact"
    ,
      "Atom.Label": value: "Street"
    ,
      "Atom.Input": name: "address"
    ,
      "Atom.Label": style: "half", value: "City"
    ,
      "Atom.Label": style: "half", value: "Postal / ZIP Code"
    ,
      "Atom.Input": style: "half", name: "city"
    ,
      "Atom.Input": style: "half", name: "zip_code"
    ,
      "Atom.Label": style: "half", value: "Country"
    ,
      "Atom.Label": style: "half", value: "Phone"
    ,
      "Atom.Input": style: "half", name: "country"
    ,
      "Atom.Input": style: "half", name: "tel"
    ]

  constructor: (attributes) ->
    if attributes.required or attributes.disabled
      attributes.events = ["change"]
      attributes.callbacks = ["onAddressChange"]
      for child, value in @constructor.default.children when child["Atom.Input"]
        child["Atom.Input"].events = ["keyup"]
        child["Atom.Input"].disabled = attributes.disabled if attributes.disabled
    super attributes
    @children[0].el.html "#{@attributes.title}"

  value: (values) ->
    values = super values
    result = {}
    result[@attributes.id] = values
    result
