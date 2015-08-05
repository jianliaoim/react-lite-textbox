
React = require 'react'
dom = require './dom'
pick = require './pick'

div = React.createFactory 'div'
pre = React.createFactory 'pre'
textarea = React.createFactory 'textarea'

module.exports = React.createClass
  displayName: 'lite-textbox'

  propTypes:
    text: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    minHeight: React.PropTypes.number
    maxHeight: React.PropTypes.number
    specials: React.PropTypes.array

  getDefaultProps: ->
    minHeight: 120
    maxHeight: 200
    specials: ['@', ':']

  getInitialState: ->
    contentHeight: 20

  componentDidMount: ->
    @boxEl = @refs.box.getDOMNode()
    @preEl = @refs.pre.getDOMNode()
    @mirrorStyles()

  componentDidUpdate: ->
    @mirrorStyles()

  # methods

  getBoxStyles: ->
    if @boxEl?
      boxStyles = getComputedStyle @boxEl
      mirrorStyles = {}
      for key, value of boxStyles
        continue if key[0] is '-'
        continue if key.match /^webkit/
        continue if (typeof value) is 'function'
        continue if key.match /^\d+$/
        mirrorStyles[key] = value
      mirrorStyles
    else
      {}

  getHeight: ->

    mirrorHeight = @state.contentHeight
    if @state.contentHeight < @props.minHeight
      mirrorHeight = @props.minHeight
    if @state.contentHeight > @props.maxHeight
      mirrorHeight = @props.maxHeight

    mirrorHeight

  mirrorStyles: ->

    mirrorHeight = @getHeight()

    styles = @getBoxStyles()
    styles.height = "#{mirrorHeight}px"
    styles.zIndex = -1
    for key, value of styles
      @preEl.style[key] = value
    @preEl.scrollTop = @boxEl.scrollTop

  expandText: ->
    if @preEl?
      dom.expand @props.text, @boxEl.selectionStart, @props.specials
    else
      dom.expand @props.text, 0, @props.specials

  getCaret: ->
    rect = @preEl.querySelector('.textbox-caret').getBoundingClientRect()

    top: rect.top
    bottom: rect.bottom
    left: rect.left
    right: rect.right

  getSpecial: ->
    target = @preEl.querySelector('.textbox-special')
    if target?
      rect = target.getBoundingClientRect()

      top: rect.top
      bottom: rect.bottom
      left: rect.left
      right: rect.right
    else
      null

  getQuery: ->
    pick.getQuery @boxEl.value[...@boxEl.selectionStart], @props.specials

  # events

  onChange: (event) ->
    @props.onChange
      value: event.target.value
      caret: @getCaret()
      special: @getSpecial()
      query: @getQuery()
    @setState contentHeight: @boxEl.scrollHeight

  onKeyUp: (event) ->
    @onChange event

  onClick: (event) ->
    @onChange event

  onScroll: ->
    @preEl.scrollTop = @boxEl.scrollTop

  # renderers

  render: ->
    div className: 'lite-textbox',
      pre
        ref: 'pre', className: 'textbox-mirror'
        @expandText()
      textarea
        ref: 'box', value: @props.text, onChange: @onChange
        onScroll: @onScroll, style: {height: @getHeight()}
        onClick: @onClick, onKeyUp: @onKeyUp
