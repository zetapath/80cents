"use strict"

class __.Entity.Collection extends Atoms.Class.Entity

  @fields "id", "title", "description", "images",
          "page_title", "meta_description", "url_handle", "visibility",
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
    style       : "thumb #{unless @visibility then 'hidden'}"
    image       : "#{__.host}assets/uploads/#{@images[0]}"
    text        : @title
    description : @price
    info        : moment(@created_at).fromNow()
