"use strict"

class Atoms.Organism.Menu extends Atoms.Organism.Aside

  @url : "/assets/core/scaffold/admin/organism/aside.menu.json"

  constructor: ->
    super
    do @render
    @activeItem Atoms.Url.path().split("/").slice(-1)[0]


  # -- Children Bubble Events --------------------------------------------------
  onOption: (event, atom) ->
    @activeItem id = atom.attributes.text
    Atoms.Url.path "admin/#{id}"
    __.Article.Content.context id
    false

  onProfile: ->
    __.Dialog.Profile.show()
    false

  activeItem: (id) ->
    for navigation in @section.children
      for link in navigation.children
        link.el[if link.attributes.text is id then "addClass" else "removeClass"] "active"
