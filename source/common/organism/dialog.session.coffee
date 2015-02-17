"use strict"

class Atoms.Organism.Session extends Atoms.Organism.Dialog

  @url: "/assets/scaffold/common/organism/dialog.session.json"

  render: ->
    super
    @admin_mode = (Atoms.Url.path() is "/admin")
    if @admin_mode
      @header.navigation.el.hide()
    else

  # -- Instance Methods --------------------------------------------------------
  login: ->
    @_context active = "login", disable = "signup"
    do @show

  signup: ->
    @_context active = "signup", disable = "login"
    do @show

  # -- Children Bubble Events --------------------------------------------------
  onFormChange: (event, form) ->
    @section.error.el.hide()
    required = ["mail", "password"]
    valid = true
    valid = false for key, value of form.value() when key in required and value is ""
    @_footerActive valid

  onSubmit: (event, button) ->
    do @_disableForm
    api = button.attributes.api
    __.proxy("POST", api, @section.form.value()).then (error, response) =>
      do @_enableForm
      if response?.id?
        if @admin_mode
          window.location = "/admin/dashboard"
        else
          window.location.reload()
      else
        @section.error.el.html(error.message).show()

  onClose: ->
    do @hide
    false

  # -- Private -----------------------------------------------------------------
  _context: (active, disable) ->
    @section.form.clean()
    @section.error.el.hide()
    @el.find(".#{disable}-context").hide()
    @el.find(".#{active}-context").show()
    @_footerActive false
    @footer.navigation.submit.refresh api: active, text: active
    setTimeout =>
      @section.form.el.children().first().focus()
    , 350

  _disableForm: ->
    @section.form.el.children().attr "disabled", true

  _enableForm: ->
    @section.form.el.children().removeAttr("disabled").removeClass "loading"

  _footerActive: (value) ->
    if value
      @footer.el.removeClass "disabled"
      @footer.navigation.el.children().removeAttr "disabled"
    else
      @footer.el.addClass "disabled"
      @footer.navigation.el.children().attr "disabled", true
