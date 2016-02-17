gulp = require 'gulp'
gutil = require 'gulp-util'

# Change any static files to point to Cloudfront
process.env['STATIC_URL'] = require('../config').STATIC_URL

collectPublic = ->
  # Returns vinyl-fs objects for each public file

  glob = require 'glob'
  fs = require 'vinyl-fs'
  es = require 'event-stream'
  path = require 'path'
  config = require '../config'

  streams = []

  streams.push fs.src local("#{config.AD_DIRNAME}/*/public/**/*"), base: local()

  config.PUBLIC_FOLDERS.forEach (folder) ->
    streams.push fs.src local("#{folder}/**/*"), base: local(folder)

  config.PUBLIC_FILES.forEach (file) ->
    path = require 'path'
    streams.push fs.src local(file), base: path.dirname(local(file))

  return es.merge(streams)

collectBrowserifyBundles = ->
  # Make browserify bundles for each ad's main js file

  es = require 'event-stream'
  fs = require 'vinyl-fs'
  buffer = require 'vinyl-buffer'

  fs.src local("ads/*/main.coffee")
  .pipe es.map (file, cb) ->
    browserify = require 'browserify'
    source = require 'vinyl-source-stream'
    replaceExt = require 'replace-ext'

    bundler = browserify
      entries: file.path
      basedir: __dirname
      extensions: ['.coffee', '.sass', '.tpl']
      debug: true

    bundler.plugin 'minifyify', map: false

    bundler.transform 'sassify'

    # Minify CSS.. @TODO: this shouldn't be as hacky.. less using vm's and stuff
    bundler.transform (file) ->
      through = require 'through'
      path = require 'path'

      if path.extname(file) != '.sass'
        return through()

      CleanCSS = require 'clean-css'

      content = ''
      through (chunk, enc, callback) ->
        content += chunk
      , (cb) ->
        vm = require 'vm'
        sandbox = {module: {}}
        vm.createContext(sandbox)
        css = vm.runInContext content, sandbox
        compressed_css = new CleanCSS().minify(css).styles
        content = "module.exports = " + JSON.stringify(compressed_css) + ";"
        @queue content
        @queue(null)

    bundle = bundler.bundle()
    .pipe source replaceExt file.path, '.js'
    .pipe buffer()

    bundle.on 'data', cb.bind @, null

collect = (cb) ->
  # Return all files that should be public / uploaded
  es = require 'event-stream'

  es.concat(
    collectPublic(),
    collectBrowserifyBundles()
  )

gzip = (cb) ->
  # Compress vinyl-fs objects
  es = require 'event-stream'
  mime = require 'mime'

  compressContentTypes = ['application/javascript']

  return es.map (file, cb) ->
    if file.isDirectory() or file.isNull()
      cb null, file
    else
      contentType = mime.lookup(file.path)

      if contentType in compressContentTypes
        zlib = require 'zlib'

        zlib.gzip file.contents, (err, compressedContents) ->
          if err? then return cb(null, file)
          gutil.log "gzipped #{file.path}"

          file.contents = compressedContents
          file.contentEncoding = 'gzip'
          cb(null, file)
      else
        cb null, file

gulp.task 'upload', (done) ->
  # Upload to S3

  _ = require 'lodash'
  path = require 'path'
  mime = require 'mime'
  AWS = require 'aws-sdk'
  fs = require('vinyl-fs');
  source = require('vinyl-source-stream');
  config = require '../config'

  startedAllUploads = false
  #
  # if (!rfs.existsSync('./build'))
  #   rfs.mkdirSync('./build')

  collect()
  .pipe gzip()
  .on 'data', (file) ->
    # Skip directories
    if file.isDirectory() then return

    key = path.relative file.base, file.path

    # Strip out /public/ from folders within /config.AD_DIRNAME/
    ad_root = local(config.AD_DIRNAME)
    if file.path.indexOf(ad_root) is 0
      key = config.AD_DIRNAME +
               (file.path.substr(ad_root.length)
               .replace new RegExp('\w*/public/'), '/')

    # Remove /tmp/deploy from filename
    key = key.replace(/tmp\/deploy\//, '')

    # If file is empty, or not under this dir, something went wrong
    if file.isNull() or key.indexOf('..') != -1 then return

    # Guess content type and encoding from the file path
    contentType = mime.lookup(file.path)

    if file.contentEncoding?
      contentEncoding = file.contentEncoding
    else
      encodings =
      	'.gz': 'gzip'
      	'.xz': 'xz'

      if _enc = encodings[path.extname(file.path)] then contentEncoding = _enc


    key = key.replace(/ads\/autoad\//, '')
    filename = key.replace(/.*\//, '')


    file.pipe(source(key))
    .pipe(fs.dest('./build/'))

  .on 'end', =>
    @ended = true

  return
