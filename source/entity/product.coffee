"use strict"

class __.Entity.Product extends Atoms.Class.Entity

  @fields "id", "title", "description", "type", "vendor", "price", "compare_at_price",
          "stock", "barcode", "tax", "requires_shipping", "weight", "sizes",
          "colors", "materials", "default_image", "images", "collection_id",
          "tags", "search", "visibilty",
          "page_title", "meta_description", "url_handle",
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
    image       : @default_image or "http://"
    text        : @title
    description : @price
    info        : moment(@created_at).fromNow()
