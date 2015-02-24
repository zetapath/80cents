"use strict"

class Atoms.Organism.Success extends Atoms.Organism.Dialog

  @default:
    style: "align center"
    children: [
      "Organism.Section": id: "section", children: [
        "Atom.Icon": id: "icon" ,icon: "cart"
        "Atom.Text": id: "text", value: "Product added"
      ]
    ]

  show: (icon = "cart", text = "")->
    @section.icon.refresh icon: icon
    @section.text.refresh value: text
    setTimeout (=> do @hide), 2000
    super

new Atoms.Organism.Success()
