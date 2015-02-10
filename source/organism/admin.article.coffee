"use strict"

Atoms.Organism.Header.available.push "Atom.Link"

class Atoms.Organism.AdminArticle extends Atoms.Organism.Article

  @url : "/assets/scaffold/admin.article.json"

  constructor: ->
    super
    do @render
    do @hideHeaderButtons
    @header.navigation.el.children().hide()

    url = Atoms.Url.path().split("/")
    if url.length is 3 then @context url[2] else @[url[2]] url[3]

    # -- Bindings
    @section.product.bind "progress", (value) =>
      @header.progress.value value
      if value is 100
        setTimeout (=> @header.progress.refresh value: 0), 500
    @section.product.bind "loaded", =>
      @header.progress.value 100
    @section.product.bind "save", =>
      Atoms.Url.path "admin/products"
      @section.products.el.show().siblings().hide()

  # -- Children Bubble Events --------------------------------------------------
  onCollection: (atom) ->
    console.log atom.entity

  onProduct: (atom) =>
    @product atom.entity.id

  # -- Private Events ----------------------------------------------------------
  context: (id) =>
    @header.progress.value 0
    @header.title.refresh text: id, href: "/admin/#{id}"
    @header.subtitle.refresh value: null
    for button in @header.navigation.children
      do button.el[if button.attributes.context is id then "show" else "hide"]
    @header.progress.value 20
    @section[id].el.show().siblings().hide()
    @fetch id, "Collection" if id is "collections"
    @fetch id, "Product" if id is "products"

  fetch: (id, entity) ->
    __.Entity[entity].destroyAll()
    __.proxy("GET", entity.toLowerCase(), null, true).then (error, response) =>
      @header.progress.value 80
      __.Entity[entity].createOrUpdate item for item in response[id]
      @header.progress.value 100
      setTimeout (=> @header.progress.refresh value: 0), 500

  product: (id) ->
    @header.title.refresh text: "Products", href: "/admin/products"
    @header.subtitle.refresh value: "/ Edit"
    do @hideHeaderButtons
    @section.el.children().hide()
    @section.product.fetch id

  hideHeaderButtons: ->
    @header.navigation.el.children().hide()
