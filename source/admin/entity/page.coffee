"use strict"

class __.Entity.Page extends Atoms.Class.Entity

  @fields "id", "title", "content", "search", "header", "visibility",
          "updated_at", "created_at"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes

  # -- Instance Methods
  parse: ->
    text        : @title
    description : @content
    info        : moment(@updated_at).fromNow()
