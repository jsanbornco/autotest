module.exports = (element, data, options) ->
  banner = top.document.createElement('div')
  banner.className = 'storyplate-top-banner storyplate'

  banner.innerHTML = """
    <div class="cta-watch">
      <a id="storyplate-#{data.AD_ID}-banner-bg-redirect" target="_blank" href="#{data.CLICK_MACRO}">
        <div class="banner-overlay"></div>
      </a>

      <a id="storyplate-#{data.AD_ID}-banner-tagline-redirect" target="_blank" href="#{data.CLICK_MACRO}">
        <div>
          <h3>#{data.OVERLAY_COPY}</h3>
        </div>
      </a>

      <a id="storyplate-#{data.AD_ID}-banner-cta-redirect" href="#{data.CLICK_MACRO}" class="cta" target="_blank">
        <span>#{data.BUTTON_COPY}</span>
      </a>
    </div>
    """

  page = top.document.getElementById('page') || top.document.querySelector('.modern > body > div > nav')
  if not page
    page = top.document.getElementsByClassName('guide-single')
    page = page[0] if page.length > 0

  home = true if top.document.body.className.match('home')
  page.appendChild(banner) if page? and page.appendChild

  elBottom = element.getBoundingClientRect().bottom + top.scrollY

  replaced = false
  paused = false
  top.addEventListener 'scroll', (e) ->
    unless home
      if (not replaced and banner.parentElement == null)
        replace = true
        page.appendChild(banner)

      if this.scrollY >= elBottom
        paused = true
        banner.className = "storyplate-top-banner storyplate show-banner"
      else if paused
        paused = false
        banner.className = "storyplate-top-banner storyplate"

  return banner