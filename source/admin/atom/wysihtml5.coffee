"use strict"

class Atoms.Atom.Wysihtml5 extends Atoms.Atom.Textarea

  @template = """
    <nav id="wysihtml5-toolbar-{{id}}">
      <a data-wysihtml5-command="bold" class="bold">b</a>
      <a data-wysihtml5-command="italic" class="italic">i</a>
      <!--
      <a data-wysihtml5-command="createLink">l</a>
      <div data-wysihtml5-dialog="createLink" style="display: none;">
        <label>
          Link:
          <input data-wysihtml5-dialog-field="href" value="http://" class="text">
        </label>
        <a data-wysihtml5-dialog-action="save">OK</a> <a data-wysihtml5-dialog-action="cancel">Cancel</a>
      </div>
      -->
    </nav>
    <textarea id="wysihtml5-{{id}}" placeholder="{{placeholder}}">{{value}}</textarea>"""

  constructor: ->
    super
    id = @attributes.id
    @editor = new wysihtml5.Editor "wysihtml5-#{id}", toolbar: "wysihtml5-toolbar-#{id}"
    @textarea = @el.siblings("textarea").first()

  value: (data) ->
    if data
      @editor.setValue data, false
    else
      @textarea.val()
