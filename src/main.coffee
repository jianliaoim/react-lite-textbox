
React = require 'react'
ReactDOM = require 'react-dom'

require 'volubile-ui/ui/index.less'

Page = React.createFactory (require './app/page')

ReactDOM.render Page(), document.querySelector('.demo')
