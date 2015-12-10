
if typeof window isnt 'undefined'
  canvas = document.createElement('canvas')
  ctx = canvas.getContext('2d')

splitText = (text) ->
  result = []
  buffer = ''
  text.split('').forEach (char) ->
    switch
      when char is '\n'
        if buffer.length > 0
          result.push buffer
          buffer = ''
        result.push char
      when char is ' '
        if buffer.length > 0
          result.push buffer
          buffer = ''
        result.push char
      when char.match(/[\u0000-\u007F]/)?
        buffer = "#{buffer}#{char}"
      else
        if buffer.length > 0
          result.push buffer
          buffer = ''
        result.push char
  if buffer.length > 0
    result.push buffer
  result

# use caching to improve performace
stylesDict = []
widthCaches = {}
measureCharWidth = (text, style) ->
  # use dictionary since style is very long, which costs memory
  styleId = stylesDict.indexOf style
  if styleId < 0 # not in record
    styleId = stylesDict.length
    stylesDict.push style

  # regard any Chinese character as '字' to reduce memory
  if text.match(/^[\u4E00-\u9FA5\uF900-\uFA2D]$/)?
    text = '字'

  cachePath = "#{styleId}:#{text}"
  maybeWidth = widthCaches[cachePath]
  if maybeWidth?
    return maybeWidth
  else if typeof window is 'undefined'
    return 0 # can not calculate
  else
    if ctx.font isnt style
      ctx.font = style
    theWidth = ctx.measureText(text).width
    widthCaches[cachePath] = theWidth
    return theWidth

# very tricky, as fonts loaded, cache is outdated
# http://stackoverflow.com/a/32292880/883571
# also make sure it does break in Gulp
# and .ready is a promise, has compatibility issues
if (typeof window isnt 'undefined') and document.fonts?
  document.fonts.ready?.then? ->
    widthCaches = {}

measureTextWidth = (text, style) ->
  width = 0
  for char in text
    width = width + (measureCharWidth char, style)
  width

exports.textPosition = (text, cursor, style, limitWidth) ->
  # for performace reasons, return 0 when text too long
  textBefore = text[...cursor]
  textAfter = text[cursor..]
  pieceAfter = textAfter.split(' ')[0] or ''

  if text.length > 3000
    return {top: 0, bottom: style.lineHeight, left: 0, right: 0}

  {lineHeight} = style
  styleString = "#{style.fontSize} #{style.fontFamily}"
  pieceAfterWidth = measureTextWidth pieceAfter, styleString

  # layout text

  wordList = splitText(textBefore)
  lineCount = 0
  widthAcc = 0
  index = 0
  while index < wordList.length
    word = wordList[index]
    indexEnd = (index + 1) is wordList.length

    isAsciiBefore = (word[0]? and word[0].match(/[\u0000-\u007F]/))? and (not word[0] in [' ', '\n'])
    isAsciiAfter = (pieceAfter[0]? and pieceAfter[0].match(/[\u0000-\u007F]/)) and (not word[0] in [' ', '\n'])
    isAsciiJoined = isAsciiBefore and isAsciiAfter

    if word is '\n'
      lineCount += 1
      widthAcc = 0
    else
      wordWidth = measureTextWidth word, styleString
      overflowed = (widthAcc + wordWidth) > limitWidth
      overflowedWithAfter = (widthAcc + wordWidth + pieceAfterWidth) > limitWidth

      if overflowed
        lineCount += 1
        widthAcc = wordWidth
      else if indexEnd and (not (word in [' ', '\n'])) and overflowedWithAfter and isAsciiJoined
        lineCount += 1
        widthAcc = wordWidth
      else
        widthAcc += wordWidth
    index++

  # return rect information
  top: lineCount * lineHeight
  bottom: (lineCount + 1) * lineHeight
  left: widthAcc
  right: widthAcc
