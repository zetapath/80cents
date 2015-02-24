"use strict"

__.const = {}

Atoms.$ ->
  __.page = Atoms.$("body").attr "data-page"
  unless __.session
    new Atoms.Organism.Session()
    Atoms.$("[data-action=session]").on "click", (event) -> __.Dialog.Session.login()

  __.el =
    document  : $ document
    header    : $ "header"
    slideshow : $ "article.slideshow"

  # -- Active navigation header element
  if __.page in ["collection", "page"]
    Atoms.$("header a[href='#{window.location.pathname}']").addClass "active"

  # -- Detect scroll

  Atoms.$(document).on "scroll", (event) ->
    percent = (__.el.document.scrollTop() * 100) / __.el.slideshow.height()
    if percent > 25
      __.el.header.addClass "scroll"
      __.el.slideshow.addClass "scroll"
    else
      __.el.header.removeClass "scroll"
      __.el.slideshow.removeClass "scroll"
