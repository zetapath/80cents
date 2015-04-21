"use strict"

class __.Entity.Review extends Atoms.Class.Entity

  @fields "id", "user", "product", "title", "description", "rating",
          "updated_at", "created_at"

  # -- Instance Methods
  parse: ->
    image       : "#{__.host}uploads/#{@user.avatar}"
    user        : "#{@user.first_name} #{@user.last_name}".trim()
    title       : @title
    description : @description
    rating      : @rating
    when        : moment(@created_at).fromNow()
