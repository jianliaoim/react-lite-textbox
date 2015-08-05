
React = require 'react'
dom = require './dom'

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
    contentheight: 20

  componentDidMount: ->
    @boxEl = @refs.box.getDOMNode()
    @preEl = @refs.pre.getDOMNode()
    @mirrorStyles()


  componentDidUpdate: ->
    @mirrorStyles()

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

    mirrorHeight = @state.contentheight
    if @state.contentheight < @props.minHeight
      mirrorHeight = @props.minHeight
    if @state.contentheight > @props.maxHeight
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

  onChange: (event) ->
    @props.onChange event.target.value
    @setState contentheight: @boxEl.clientHeight

  onKeyUp: (event) ->
    @onChange event

  onClick: (event) ->
    @onChange event

  onScroll: ->
    @preEl.scrollTop = @boxEl.scrollTop

  expandText: ->
    if @preEl?
      dom.expand @props.text, @boxEl.selectionStart, @props.specials
    else
      dom.expand @props.text, 0, @props.specials

  render: ->
    div className: 'lite-textbox',
      pre
        ref: 'pre', className: 'textbox-mirror'
        @expandText()
      textarea
        ref: 'box', value: @props.text, onChange: @onChange
        onScroll: @onScroll, style: {height: @getHeight()}
        onClick: @onClick, onKeyUp: @onKeyUp
