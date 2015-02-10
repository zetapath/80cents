"use strict"

class Atoms.Organism.AdminArticle extends Atoms.Organism.Article

  @url : "/assets/scaffold/admin.article.json"

  constructor: ->
    super
    do @render

    id = Atoms.Url.path().split("/").slice(-1)[0]
    @context id

  # -- Children Bubble Events --------------------------------------------------
  onCollection: (atom) ->
    console.log atom.entity

  onProduct: (atom) ->
    console.log atom.entity

  # -- Private Events ----------------------------------------------------------
  context: (id) =>
    @header.progress.value 0
    @header.title.el.html id
    for button in @header.navigation.children
      do button.el[if button.attributes.context is id then "show" else "hide"]
    @header.progress.value 20
    @section[id].el.show().siblings().hide()
    @_fetchContext id, "Collection" if id is "collections"
    @_fetchContext id, "Product" if id is "products"

  _fetchContext: (id, entity) ->
    __.Entity[entity].destroyAll()
    __.proxy("GET", entity.toLowerCase(), null, true).then (error, response) =>
      @header.progress.value 80
      __.Entity[entity].createOrUpdate item for item in response[id]
      @header.progress.value 100
      setTimeout (=> @header.progress.refresh value: 0), 500
