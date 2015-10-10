
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

exports.textPosition = (text, cursor, style, limitWidth) ->
  # for performace reasons, return 0 when text too long
  textBefore = text[...cursor]
  textAfter = text[cursor..]
  pieceAfter = textAfter.split(' ')[0] or ''

  if text.length > 800
    return {top: 0, bottom: style.lineHeight, left: 0, right: 0}

  {lineHeight} = style
  ctx.font = "#{style.fontSize} #{style.fontFamily}"
  pieceAfterWidth = ctx.measureText(pieceAfter).width
  whitespaceWidth = ctx.measureText(' ').width

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
      wordWidth = ctx.measureText(word).width
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
