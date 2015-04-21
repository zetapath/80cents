"use strict"

class __.Entity.Review extends Atoms.Class.Entity

  @fields "id", "user", "product", "title", "description", "rating",
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
    image       : "#{__.host}uploads/#{@user.avatar}"
    text        : @title
    description : @description
    info        : moment(@created_at).fromNow()
