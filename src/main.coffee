
React = require 'react'

require 'volubile-ui/ui/index.less'

Textbox = React.createFactory require './textbox'
div = React.createFactory 'div'
pre = React.createFactory 'pre'

pageComponent = React.createClass
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

  render: ->

    div className: 'app-page',
      Textbox
        text: @state.text, onChange: @onChange, specials: ['@', ':']
        placeholder: 'Write here...'
        selectionStart: @state.start
        selectionEnd: @state.end
      pre className: 'overview', (JSON.stringify @state.overview, null, 2)

Page = React.createFactory pageComponent

React.render Page(), document.querySelector('.demo')
