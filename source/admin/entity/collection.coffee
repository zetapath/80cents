"use strict"

class __.Entity.Collection extends Atoms.Class.Entity

  @fields "id", "title", "description", "images", "search", "visibility",
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
    style       : "thumb #{'offline' unless @visibility}"
    image       : "#{__.host}uploads/#{@images[0]}"
    text        : @title
    description : moment(@created_at).fromNow()
