"use strict"

module.exports =

  getTheme: ->
    theme = "/assets/core/80cents.theme"
    if global.ZEN.theme?.folder and global.ZEN.theme?.name
      theme = "#{global.ZEN.theme.folder}/#{global.ZEN.theme.name}"
    theme

  customizeMeta: (settings, values) ->
    meta =
      title       : values?.search?.page_title or settings.title
      description : values?.search?.meta_description or settings.description
