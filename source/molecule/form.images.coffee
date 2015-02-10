"use strict"

Atoms.Molecule.Form.available.push "Atom.Progress"
Atoms.Molecule.Form.available.push "Atom.Figure"
Atoms.Molecule.Form.available.push "Molecule.Div"

class Atoms.Molecule.Images extends Atoms.Molecule.Form

  @events: ["add", "destroy"]

  @default:
    children: [
      "Atom.Input": id: "file", type: "file", events: ["change"], callbacks: ["onFileChange"]
    ,
      "Molecule.Div": id: "images"
    ,
      "Atom.Figure": id: "add", style: "add", events: ["touch"], callbacks: ["onAdd"]
    ,
      "Atom.Progress": id: "progress", style : "tiny", value: 0
    ]

  constructor: ->
    super
    @attributes.files = []

  value: (@entity) =>
    if @entity?
      @attributes.files = []
      @images.destroyChildren()
      @_addImage "#{__.host}assets/img/product/#{img}" for img in (@entity.images)
    else
      @attributes.files

  # Bubble Children Events
  onAdd: (event) ->
    @file.el.trigger "click"
    false

  onDestroy: (event, atom) =>
    atom.destroy()
    @attributes.files.splice @attributes.files.indexOf(atom.attributes.file), 1
    false

  onFileChange: (event) ->
    event.stopPropagation()
    event.preventDefault()
    file_url = event.target.files[0]
    if file_url.type.match /image.*/
      @progress.value 0
      @progress.el.show()
      callbacks =
        progress: (progress) =>
          @progress.value progress.position / progress.total * 100
        error: =>
          alert "upload error!!"
        abort: =>
          alert "upload aborted"

      image = @_addImage "http://"
      parameters =
        file: file_url
        id  : @entity.id

      _connectMultipart("POST", "/api/product/image", parameters, callbacks).then (error, file) =>
        @progress.el.hide()
        @progress.value 0
        unless error
          image.refresh
            url   : "#{__.host}assets/img/product/#{file.name}"
            file  : file.name
          @attributes.files.push file.name
    false

  _addImage: (url) ->
    @attributes.files.push url
    image = @images.appendChild "Atom.Figure", url: url, events: ["touch"], callbacks: ["onDestroy"]
    image

_connectMultipart = (type, url, parameters, callbacks = {}) ->
  promise = new Hope.Promise()
  formData = new FormData()
  formData.append(name, value) for name, value of parameters
  xhr = new XMLHttpRequest()
  xhr.responseType = "json"
  onLoadComplete = -> promise.done null, @response
  xhr.addEventListener "load", onLoadComplete, false

  if callbacks.progress then xhr.upload.addEventListener "progress", callbacks.progress, false
  if callbacks.error    then xhr.addEventListener "error", callbacks.error, false
  if callbacks.abort    then xhr.addEventListener "abort", callbacks.abort, false

  xhr.open "POST", url
  # xhr.setRequestHeader "Authorization", "bearer #{Appnima.token}"
  xhr.send formData
  promise
