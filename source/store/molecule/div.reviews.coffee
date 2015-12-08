"use strict"

class Atoms.Molecule.Reviews extends Atoms.Molecule.Div

  @default:
    container : "[data-reviews]"
    children: [
      "Molecule.List":
        events    : ["select"]
        bind      :
          entity  : "__.Entity.Review"
          atom    : "Atom.Review"
          create  : true
    ,
      "Molecule.Div": children: [
        "Atom.Heading": size: "h5", value: "Your review"
      ,
        "Molecule.Form": id: "form", events: ["submit"], children: [
          "Atom.Label": value: "Title"
        ,
          "Atom.Input": name: "title"
        ,
          "Atom.Label": value: "Description"
        ,
          "Atom.Textarea": name: "description"
        ,
          "Atom.Button": text: "Submit your review"
        ]
      ]
    ]

  constructor: (attributes) ->
    super attributes
    parameters = product: attributes.product
    __.proxy("GET", "review", parameters, background = true).then (error, response) ->
      __.Entity.Review.create review for review in response?.reviews or []
      console.log __.Entity.Review.all()

  onFormSubmit: (event, form)->
    parameters = form.value()
    if parameters.description isnt ""
      parameters.product = @attributes.product
      console.log parameters
      __.proxy("POST", "review", parameters).then (error, response) =>
        console.log "POST /review", error, response
        __.Entity.Review.create response unless error
        form.clean()
    false
