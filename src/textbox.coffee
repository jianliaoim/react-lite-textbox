
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
    onKeyDown: React.PropTypes.func
    placeholder: React.PropTypes.string
    selectionStart: React.PropTypes.number
    selectionEnd: React.PropTypes.number

  getDefaultProps: ->
    minHeight: 120
    maxHeight: 200
    specials: ['@']
    placeholder: ''
    onKeyDown: ->

  getInitialState: ->
    contentHeight: 20

  componentDidMount: ->
    @boxEl = @refs.box.getDOMNode()
    @preEl = @refs.pre.getDOMNode()
    @mirrorStyles()

  componentDidUpdate: ->
    @mirrorStyles()
    @checkSelectionPositions()

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

    top: Math.round rect.top
    bottom: Math.round rect.bottom
    left: Math.round rect.left
    right: Math.round rect.right

  getSpecial: ->
    target = @preEl.querySelector('.textbox-special')
    if target?
      rect = target.getBoundingClientRect()

      top: Math.round rect.top
      bottom: Math.round rect.bottom
      left: Math.round rect.left
      right: Math.round rect.right
    else
      null

  getQuery: ->
    pick.getQuery @boxEl.value[...@boxEl.selectionStart], @props.specials

  getTrigger: ->
    pick.getTrigger @boxEl.value[...@boxEl.selectionStart], @props.specials

  checkSelectionPositions: ->
    if @boxEl.selectionStart isnt @props.selectionStart
       @boxEl.selectionStart = @props.selectionStart
    if @boxEl.selectionEnd isnt @props.selectionEnd
       @boxEl.selectionEnd = @props.selectionEnd

  # events

  onChange: (event) ->
    specialArea = @getSpecial()
    triggerChar = @getTrigger()
    caretArea = @getCaret()
    # for a instant, special can be null with trigger defined
    # return caret position as a temporary fix
    if triggerChar? and (not specialArea?)
      specialArea = caretArea
    @props.onChange
      value: event.target.value
      caret: @getCaret()
      special: specialArea
      query: @getQuery()
      trigger: triggerChar
      selectionStart: @boxEl.selectionStart
      selectionEnd: @boxEl.selectionEnd
    if event.target.value.length < 4
      # quickly shrink in height after removing content
      # TODO, need to exact height here
      @setState contentHeight: 0 # to trigger min-height
    else
      @setState contentHeight: @boxEl.scrollHeight

  onKeyUp: (event) ->
    @onChange event

  onKeyDown: (event) ->
    @props.onKeyDown event

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
        onClick: @onClick, onKeyUp: @onKeyUp, onKeyDown: @onKeyDown
        placeholder: @props.placeholder
