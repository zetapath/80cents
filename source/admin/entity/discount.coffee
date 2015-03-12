"use strict"

class __.Entity.Discount extends Atoms.Class.Entity

  @fields "id", "owner", "code", "description", "percent", "amount",
          "active", "collection_id", "product",
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
    text        : @code
    description : @description
    info        : moment(@updated_at).fromNow()
