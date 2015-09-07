
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

  onChange: (info) ->
    @setState
      text: info.value, overview: info
      start: info.selectionStart, end: info.selectionEnd

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
      pre className: 'overview', (JSON.stringify @state.overview, null, 2)
