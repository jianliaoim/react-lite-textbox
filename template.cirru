
var
  stir $ require :stir-template

var
  (object~ html head title body meta script link div a span) stir

var
  line $ \ (text)
    return $ div null text

= module.exports $ \ (data)
  return $ stir.render
    stir.doctype
    html null
      head null
        title null ":Textbox"
        meta $ object (:charset :utf-8)
        link $ object (:rel :icon)
          :href :http://tp4.sinaimg.cn/5592259015/180/5725970590/1
        link $ object (:rel :stylesheet)
          :href :src/main.css
        script $ object (:src data.vendor) (:defer true)
        script $ object (:src data.main) (:defer true)
      body null
        div
          object (:class :intro)
          div ({} (:class :title))  ":This is a demo of Textbox."
          div null
            span null ":Read more at "
            a
              object (:href :http://github.com/teambition/react-lite-textbox)
              , :github.com/teambition/react-lite-textbox
            span null :.
        div
          object (:class :demo)
