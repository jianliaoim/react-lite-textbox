
{recur} = require 'tail-call/core'

getQuery = recur (buffer, text, specials) ->
  if text.length is 0
    null
  else
    endChar = text[text.length-1]
    init = text[...-1]
    if endChar in specials
      buffer
    else
      buffer = endChar + buffer
      getQuery buffer, init, specials

exports.getQuery = (text, specials) ->
  getQuery '', text, specials

exports.getTrigger = getTrigger = recur (text, specials) ->
  if text.length is 0
    null
  else
    endChar = text[text.length-1]
    init = text[...-1]
    if endChar is ' '
      null
    else if endChar in specials
      endChar
    else
      getTrigger init, specials

exports.getBeforeQuery = getBeforeQuery = recur (text, specials) ->
  if text.length is 0
    ''
  else
    endChar = text[text.length-1]
    init = text[...-1]
    if endChar in specials
      text
    else
      getBeforeQuery init, specials
