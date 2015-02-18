"use strict"

class Atoms.Organism.Menu extends Atoms.Organism.Aside

  @url : "/assets/scaffold/admin/organism/aside.menu.json"

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
    __.Article.Content.context context
    false

  onProfile: ->
    __.Dialog.Profile.show()
    false
