"use strict"

class __.Entity.Customer extends Atoms.Class.Entity

  @fields "id", "mail", "first_name", "last_name", "avatar", "active",
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
    style       : if @active then "active" else "banned"
    image       : @avatar or "/img/avatar.jpg"
    text        : @name
    description : @mail + (unless @active then " - Banned" else "")
    info        : moment(@created_at).fromNow()
