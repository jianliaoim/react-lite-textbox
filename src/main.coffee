
React = require 'react'

require 'volubile-ui/ui/index.less'

Textbox = React.createFactory require './textbox'
div = React.createFactory 'div'

pageComponent = React.createClass
  displayName: 'app-page'

  getInitialState: ->
    text: ''

  onChange: (text) ->
    @setState text: text

  render: ->

    div className: 'app-page',
      Textbox
        text: @state.text, onChange: @onChange

Page = React.createFactory pageComponent

React.render Page(), document.querySelector('.demo')
