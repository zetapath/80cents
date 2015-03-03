"use strict"

class Atoms.Molecule.FilterOrder extends Atoms.Molecule.Form

  @default:
    data:
      "flex"        : "horizontal grow"
      "flex-items"  : "start"
      "flex-content": "start"
    children: [
      "Atom.Input": name: "id", placeholder: "id", events: ["keyup"]
    ,
      "Atom.Select": name: "state", options: __.const.order.STATES, value: '', events: ["change"], data: "flex-grow": "min"
    ,
      "Atom.Input": name: "tracking", placeholder: "tracking number", events: ["keyup"], data: "flex-grow": "max"
    ,
      "Atom.Input": name: "min", type: "number", events: ["keyup"], placeholder: "Min. price", data: "flex-grow": "min"
    ,
      "Atom.Input": name: "max", type: "number", events: ["keyup"], placeholder: "Max. price", data: "flex-grow": "min"
    ]
