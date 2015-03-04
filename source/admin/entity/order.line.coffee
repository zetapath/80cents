"use strict"

class __.Entity.OrderLine extends Atoms.Class.Entity

  @fields "id", "order", "product", "amount", "quantity", "state", "created_at"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes

  # -- Instance Methods
  parse: ->
    image       : "#{__.host}uploads/#{@product.default_image}"
    text        : @product.title
    description : @amount
    info        : "#{@quantity} units"
