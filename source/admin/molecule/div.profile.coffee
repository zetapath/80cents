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
    @refresh __.session

  refresh: (data) ->
    @figure.refresh url: "/uploads/#{data.avatar}"
    @name.refresh value: data.first_name
    @email.refresh value: data.mail
