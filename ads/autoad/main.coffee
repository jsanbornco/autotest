# sodel
render = require '../../scripts/render.coffee'

options = require '../../data/autotune.json'

copy = window.storyplateCopy

copyMatch = top.window.location.search.match(/copy=(\d)/)
if copyMatch and top.window.location.search.match('sp_ad')
  copy = copyMatch[1]

colorConvert = (hex) ->
  if hex
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

if options.copy[COPY_OPTION].darkcta
  cta_copy_color = '#525252'
else
  cta_copy_color = '#fff'

options.banner_cta_color = false if options.banner_cta_color == "#000000"
options.banner_color = false if options.banner_color == "#000000"

bg_floats = []
overlay_floats = []
options.floating_element = options.floating_element || []
for el in options.floating_element
  el.style = ""
  placement = {}

  if el.position == 1 or el.position == 3
    placement.v = "top"
  else
    placement.v = "bottom"

  if el.position == 1 or el.position == 2
    placement.h = "left"
  else
    placement.h = "right"

  horizontal = el.horizontal or 0
  vertical = el.vertical or 0

  if el.background
    bg_floats.push(el)
  else
    overlay_floats.push(el)

  if el.image
    el.style = "width: #{el.size}em; #{placement.h}: #{horizontal}%; #{placement.v}: #{vertical}%"
  else
    el.style = "font-size: #{el.size}em; #{placement.h}: #{horizontal}%; #{placement.v}: #{vertical}%; color: #{el.color}"

data = {
  OVERLAY_COPY: options.copy[COPY_OPTION].main
  OVERLAY_COPY_WEIGHT: if options.copy[COPY_OPTION].bold then '600' else '400'
  BUTTON_COPY: options.copy[COPY_OPTION].cta
  BUTTON2_COPY: options.copy[COPY_OPTION].cta2
  HERO_IMAGE_URL: options.image
  MOBILE_HERO_IMAGE_URL: options.mobile_image || false
  LOGO_URL: options.logo
  LOGO_COPY: options.logocopy or ''
  LOGO_WIDTH: options.logo_width or 6
  BANNER_LOGO: if options.bannerlogo then 'block' else 'none'
  OVERLAY_COLOR: colorConvert(options.bg_color) or '255, 255, 255'
  BANNER_COLOR: colorConvert(options.banner_color) or colorConvert(options.bg_color) or '255, 255, 255'
  OVERLAY_OPACITY_MOBILE: options.bg_opacity_mobile or '0.6'
  BANNER_COPY: options.copy[COPY_OPTION].banner or ""
  CTA_COLOR: colorConvert(options.copy[COPY_OPTION].cta_color) or '41, 48, 142'
  CTA2_COLOR: colorConvert(options.copy[COPY_OPTION].cta2_color) or '41, 48, 142'
  BANNER_CTA_COLOR: colorConvert(options.banner_cta_color) or colorConvert(options.copy[COPY_OPTION].cta_color) or '255, 255, 255'
  COPY_COLOR: copy_color
  CTA_COPY_COLOR: cta_copy_color
  PRESENTED: presented
  OFFSET: options.offset or 0
  ANCHOR: if options.anchor then 'top' else 'bottom'
  MOBILE_OFFSET: options.mobile_offset or 0
  MOBILE_LEFT_OFFSET: options.mobile_left_offset or 0
  HOMEPAGE_OFFSET: options.hp_offset or 0
  MOBILE_SCALE: if (options.mobile_image and not options.mobile_scale) then 100 else options.mobile_scale or 150
  FADE_URL: options.fade_url or ''
  LEGAL_COPY: options.legal or ""
  LEGAL_SIZE: options.legal_size or "0.4"
  FLOATING_ELEMENTS: options.floating_element or undefined
  BG_FLOATS: bg_floats or undefined
  OVERLAY_FLOATS: overlay_floats or undefined
  OVERLAY_DISPLAY: if options.hide_overlay then 'none' else 'block'
  DESKTOP_RATIO: (options.bg_ratio_desktop || 0) * 100
  MOBILE_RATIO: (options.bg_ratio_mobile || 0) * 100


  CLICK_MACRO: window.clickmacro or ''
  CLICK_MACRO_2: window.clickmacro2 or ''
  BG_MACRO: window.backgroundmacro or window.clickmacro

  AD_ID: options.id
}

if (data.BANNER_COLOR == '255,255,255')
  data.BANNER_COLOR = "240, 240, 240"



banner = top.document.createElement('div')
banner.className = 'storyplate-top-banner storyplate'


render
  name: __dirname.split('/').slice(-1)[0]
  template: require './main.tpl'
  style: require './main.sass'
  data: data
  maximize: true
  (err, element, data) ->
    bannerInit = require "../../scripts/banner.coffee"
    banner = bannerInit element, data, options

    home = true if top.document.documentElement.className.match('home') or top.document.body.className.match('home')

    hero = element.getElementsByClassName('fixed-hero-container')[0]
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
