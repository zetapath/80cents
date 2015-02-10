"use strict"

class __.Entity.Collection extends Atoms.Class.Entity

  @fields "id", "title", "description", "image", "search", "updated_at", "created_at"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes

  # -- Instance Methods
  parse: ->
    style       : "thumb #{unless @visibility then 'hidden'}"
    image       : @image or "http://"
    text        : @title
    description : @price
    info        : moment(@created_at).fromNow()
