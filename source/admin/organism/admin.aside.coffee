"use strict"

class Atoms.Organism.AdminAside extends Atoms.Organism.Aside

  @url : "/assets/scaffold/admin/organism/admin.aside.json"

  constructor: ->
    super
    do @render
    id = Atoms.Url.path().split("/").slice(-1)[0]
    for link in @section.navigation.children
      link.el[if link.attributes.text is id then "addClass" else "removeClass"] "active"


  # -- Children Bubble Events --------------------------------------------------
  onOption: (event, atom) ->
    context = atom.attributes.text
    Atoms.Url.path "admin/#{context}"
    __.Article.AdminArticle.context context
    false

  onProfile: ->
    console.log "onProfile"
    false
