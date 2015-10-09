
React = require 'react'
keycode = require 'keycode'

Textbox = React.createFactory require '../textbox'
div = React.createFactory 'div'
pre = React.createFactory 'pre'

module.exports = React.createClass
  displayName: 'app-page'

  getInitialState: ->
    text: ''
    overview: ''
    start: 0
    end: 0
    caret:
      top: 0
      left: 0
    special:
      top: 0
      left: 0

  onChange: (info) ->
    @setState
      text: info.value, overview: info
      start: info.selectionStart, end: info.selectionEnd
      caret: info.caret
      # special: info.special

  onKeyDown: (event) ->
    if keycode(event.keyCode) is 'enter'
      if event.metaKey and event.shiftKey
        @setState
          text: 'aaa' + @state.text
          start: @state.start + 3
          end: @state.end + 3

  render: ->

    div className: 'app-page',
      Textbox
        text: @state.text, onChange: @onChange, specials: ['@', ':']
        placeholder: 'Write here...'
        selectionStart: @state.start
        selectionEnd: @state.end
        onKeyDown: @onKeyDown
        paddingTop: 10
        paddingBottom: 10
        paddingLeft: 10
        paddingRight: 10
        lineHeight: 28
      pre className: 'overview', (JSON.stringify @state.overview, null, 2)
      div
        style:
          width: 1
          height: 30
          position: 'fixed'
          left: @state.caret.left
          top: @state.caret.top
          backgroundColor: 'hsla(0,80%,40%,0.4)'
      div
        style:
          width: 1
          height: 30
          position: 'fixed'
          left: @state.special.left
          top: @state.special.top
          backgroundColor: 'hsla(240,80%,40%,0.4)'
