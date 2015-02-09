"use strict"

class Atoms.Organism.AdminArticle extends Atoms.Organism.Article

  @url : "/assets/scaffold/admin.article.json"

  constructor: ->
    super
    do @render

    id = Atoms.Url.path().split("/").slice(-1)[0]
    @context id

  # -- Children Bubble Events --------------------------------------------------


  # -- Private Events ----------------------------------------------------------
  context: (id) =>
    @header.title.el.html id
    for button in @header.navigation.children
      do button.el[if button.attributes.context is id then "show" else "hide"]
    # @_fetchContext id, "Campaign" if id is "campaigns"
    # @_fetchContext id, "Shortcut" if id is "shortcuts"
