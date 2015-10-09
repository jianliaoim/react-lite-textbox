
canvas = document.createElement('canvas')
ctx = canvas.getContext('2d')

exports.textPosition = (text, style, limitWidth) ->
  # for performace reasons, return 0 when text too long
  if text.length > 400
    return {top: 0, bottom: style.lineHeight, left: 0, right: 0}

  {lineHeight} = style
  ctx.font = "#{style.fontSize} #{style.fontFamily}"
  whitespaceWidth = ctx.measureText(' ').width

  # layout text

  wordList = []
  text.split(' ').forEach (word, index) ->
    if index > 0
      wordList.push ' '
    wordList.push word
  lineCount = 0
  widthAcc = 0
  index = 0
  while index < wordList.length
    word = wordList[index]
    if word is '\n'
      lineCount += 1
      widthAcc = 0
    else
      wordWidth = ctx.measureText(word).width
      if (widthAcc + wordWidth) >= limitWidth
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
