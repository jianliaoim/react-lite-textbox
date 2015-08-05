
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

  onChange: (info) ->
    @setState text: info.value, overview: info

  render: ->

    div className: 'app-page',
      Textbox
        text: @state.text, onChange: @onChange, specials: ['@', ':']
      pre className: 'overview', (JSON.stringify @state.overview, null, 2)

Page = React.createFactory pageComponent

React.render Page(), document.querySelector('.demo')
