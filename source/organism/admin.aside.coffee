"use strict"

class Atoms.Organism.AdminAside extends Atoms.Organism.Aside

  @url : "/assets/scaffold/admin.aside.json"

  constructor: ->
    super
    do @render

  # -- Children Bubble Events --------------------------------------------------
  onOption: (event, atom) ->
    context = atom.attributes.text
    Atoms.Url.path "app/#{context}"
    __.Article.AdminArticle.context context
