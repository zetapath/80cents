"use strict"

jwt = require "jwt-simple"

module.exports = (id) -> jwt.encode id: id, ZEN.token, ZEN.encoding
