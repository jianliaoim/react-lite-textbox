
React = require 'react'
keycode = require 'keycode'

Textbox = React.createFactory require '../textbox'
testCases = require '../test-cases'
div = React.createFactory 'div'
pre = React.createFactory 'pre'

module.exports = React.createClass
  displayName: 'app-page'

  getInitialState: ->
    text: testCases.longLine.text
    time: new Date
    overview: ''
    start: testCases.longLine.start
    end: testCases.longLine.start
    caret:
      top: 0
      left: 0
    special:
      top: 0
      left: 0

  componentDidMount: ->
    # test a bug, caused by unexpected render event
    setInterval =>
      @setState time: new Date
    , 1000

  focusToText: ->
    root = @refs.root
    target = root.querySelector('.lite-textbox')
    event = new Event 'input', bubbles: true
    target.focus()
    target.dispatchEvent event

  onChange: (info) ->
    @setState
      text: info.value, overview: info
      start: info.selectionStart, end: info.selectionEnd
      caret: info.caret
      special: info.special

  onKeyDown: (event) ->
    if keycode(event.keyCode) is 'enter'
      if event.metaKey and event.shiftKey
        @setState
          text: 'aaa' + @state.text
          start: @state.start + 3
          end: @state.end + 3

  renderCases: ->
    div style: @styleCasesLine(),
      Object.keys(testCases).map (entry) =>
        onClick = =>
          caseData = testCases[entry]
          @setState
            start: caseData.start, end: caseData.start, text: caseData.text
            @focusToText
        div key: entry, style: @styleCase(), onClick: onClick, entry

  render: ->

    div ref: 'root', className: 'app-page',
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
      @renderCases()
      pre className: 'overview', (JSON.stringify @state.overview, null, 2)
      div
        style:
          width: 4
          height: 30
          position: 'fixed'
          left: @state.caret.left
          top: @state.caret.top
          backgroundColor: 'hsla(0,80%,40%,0.3)'
      div
        style:
          width: 4
          height: 30
          position: 'fixed'
          left: @state.special.left
          top: @state.special.top
          backgroundColor: 'hsla(240,80%,40%,0.3)'

  styleCasesLine: ->
    margin: '10px 0'

  styleCase: ->
    backgroundColor: 'hsla(240,80%,50%,0.5)'
    cursor: 'pointer'
    display: 'inline-block'
    padding: '0 10px'
    color: 'white'
    marginRight: '10px'
    cursor: 'pointer'
