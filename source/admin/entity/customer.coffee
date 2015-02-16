"use strict"

class __.Entity.Customer extends Atoms.Class.Entity

  @fields "id", "mail", "name", "avatar", "updated_at", "created_at"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes

  # -- Instance Methods
  parse: ->
    image       : @avatar or "/assets/img/avatar_default.jpg"
    text        : @name
    description : @mail
    info        : moment(@created_at).fromNow()
