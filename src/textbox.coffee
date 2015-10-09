
React = require 'react/addons'
keycode = require 'keycode'
debounce = require 'debounce'
pick = require './pick'
measure = require './measure'

div = React.createFactory 'div'
textarea = React.createFactory 'textarea'

emptyObject = {}

module.exports = React.createClass
  displayName: 'lite-textbox'
  mixins: [React.addons.PureRenderMixin]

  propTypes:
    text: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    selectionStart: React.PropTypes.number.isRequired
    selectionEnd: React.PropTypes.number.isRequired
    paddingTop: React.PropTypes.number.isRequired
    paddnggBottom: React.PropTypes.number.isRequired
    paddingLeft: React.PropTypes.number.isRequired
    paddingRight: React.PropTypes.number.isRequired
    minHeight: React.PropTypes.number
    maxHeight: React.PropTypes.number
    specials: React.PropTypes.array
    onKeyDown: React.PropTypes.func
    placeholder: React.PropTypes.string

  getDefaultProps: ->
    minHeight: 120
    maxHeight: 200
    specials: ['@']
    placeholder: ''
    style:
      fontSize: "14px"
      fontFamily: "Roboto,Helvetica Neue,Hiragino Sans GB,Microsoft Yahei,sans-serif"
      lineHeight: "30px"
    onKeyDown: ->

  getInitialState: ->
    contentHeight: 20
    height: 100
    width: 400

  componentDidMount: ->
    @boxEl = @refs.box.getDOMNode()

  componentDidUpdate: ->

  # methods

  getHeight: ->
    mirrorHeight = @state.contentHeight
    if @state.contentHeight < @props.minHeight
      mirrorHeight = @props.minHeight
    if @state.contentHeight > @props.maxHeight
      mirrorHeight = @props.maxHeight

    mirrorHeight

  getQuery: ->
    pick.getQuery @boxEl.value[...@boxEl.selectionStart], @props.specials

  getTrigger: ->
    pick.getTrigger @boxEl.value[...@boxEl.selectionStart], @props.specials

  checkSelection: ->
    if @boxEl.selectionStart isnt @props.selectionStart
       @boxEl.selectionStart = @props.selectionStart
    if @boxEl.selectionEnd isnt @props.selectionEnd
       @boxEl.selectionEnd = @props.selectionEnd

  # events

  onChange: (event) ->
    triggerChar = @getTrigger()
    @props.onChange
      value: event.target.value
      caret: 'TODO'
      special: 'TODO'
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
    directionKeys = ['up', 'down', 'left', 'right']
    if keycode(event.keyCode) in directionKeys
      @onChange event

  onKeyDown: (event) ->
    @props.onKeyDown event

  onClick: (event) ->
    @onChange event

  onScroll: ->
    if @preEl.scrollTop isnt @boxEl.scrollTop
      @preEl.scrollTop = @boxEl.scrollTop

  # renderers

  render: ->
    textarea
      className: 'lite-textbox',
      ref: 'box', value: @props.text, onChange: @onChange
      onScroll: @onScroll, style: {height: @getHeight()}
      onClick: @onClick, onKeyUp: @onKeyUp, onKeyDown: @onKeyDown
      placeholder: @props.placeholder
