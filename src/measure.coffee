
canvas = document.createElement('canvas')
ctx = canvas.getContext('2d')

exports.textPosition = (text, style, limitWidth) ->
  {lineHeight} = style
  ctx.font = "#{style.fontSize} #{style.fontFamily}"

  # layout text
  charList = text.split('')
  lineCount = 0
  widthAcc = 0
  index = 0
  while index < charList.length
    char = charList[index]
    if char is '\n'
      lineCount += 1
      widthAcc = 0
    else
      charWidth = ctx.measureText(char).width
      if (widthAcc + charWidth) >= limitWidth
        lineCount += 1
        widthAcc = 0
      else
        widthAcc += charWidth
    index++

  # return rect information
  top: lineCount * lineHeight
  bottom: (lineCount + 1) * lineHeight
  left: widthAcc
  right: widthAcc
