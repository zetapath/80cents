"use strict"

__.const = {}

Atoms.$ ->
  # -- Define global variables
  __.page = Atoms.$("body").attr "data-page"
  __.el =
    document  : $ document
    header    : $ "header"
    slideshow : $ "article.slideshow"

  # -- Detect session
  unless __.session
    new Atoms.Organism.Session()
    Atoms.$("[data-action=session]").on "click", (event) -> __.Dialog.Session.login()

  # -- Active navigation header element
  if __.page in ["collection", "page"]
    Atoms.$("header a[href='#{window.location.pathname}']").addClass "active"

  # -- Button events
  Atoms.$("[data-action=menu]").on "click", (event) ->
    __.el.header.children("[data-action=menu]").toggleClass "active"
    __.el.header.children("[data-shopio=menu]").toggleClass "active"

  # -- Detect scroll
  Atoms.$(document).on "scroll", (event) ->
    percent = (__.el.document.scrollTop() * 100) / __.el.slideshow.height()
    if percent > 25
      __.el.header.addClass "scroll"
      __.el.slideshow.addClass "scroll"
    else
      __.el.header.removeClass "scroll"
      __.el.slideshow.removeClass "scroll"
