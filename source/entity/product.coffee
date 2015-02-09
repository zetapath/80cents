"use strict"

class __.Entity.Product extends Atoms.Class.Entity

  @fields "id", "title", "description"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes
