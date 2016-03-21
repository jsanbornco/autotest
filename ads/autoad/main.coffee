# sodel
render = require '../../scripts/render.coffee'

options = require '../../data/autotune.json'

copy = window.storyplateCopy

copyMatch = top.window.location.search.match(/copy=(\d)/)
if copyMatch and top.window.location.search.match('sp_ad')
  copy = copyMatch[1]

colorConvert = (hex) ->
  dec = parseInt hex.replace('#', ''), 16
  r = (dec >> 16) & 255
  g = (dec >> 8) & 255
  b = dec & 255
  [r, g, b].join()

if copy
  COPY_OPTION = copy
else
  COPY_OPTION = '0'

if options.copy[COPY_OPTION].dark
  copy_color = '#525252'
  presented = "presented-by_black.svg"
else
  presented = "presented-by.svg"
  copy_color = '#fff'

data = {
  OVERLAY_COPY: options.copy[COPY_OPTION].main
  BUTTON_COPY: options.copy[COPY_OPTION].cta
  BUTTON2_COPY: options.copy[COPY_OPTION].cta2
  HERO_IMAGE_URL: options.image
  LOGO_URL: options.logo
  OVERLAY_COLOR: colorConvert(options.bg_color) or '255, 255, 255'
  OVERLAY_OPACITY_MOBILE: options.bg_opacity_mobile or '0.6'
  CTA_COLOR: colorConvert(options.copy[COPY_OPTION].cta_color) or '41, 48, 142'
  CTA2_COLOR: colorConvert(options.copy[COPY_OPTION].cta2_color) or '41, 48, 142'
  COPY_COLOR: copy_color
  PRESENTED: presented
  OFFSET: options.offset or 17
  MOBILE_OFFSET: options.mobile_offset or 0
  MOBILE_LEFT_OFFSET: options.mobile_left_offset or 30

  CLICK_MACRO: window.clickmacro or ''
  CLICK_MACRO_2: window.clickmacro2 or ''

  AD_ID: options.id
}




banner = top.document.createElement('div')
banner.className = 'storyplate-top-banner storyplate'


render
  name: __dirname.split('/').slice(-1)[0]
  template: require './main.tpl'
  style: require './main.sass'
  data: data
  maximize: true
  (err, element, data) ->
    banner.innerHTML = """
      <div class="cta-watch">
        <a id="storyplate-#{data.AD_ID}-banner-bg-redirect" target="_blank" href="#{data.CLICK_MACRO}">
          <div class="banner-overlay"></div>
        </a>

        <a id="storyplate-#{data.AD_ID}-banner-tagline-redirect" target="_blank" href="#{data.CLICK_MACRO}">
          <div>
            <h3>#{options.copy[COPY_OPTION].main}</h3>
          </div>
        </a>
        <a id="storyplate-#{data.AD_ID}-banner-cta-redirect" href="#{data.CLICK_MACRO}" class="cta" target="_blank">
          #{options.copy[COPY_OPTION].cta}
        </a>
      </div>
      """
    page = top.document.getElementById('page')
    home = true if top.document.body.className.match('home')
    page.appendChild(banner)

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
