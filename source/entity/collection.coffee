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
