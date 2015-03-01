"use strict"

Hope          = require("zenserver").Hope
Mustache      = require("zenserver").Mustache
nodemailer    = require "nodemailer"
smtpTransport = require 'nodemailer-smtp-transport'
fs            = require "fs"
premailer     = require "premailer-api"
transport     = nodemailer.createTransport smtpTransport
                  host  : global.ZEN.mail.host
                  auth  :
                    user: global.ZEN.mail.user
                    pass: global.ZEN.mail.password

module.exports = (to, subject, file, bindings) ->
  files = {}
  files["mail.#{file}"] = __mustache "mail.#{file}"
  body = Mustache.render __mustache("base.mail"), bindings, files

  premailer.prepare html: body, (error, email) =>
    unless error
      # -- Mail data
      data =
        from    : "#{bindings.settings.name} <#{global.ZEN.mail.user}>"
        to      : to
        subject : subject
        html    : email.html
      # -- Send email
      transport.sendMail data, (error, value) ->
        console.log " *", "[MAIL]", "#{subject} to #{to}"

# -- Private methods -----------------------------------------------------------
__cachedMustache = {}

__mustache = (name) ->
  dir = "#{__dirname}/../www/mustache/"
  if __cachedMustache[name] and (global.ZEN.mustache?.cache or not global.ZEN.mustache)
    __cachedMustache[name]
  else if fs.existsSync file = "#{dir}#{name}.mustache"
    __cachedMustache[name] = fs.readFileSync file, "utf8"
  else
    __cachedMustache[name] = ""
