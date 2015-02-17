"use strict"

class Atoms.Molecule.Profile extends Atoms.Molecule.Div

  @extends  : true

  @default:
    children: [
      "Atom.Figure": id: "figure"
    ,
      "Atom.Text": id: "name", value: "Your name...", style: "small"
    ,
      "Atom.Text": id: "email", style: "tiny"
    ]

  constructor: ->
    super
    @figure.refresh url: __.session.avatar
    @name.refresh value: __.session.name
    @email.refresh value: __.session.mail
