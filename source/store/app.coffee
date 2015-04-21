"use strict"

__.const = {}

Atoms.$ ->
  # -- Define global variables
  __.page = Atoms.$("body").attr "data-page"
  __.mod =
    document  : $ document
    header    : $ "header"
    slideshow : $ "article.slideshow"
    height    : window.innerHeight or document.documentElement.offsetHeight
    items     : (el: $(el), px: el.offsetTop for el in $ "[data-shopio-collection], [data-shopio-product]")
    reviews   : $("[data-shopio-reviews]").first()
    scroll    : (event) ->
      px = __.mod.document.scrollTop()
      percent = (__.mod.document.scrollTop() * 100) / __.mod.slideshow.height()
      # -- Header & Slideshow
      if percent > 25
        __.mod.header.addClass "scroll"
        __.mod.slideshow.addClass "scroll"
      else
        __.mod.header.removeClass "scroll"
        __.mod.slideshow.removeClass "scroll"
      # -- Items
      px += (__.mod.height / 1.25)
      item.el.addClass "active" for item in __.mod.items when  px >= item.px
      # -- Reviews
      px += (__.mod.height / 2.5)
      if px >= __.mod.reviews[0].offsetTop and not __.mod.reviews.hasClass "active"
        __.mod.reviews.addClass "active"
        new Atoms.Molecule.Reviews product: __.mod.reviews.attr "data-shopio-reviews"


  # -- Detect session
  unless __.session
    new Atoms.Organism.Session()
    Atoms.$("[data-action=session]").on "click", (event) -> __.Dialog.Session.login()

  # -- Active navigation header element
  if __.page in ["collection", "page"]
    Atoms.$("header a[href='#{window.location.pathname}']").addClass "active"

  # -- Button events
  Atoms.$("[data-action=menu]").on "click", (event) ->
    __.mod.header.children("[data-action=menu]").toggleClass "active"
    __.mod.header.children("[data-shopio=menu]").toggleClass "active"

  # -- Detect scroll
  do __.mod.scroll
  Atoms.$(document).on "scroll", __.mod.scroll
