"use strict"

class Atoms.Atom.Wysihtml5 extends Atoms.Atom.Textarea

  @template = """
    <nav id="wysihtml5-toolbar-{{id}}">
      <a data-wysihtml5-command="bold"></a>
      <a data-wysihtml5-command="italic"></a>
      <a data-wysihtml5-command="insertUnorderedList"></a>
      <a data-wysihtml5-command="insertOrderedList"></a>
      <a data-wysihtml5-command="createLink"></a>
      <div data-wysihtml5-dialog="createLink" style="display: none;">
        <input data-wysihtml5-dialog-field="href" value="http://" class="text">
        <a data-wysihtml5-dialog-action="save">OK</a><a data-wysihtml5-dialog-action="cancel">Cancel</a>
      </div>
      <a data-wysihtml5-command="insertImage"></a>
      <div data-wysihtml5-dialog="insertImage" style="display: none;">
        <input data-wysihtml5-dialog-field="src" value="http://">
        <a data-wysihtml5-dialog-action="save">OK</a><a data-wysihtml5-dialog-action="cancel">Cancel</a>
      </div>
      <!--
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h1"></a>
      <a data-wysihtml5-command="formatBlock" data-wysihtml5-command-value="h2"></a>
      -->
    </nav>
    <textarea id="wysihtml5-{{id}}" placeholder="{{placeholder}}">{{value}}</textarea>"""

  constructor: ->
    super
    id = @attributes.id
    @editor = new wysihtml5.Editor "wysihtml5-#{id}", toolbar: "wysihtml5-toolbar-#{id}"
    @textarea = @el.siblings("textarea").first()

  value: (data) ->
    if data?
      @editor.setValue data, false
    else
      @textarea.val()

