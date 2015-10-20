
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

### Develop

https://github.com/teambition/coffee-webpack-starter

### License

MIT
