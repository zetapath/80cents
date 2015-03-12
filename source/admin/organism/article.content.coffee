"use strict"

Atoms.Organism.Header.available.push "Atom.Link"

class Atoms.Organism.Content extends Atoms.Organism.Article

  @url : "/assets/core/scaffold/admin/organism/article.content.json"

  constructor: ->
    super
    do @render
    do @hideHeaderButtons
    @header.navigation.el.children().hide()

    url = Atoms.Url.path().split("/")
    if url.length is 3 then @context url[2] else @[url[2]] url[3]

    # -- Bindings
    for formgroup in ["order", "customer", "collection", "product", "page", "settings", "payments"]
      @section[formgroup].bind "progress", @progress

  # -- Children Bubble Events --------------------------------------------------
  onButton: (event, atom) -> do @[atom.attributes.callback]

  onOrder: (atom) => @order atom.entity.id

  onCustomer: (atom) => @customer atom.entity.id

  onCollection: (atom) -> @collection atom.entity.id

  onProduct: (atom) => @product atom.entity.id

  onPage: (atom) => @page atom.entity.id

  onDiscount: (atom) => @discount atom.entity.id

  onFilterChange: (event, form) ->
    filter = form.value()

    @section.products.select (item) ->
      valid = true
      if filter.title and item.title?.toLowerCase().indexOf(filter.title.toLowerCase()) is -1
        valid = false
      if filter.description and item.description?.toLowerCase().indexOf(filter.description.toLowerCase()) is -1
        valid = false
      if filter.min and parseInt(item.price) < parseInt(filter.min)
        valid = false
      if filter.max and parseInt(item.price) > parseInt(filter.max)
        valid = false
      return item if valid

   onFilterOrderChange: (event, form) ->
    filter = form.value()
    @section.orders.select (item) ->
      valid = true
      if filter.id and item.id?.toLowerCase().indexOf(filter.id.toLowerCase()) is -1
        valid = false
      if filter.state and item.state.toString() isnt filter.state.toString()
        valid = false
      if filter.tracking and item.tracking_number?.toLowerCase().indexOf(filter.tracking.toLowerCase()) is -1
        valid = false
      if filter.min and parseInt(item.amount) < parseInt(filter.min)
        valid = false
      if filter.max and parseInt(item.amount) > parseInt(filter.max)
        valid = false
      return item if valid

  # -- Private Events ----------------------------------------------------------
  context: (id) =>
    @header.progress.value 0
    @header.ok.el.removeClass "active"
    @header.ok.el.hide()

    @header.title.refresh text: id, href: "/admin/#{id}"
    @header.subtitle.refresh value: null
    for button in @header.navigation.children
      do button.el[if button.attributes.context is id then "show" else "hide"]
    @header.progress.value 20
    @section[id].el.show().siblings().hide()
    @fetch id, "Collection" if id is "collections"
    @fetch id, "Customer" if id is "customers"
    @fetch id, "Discount" if id is "discounts"
    @fetch id, "Order" if id is "orders"
    @fetch id, "Page" if id is "pages"
    @fetch id, "Product" if id is "products"
    # -- Settings
    @section.settings.fetch() if id is "settings"
    @section.payments.fetch() if id is "payments"
    # -- Filters
    @section["#{id}_filter"]?.el.show()

  fetch: (id, entity) ->
    __.Entity[entity].destroyAll()
    __.proxy("GET", entity.toLowerCase(), null, true).then (error, response) =>
      @header.progress.value 80
      __.Entity[entity].createOrUpdate item for item in response[id]
      @header.progress.value 100
      setTimeout (=> @header.progress.refresh value: 0), 500

  collection: (id) -> @showGroupForm id, "Collections", "collection"

  customer: (id) -> @showGroupForm id, "Customers", "customer"

  order: (id) -> @showGroupForm id, "Orders", "order"

  page: (id) -> @showGroupForm id, "Pages", "page"

  discount: (id) -> @showGroupForm id, "Discounts", "discount"

  product: (id) -> @showGroupForm id, "Products", "product"

  showGroupForm: (id, title, form) ->
    @header.title.refresh text: title, href: "/admin/#{title.toLowerCase()}"
    @header.subtitle.refresh value: "/ #{if id then 'edit' else 'new'}"
    do @hideHeaderButtons
    @section.el.children().hide()
    @section[form].fetch id

  hideHeaderButtons: ->
    @header.navigation.el.children().hide()

  progress: (value) =>
    @header.progress.value value
    if value is 100
      @header.ok.el.addClass "active"
      setTimeout =>
        @header.progress.refresh value: 0
        @header.ok.el.removeClass "active"
      , 500
