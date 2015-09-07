
React = require 'react'

require 'volubile-ui/ui/index.less'

Page = React.createFactory (require './app/page')

React.render Page(), document.querySelector('.demo')
