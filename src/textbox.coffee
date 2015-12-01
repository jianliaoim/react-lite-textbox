
React = require 'react/addons'
keycode = require 'keycode'
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
    paddingBottom: React.PropTypes.number.isRequired
    paddingLeft: React.PropTypes.number.isRequired
    paddingRight: React.PropTypes.number.isRequired
    borderWidth: React.PropTypes.number
    minHeight: React.PropTypes.number
    maxHeight: React.PropTypes.number
    specials: React.PropTypes.array
    onKeyDown: React.PropTypes.func
    placeholder: React.PropTypes.string

  getDefaultProps: ->
    minHeight: 100
    maxHeight: 400
    specials: ['@']
    placeholder: ''
    borderWidth: 1
    style:
      fontSize: "14px"
      fontFamily: "Roboto,Helvetica Neue,Hiragino Sans GB,Microsoft Yahei,sans-serif"
      lineHeight: 28
    onKeyDown: ->

  getInitialState: ->
    contentHeight: 20
    height: @props.minHeight
    scrollTop: 0

  componentDidMount: ->
    @boxEl = @getDOMNode()

  componentDidUpdate: ->
    @checkSelection()

  # methods

  getQuery: ->
    pick.getQuery @boxEl.value[...@boxEl.selectionStart], @props.specials

  getTrigger: ->
    pick.getTrigger @boxEl.value[...@boxEl.selectionStart], @props.specials

  getBeforeQuery: ->
    pick.getBeforeQuery @boxEl.value[...@boxEl.selectionStart], @props.specials

  checkSelection: ->
    isSafari = /^((?!chrome).)*safari/i.test(navigator.userAgent)
    if isSafari
      # OS X Safari IME give different selectionStart during input events
      # be careful not to trigger Safari's bug
      if @boxEl.selectionEnd isnt @props.selectionEnd
        @boxEl.selectionStart = @props.selectionStart
        @boxEl.selectionEnd = @props.selectionEnd
    else
      if @boxEl.selectionStart isnt @props.selectionStart
        @boxEl.selectionStart = @props.selectionStart
      if @boxEl.selectionEnd isnt @props.selectionEnd
        @boxEl.selectionEnd = @props.selectionEnd

  getCaretPosition: ->
    # reading width from side effect
    wholeText = @boxEl.value
    selectionStart = @boxEl.selectionStart
    widthLimit = @boxEl.clientWidth - @props.paddingLeft - @props.paddingRight
    position = measure.textPosition wholeText, selectionStart, @props.style, widthLimit

    boxPosition = @boxEl.getBoundingClientRect()

    top: boxPosition.top + @props.paddingTop + @props.borderWidth + position.top - @boxEl.scrollTop
    bottom: boxPosition.top + @props.paddingTop + @props.borderWidth + position.bottom - @boxEl.scrollTop
    left: boxPosition.left + @props.paddingLeft + @props.borderWidth + position.left
    right: boxPosition.left + @props.paddingLeft + @props.borderWidth + position.left

  getSpecialPosition: ->
    text = @getBeforeQuery()
    widthLimit = @boxEl.clientWidth - @props.paddingLeft - @props.paddingRight
    position = measure.textPosition @boxEl.value, text.length, @props.style, widthLimit

    boxPosition = @boxEl.getBoundingClientRect()

    top: boxPosition.top + @props.paddingTop + @props.borderWidth + position.top - @boxEl.scrollTop
    bottom: boxPosition.top + @props.paddingTop + @props.borderWidth + position.bottom - @boxEl.scrollTop
    left: boxPosition.left + @props.paddingLeft + @props.borderWidth + position.left
    right: boxPosition.left + @props.paddingLeft + @props.borderWidth + position.left

  getTextHeight: ->
    if @boxEl?
      clientWidth = @boxEl.clientWidth
      text = @boxEl.value
    else
      clientWidth = 400
      text = @props.text
    widthLimit = clientWidth - @props.paddingLeft - @props.paddingRight
    position = measure.textPosition text, text.length, @props.style, widthLimit
    position.bottom

  getHeight: ->
    textHeight = @getTextHeight() + @props.paddingTop + @props.paddingBottom
    switch
      when textHeight < @props.minHeight
        @props.minHeight
      when textHeight > @props.maxHeight
        @props.maxHeight
      else
        textHeight

  # events

  onChange: (event) ->

    @props.onChange
      value: event.target.value
      caret: @getCaretPosition()
      special: @getSpecialPosition()
      query: @getQuery()
      trigger: @getTrigger()
      selectionStart: @boxEl.selectionStart
      selectionEnd: @boxEl.selectionEnd
      textHeight: @getTextHeight()
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

  onScroll: (event) ->
    @onChange event

  # renderers

  render: ->
    textarea
      className: 'lite-textbox',
      value: @props.text, onChange: @onChange
      onScroll: @onScroll, style: {height: @getHeight()}
      onClick: @onClick, onKeyUp: @onKeyUp, onKeyDown: @onKeyDown
      placeholder: @props.placeholder
