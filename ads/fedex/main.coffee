# sodel
render = require '../../scripts/render.coffee'

options = require './options.json'

copy = window.storyplateCopy

if copy
  COPY_OPTION = copy
else
  COPY_OPTION = '1'


if window.clickmacro
  clickMacro = window.clickmacro
else
  clickMacro = ''

if window.clickmacro2
  clickMacro2 = window.clickmacro2
else
  clickMacro2 = ''

if window.hovermacro
  hoverMacro = window.hovermacro
else
  hoverMacro = ''

banner = top.document.createElement('div')
banner.className = 'storyplate-top-banner storyplate'


render
  name: __dirname.split('/').slice(-1)[0]
  template: require './main.tpl'
  style: require './main.sass'
  data: {
    OVERLAY_COPY: options.copy[COPY_OPTION].overlay
    BUTTON_COPY: options.copy[COPY_OPTION].button
    BUTTON2_COPY: options.copy[COPY_OPTION].button2
    CLICK_MACRO: clickMacro
    CLICK_MACRO_2: clickMacro2
    HOVER_MACRO: hoverMacro
    AD_ID: options.id
  }
  maximize: true
  (err, element, data) ->
    banner.innerHTML = """
      <div class="cta-watch">
        <a id="storyplate-#{data.AD_ID}-banner-bg-redirect" target="_blank" href="#{data.CLICK_MACRO}">
          <div class="banner-overlay"></div>
        </a>
        
        <a id="storyplate-#{data.AD_ID}-banner-tagline-redirect" target="_blank" href="#{data.CLICK_MACRO}">
          <div>
            <h3>#{options.copy[COPY_OPTION].overlay}</h3>
          </div>
        </a>
        
        <a id="storyplate-#{data.AD_ID}-banner-cta-redirect" href="#{data.CLICK_MACRO}" class="cta" target="_blank">
          <span>#{options.copy[COPY_OPTION].button}</span>
        </a>
      </div>
      """
    page = top.document.getElementById('page')
    home = true if top.document.body.className.match('home')
    page.appendChild(banner) if page?

    hero = element.getElementsByClassName('fixed-hero-container')[0]
    elBottom = element.getBoundingClientRect().bottom + top.scrollY
    elTop = element.offsetTop

    heroTop = false
    heroHeight = 0

    paused = false

    top.addEventListener 'scroll', (e) ->
      if home and heroHeight < top.innerHeight and top.innerWidth > 768
        heroTop = hero.offsetTop unless heroTop and heroTop < heroHeight
        unless heroHeight
          heroHeight = hero.offsetHeight
        else
          if top.scrollY >= elTop - (heroTop + 10)
            hero.style.position = "absolute"
            hero.style.top = "0"
            hero.style.bottom = "auto"
            hero.style.marginBottom = "auto"
          else
            hero.style.position = "fixed"
            hero.style.top = "auto"
            hero.style.bottom = "0"

      unless home
        if this.scrollY >= elBottom
          paused = true
          banner.className = "storyplate-top-banner storyplate show-banner"
        else if paused
          paused = false
          banner.className = "storyplate-top-banner storyplate"
