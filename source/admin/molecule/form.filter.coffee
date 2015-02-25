"use strict"

class Atoms.Molecule.Filter extends Atoms.Molecule.Form

  @default:
    data:
      "flex"        : "horizontal grow"
      "flex-items"  : "start"
      "flex-content": "start"
    children: [
      "Atom.Input": name: "title", placeholder: "title", events: ["keyup"]
    ,
      "Atom.Input": name: "description",placeholder: "description", events: ["keyup"], data: "flex-grow": "max"
    ,
      "Atom.Input": name: "min",type: "number", events: ["keyup"], placeholder: "Min. price", data: "flex-grow": "min"
    ,
      "Atom.Input": name: "max",type: "number", events: ["keyup"], placeholder: "Max. price", data: "flex-grow": "min"
    ,
      "Atom.Label": value: "visible"
    ,
      "Atom.Switch": name: "visible", placeholder: "Max. price", events: ["change"]
    ]
