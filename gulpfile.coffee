"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
uglify  = require 'gulp-uglify'
gutil   = require 'gulp-util'
stylus  = require 'gulp-stylus'
yml     = require 'gulp-yml'
pkg     = require './package.json'

# -- FILES ---------------------------------------------------------------------
www =
  coffee    : [ 'source/app.coffee'
                'source/app.*.coffee'
                'source/entity/*.coffee'
                'source/atom/*.coffee'
                'source/molecule/*.coffee'
                'source/organism/*.coffee']
  styl      : [ 'bower_components/stylmethods/vendor.styl'
                'source/style/constants.styl'
                # ATOMS
                'source/style/atoms/*.styl'
                'bower_components/atoms-icons/atoms.icons.styl'
                # FLEXO
                'source/style/flexo/flexo.styl'
                'source/style/flexo/flexo.page.styl'
                'source/style/flexo/flexo.page.*.styl']
  yml       : [ 'source/organism/*.yml']

  thirds    :
    js      : [ 'bower_components/jquery/dist/jquery.min.js'
                'bower_components/hope/hope.js'
                'bower_components/atoms/atoms.standalone.js'
                'bower_components/atoms/atoms.app.js'
                'bower_components/moment/min/moment.min.js']

    css     : [ 'bower_components/flexo/dist/flexo.layout.css'
                'bower_components/atoms/atoms.app.css']
  assets    : 'www/assets/'

banner = [
  '/**'
  ' * <%= pkg.name %> - <%= pkg.description %>'
  ' * @version v<%= pkg.version %>'
  ' * @link    <%= pkg.homepage %>'
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)'
  ' * @license <%= pkg.license %>'
  ' */'
  ''].join('\n')

# -- TASKS ---------------------------------------------------------------------
gulp.task 'thirds', ->
  gulp.src(www.thirds.js)
    .pipe(concat(pkg.name + '.dependencies.js'))
    .pipe(gulp.dest(www.assets + '/js'))
  gulp.src(www.thirds.css)
    .pipe(concat(pkg.name + '.dependencies.css'))
    .pipe(gulp.dest(www.assets + '/css'))

gulp.task 'coffee', ->
  gulp.src(www.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(www.assets + '/js'))

gulp.task 'styl', ->
  gulp.src(www.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(www.assets + '/css'))

gulp.task 'yml', ->
  gulp.src(www.yml)
    .pipe(yml().on('error', gutil.log))
    .pipe(gulp.dest(www.assets + '/scaffold'))

gulp.task 'init', ->
  gulp.run(['thirds', 'coffee', 'styl', 'yml'])

gulp.task 'default', ->
  gulp.watch(www.coffee, ['coffee'])
  gulp.watch(www.styl, ['styl'])
  gulp.watch(www.yml, ['yml'])
