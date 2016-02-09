# lowes
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

banner = top.document.createElement('div')
banner.className = 'storyplate-top-banner storyplate'

render
  name: __dirname.split('/').slice(-1)[0]
  template: require './main.tpl'
  style: require './main.sass'
  data: {
    OVERLAY_COPY: options.copy[COPY_OPTION].overlay
    BUTTON_COPY: options.copy[COPY_OPTION].button
    CLICK_MACRO: clickMacro
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
    if not page
      page = top.document.getElementsByClassName('guide-single')
      page = page[0] if page.length > 0

    home = true if top.document.body.className.match('home')
    page.appendChild(banner) if page?

    hero = element.getElementsByClassName('fixed-hero-container')[0]
    elBottom = element.getBoundingClientRect().bottom + top.scrollY
    elTop = element.offsetTop

    heroTop = false
    heroHeight = 0

    paused = false

    h = element.offsetHeight
    vid = element.getElementsByClassName('storyplate-video-container')[0]
    vid_loaded = false

    vidScript = document.createElement('script')
    vidScript.src = '//players.brightcove.net/4365621443001/c2c92e6d-7f3b-45b6-af0f-745a5732b4f9_default/index.min.js'

    vid.appendChild(vidScript)


    top.addEventListener 'scroll', (e) ->

      unless home
        if this.scrollY >= elBottom
          paused = true
          banner.className = "storyplate-top-banner storyplate show-banner"
        else if paused
          paused = false
          banner.className = "storyplate-top-banner storyplate"
