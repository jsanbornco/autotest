_ = require 'lodash'

class State
  ###
  Return window objects in the tree that have a "storyplate" object, i.e.
  window.object
  ###
  getObjects: ->
    return [] unless window?

    search = [
      window
      window.parent
      window.parent.parent
      window.top
    ]

    objects = _.filter _.map search, (ctx) ->
      return ctx.storyplate
    
    return objects

  constructor: (objects...) ->
    if arguments.length is 0
      objects = @getObjects()
    
    state = _.defaultsDeep.apply this, objects.concat [
      settings:
        embedded: false
        show_ad_text: true
    ]
    
    for k,v of state
      this[k] = v
    
    return this

module.exports = new State()
