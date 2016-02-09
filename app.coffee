###
Super simple express app that serves a couple small purposes:
- Collect and serve all static files from public folders
- Browserify any coffee files from the ads folder
###

express    = require('express')
exphbs     = require('express-handlebars')
browserify = require('browserify-middleware')
_ = require 'lodash'
config = require './config.coffee'

app = express()

app.listen(config.APP_PORT)
console.log "app listening on port #{config.APP_PORT}"

# Collect command line arguments
argv = if process.env.npm_config_argv then JSON.parse(process.env.npm_config_argv).original else process.argv[2..]

if '--open' in (argv || [])
  console.log 'opening ad listing'
  require('openurl').open("http://localhost:#{config.APP_PORT}/#{config.AD_DIRNAME}")
else
  console.log 'quiet mode, not opening ad listing'

# App config
app.engine('.hbs', exphbs({defaultLayout: false}))
app.set('view engine', '.hbs')

# Set the url root for testing.. since static files aren't uploaded it just uses
# express.static
process.env['STATIC_URL'] = "http://localhost:#{config.APP_PORT}"

app.use (req, res, next) ->
  # Map static url to whatever host served the content
  process.env['STATIC_URL'] = "http://#{req.hostname}:#{config.APP_PORT}"
  next()

getAds = (callback) ->
  ###
  Function get a list of ad units
  ###
  
  fs = require 'fs'
  path = require 'path'
  
  fs.readdir config.AD_ROOT, callback
  
serveIndex = require('serve-index')

app.use '/', (req, res, next) ->
  ###
  General middleware that passes off to other functions
  ###
  
  if req.path.match(config.AD_PATH_REGEX)
    return renderAd(req,res,next)
      
  return next()

app.use (req, res, next) ->
  ###
  Map some extensions to other extensions for browserify.. so if you hit
  /ads/intel/main.js.. it maps to /ads/intel/main.coffee
  ###
  
  _ = require 'lodash'
  fs = require 'fs'
  path = require 'path'
  replaceExt = require 'replace-ext'

  map =
    '.coffee': '.js'
    '.sass': '.css'
  
  if (ext = path.extname(req.path)) in _.values map
    # Check if it's an extension that should be mapped
    
    # Check if it's in the right dir
    newExt = _.invert(map)[ext]
    file = path.join __dirname, replaceExt req.path, newExt
    
    # Check if file exists
    if file.indexOf(config.AD_ROOT) != 0
      return next()
    else
      fs.exists file, (exists) ->
        if exists?
          req.url = replaceExt req.url, newExt
          
          # Make sure any public files are exposed.. this is done on the fly so
          # new directories will work without having to restart the node app
          exposeAdStatic(req.url.split('/').slice(-2)[0])
          
        return next()
  else
    return next()

# Browserify middleware
app.use browserify "./",
  grep: /\.coffee$/
  extensions: ['.coffee', '.sass', '.scss']
  transform: ['sassify']
  
# Expose files in "public" dir for ads, i.e. /ads/intel/public
exposeAdStatic = (adName) =>
  @staticified ||= []

  if adName not in @staticified
    path  = require 'path'
    staticPath = path.normalize(path.join __dirname, config.AD_DIRNAME, adName, 'public')
    staticUrl = '/'+ [config.AD_DIRNAME, adName].join('/')
    app.use staticUrl, express.static(staticPath)
    @staticified.push(adName)

renderAd = (req, res, next) ->
  # Handler to render ad HTML file.. will look something like <html> ...<script
  # src="ad.js"></script>..</html>.. Useful for development of a new unit..
  
  adName = req.path.match(config.AD_PATH_REGEX)[1]
  
  getAds (err, ads) ->
    if err? then return next()

    if adName not in ads
      # Ad not found
      return next()
      
    exposeAdStatic(adName)
      
    # Render now
    projectScriptUrl = "/#{config.AD_DIRNAME}/#{adName}/main.js"
    data = title: adName, script_url: projectScriptUrl
    
    if req.query? and _.has(req.query, 'embedded')
      data.embedded = true
      data.embedded_script = "
      javascript:\"
        <html>
          <body style='background:transparent'>
            <script>
              top.window.storyplate = { };
              top.window.storyplate.test_ad = 'http://' +
              top.window.location.host +
              top.window.location.pathname +
              '/main.js';
              (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
              new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
              j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
              '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
              })(window,document,'script','dataLayer','GTM-TVTWHN');
            </script>
          </body>
        </html>\"
      "
    
    res.render 'project', data

# Global public files
config.PUBLIC_FILES.forEach (file) ->
  path = require 'path'
  app.use "/#{path.basename(file)}", express.static(file)
  
config.PUBLIC_FOLDERS.forEach(express.static.bind(express))

# Index listing
app.use '/', serveIndex './',
  icons: true
  filter: (filename, index, files, dir) ->
    path = require 'path'
    
    left = path.normalize(dir + '/')
    right = path.normalize(__dirname) + '/'
    
    if left is right  and filename != config.AD_DIRNAME
      return false
    else
    return true
