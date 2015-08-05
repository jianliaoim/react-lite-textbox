
React = require 'react'
{recur} = require('tail-call/core')

br = React.createFactory 'br'
span = React.createFactory 'span'

expandBefore = recur (result, buffer, remaining, specials, hasShown) ->
  l = remaining.length

  if remaining.length is 0
    if buffer.length > 0
      prev = span key: "span#{l}", buffer
      return [prev].concat result
    else
      return result

  cursor = remaining[remaining.length-1]
  init = remaining[...-1]

  switch
    when (not hasShown) and (cursor in specials)
      if buffer.length > 0
        prev = span key: "text#{l}", buffer
        result = [prev].concat result
        buffer = ''
      current = span className: 'textbox-special', key: "special#{l}", cursor
      result = [current].concat result
      expandBefore result, '', init, specials, true
    else
      buffer = cursor + buffer
      expandBefore result, buffer, init, specials, hasShown

expandAfter = (text) ->
  if text is ''
    return span className: 'textAfter', key: 'after', ' '
  else
    if text[text.length-1] is '\n'
      text += ' ' # force show last empty line
    span className: 'textAfter', key: 'after', text

exports.expand = (text, start, specials) ->
  textBefore = text[...start]
  textAfter = text[start..]
  domBefore = expandBefore [], '', textBefore, specials, false
  domAfter = expandAfter textAfter
  current = span className: 'textbox-caret', key: 'caret'
  domBefore.concat current, domAfter
