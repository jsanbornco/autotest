require 'bosonic/lib/importNode'
loadHtmlImports = require './load-html-imports.coffee'
state = require './state'

getDFPContainer = (elem) ->
  ###
  Get the parent div-gpt-ad- container for a div.. Google will next the original
  script within an iframe, and then a couple divs.. so we want to to be able to
  find the outermost div..
  ###

  while elem and elem != document
    elem = elem.parentNode

    if elem?.getAttribute?('id')?.indexOf?('div-gpt-ad') != -1
      break

  return elem

render = (opts={}, callback) ->
  ###
  Import scripts, styles and HTML into the parent page so it is "native".
  Data should look like
  {
    template: compiled template function,
    style: optional styles
    script: function to run when the the template gets injected
  }
  ###

  _ = require 'lodash'

  if state.settings.embedded is true
    rootWin = parent
  else
    rootWin = top

  rootDoc = rootWin.document

  opts = _.defaults(_.clone(opts))

  # Convert cb function into a string
  opts.script = if opts.script? then '(' + opts.script.toString() + ')();' else '';

  # Calculate size for the hero image
  if state.settings.embedded is true
    hero_image_args = "?w=#{rootWin.innerWidth}&h=#{rootWin.innerHeight}&fit=crop"
  else if rootWin.innerWidth > 768
    hero_image_args = "?w=#{rootWin.innerWidth}"
  else
    hero_image_args = "?w=#{rootWin.innerWidth * 1.5}"

  styleData = _.extend {}, opts.data, STATIC_URL: process.env.STATIC_URL, HERO_IMAGE_ARGS: hero_image_args

  opts.style = _.template(opts.style)(styleData)

  # Set up the data that will be forwarded to the template
  data = _.extend {}, opts.data, _.omit(opts, 'template')

  # data.STATIC_URL + ad name.. i.e. localhost:3000/ads/intel
  data.STATIC_URL = [process.env.STATIC_URL,process.env.AD_DIRNAME,opts.name]
                       .join('/')
                       .replace(/\/\//g,'/')
                       .replace(':/','://')

  data.HERO_IMAGE_ARGS = hero_image_args

  # Pull in options from the state
  data = _.extend data, _.pick(state.settings, 'show_ad_text')

  output = new Buffer(opts.template(data)).toString('base64')

  # Now append to parent document

  # First we need it to append the HTML to a link "import" element, and that
  # will automatically import the CSS and JS.. It's basically a more standards
  # way of doing this
  # https://github.com/britco/BritCo-Wordpress/blob/5160c34bf37e1fdf78f04d6937d875886825adbd/web/test_ad.html#L50-L92
  link = document.createElement('link')
  link.setAttribute 'rel', 'import'
  # link.setAttribute 'href', "data:text/html;charset=UTF-8,#{output}"
  # Browsers that use the polyfill seem to have problems if the text is not b64 encoded..
  link.setAttribute 'href', "data:text/html;charset=UTF-8;base64,#{output}"

  if (top.ga)
    top.ga('send', {
      'hitType': 'event'
      'eventCategory': 'storyplate'
      'eventAction': 'impression'
      'eventLabel': data.AD_ID
      'dimension4': data.AD_ID
      'nonInteraction': 1
    })


  # Once the imports have been added, append the HTML to the DOM
  link.onload = ->
    primary_div = link.import.querySelector('body > div:first-of-type')


    if primary_div?
      # Set embedded class if needed
      if state.settings.embedded is true and primary_div.classList?
        primary_div.classList.add('storyplate-embedded')

      clone = rootDoc.importNode(primary_div, true)

      dfpContainer = getDFPContainer(frameElement)
      dfpContainer.parentNode.insertBefore(clone, dfpContainer)

      callback(null, clone, data)

  rootDoc.getElementsByTagName('head')[0].appendChild(link)

# Exported function will first load HTML Imports polyfill if needed, and then
# passthrough to the render function
module.exports = (args...) -> loadHtmlImports -> render(args...)
