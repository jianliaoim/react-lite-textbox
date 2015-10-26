
Textbox component for Talk by Teambition
----

Demo http://ui.talk.ai/react-lite-textbox/

Features:

* realtime caret pixel position detection with Canvas API
* special characters(i.e. `@`, `:`) pixel position detection with Canvas API
* complete text based on special characters such as `@`

Caveats:

* Canvas API is not very accurate dealing with line breaks
* Need to specify paddings as props in order to compute position
* May cause CPU time find positions very frequently

### Usage

```bash
npm i --save react-lite-textbox
```

```coffee
Textbox
  text: @state.text, onChange: @onChange, specials: ['@', ':']
  placeholder: 'Write here...'
  selectionStart: @state.start
  selectionEnd: @state.end
  onKeyDown: @onKeyDown
  paddingTop: 10
  paddingBottom: 10
  paddingLeft: 10
  paddingRight: 10
  lineHeight: 28
```

Read `src/main.coffee` for details.

### API to detect caret position in pixels

In order to detect precise pixel position of caret, this project utilized [`measureText` API][api] to do manual layout based on Canvas APIs. The results is an object of pixels.

[api]: https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/measureText

```coffee
measure = require 'react-lite-textbox/lib/measure'
measure.textPosition(text, cursor, style, limitWidth)
# => {top: 40, bottom: 50, left: 10, right: 10}
```


* `text` not only the text before the caret, also about one line of text more to help with layouts.
* `cursor` the position where the caret is, an integer.
* `style` property is consisted of `{fontSize: 14, lineHeight: 20, fontFamily: 'Optima'}` which Canvas may need in measuring.
* `limitWidth` width of container, an integer.

Notice the manual layout algorithm has two flaws dealing with punctuations in CJK languages and words that overflows the container. In simple cases the result can be as precise as `Element.getBoundingClientRect` which gets position with a selection object.

Send me PR if you got ideas to improve the results.

### Develop

https://github.com/teambition/coffee-webpack-starter

### License

MIT
