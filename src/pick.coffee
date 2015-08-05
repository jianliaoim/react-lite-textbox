
{recur} = require 'tail-call/core'

getQuery = recur (buffer, text, specials) ->
  if text.length is 0
    return null
  else
    endChar = text[text.length-1]
    init = text[...-1]
    if endChar in specials
      return buffer
    else
      buffer = endChar + buffer
      getQuery buffer, init, specials

exports.getQuery = (text, specials) ->
  getQuery '', text, specials

getTrigger = recur (text, specials) ->
  if text.length is 0
    return null
  else
    endChar = text[text.length-1]
    init = text[...-1]
    if endChar in specials
      return endChar
    else
      getTrigger init, specials

exports.getTrigger = (text, specials) ->
  getTrigger text, specials
