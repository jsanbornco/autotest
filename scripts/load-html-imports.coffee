###
Loads HTML Imports polyfill if needed
###

supportsImports = `'import' in frameElement.contentDocument.createElement('link')`
didLoadImportsPolyfill = false
loadImportsPolyfillCallbacks = []
script = null
[topWin,topDoc] = [top.window, top.document]

if not supportsImports
  script = topDoc.createElement('script')
  script.async = true
  script.src = process.env.STATIC_URL + '/HTMLImports.min.js'
  topDoc.querySelector('body').appendChild(script)
  
  # Once the script tag loads, set global variable for status and run any
  # pending callbacks
  script.addEventListener 'load', ->
    didLoadImportsPolyfill = true
    
    for callback in loadImportsPolyfillCallbacks
      callback()
  
module.exports = (callback) ->
  if supportsImports
    # Already supports, passthrough
    return callback()
  else
    if didLoadImportsPolyfill
      # Already loaded polyfill, nothing to do here
      return callback()
    else
      loadImportsPolyfillCallbacks.push callback
