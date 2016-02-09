chai = require 'chai'
sinon = require 'sinon'
_state = require '../scripts/state'

chai.should()

describe 'state', ->
  beforeEach ->
    @State = _state.constructor
    
  it 'should pull in simple state', ->
    state = new @State()
    state.settings.show_ad_text.should.equal true

  it 'should merge state with parent', ->
    state = new @State({settings: { show_ad_text: false }})
    state.settings.show_ad_text.should.equal false

  it 'topmost object should take precedence', ->
    state = new @State(settings: id: 1, settings: id: 2)
    state.settings.id.should.equal 1
