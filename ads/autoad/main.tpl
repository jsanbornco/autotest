<!-- intel -->
<!doctype html>
<html class="no-js" lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<title></title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
<%= style %>
</style>
<script>
<%= script %>
</script>
</head>
<body>
  <div class="homepage-ad-video storyplate" id="<%= AD_ID %>">

    <svg width='100%' height='100%' viewBox="0 0 100 100" preserveAspectRatio="none" class="bg-clip">
      <clippath id="bg">
        <polygon points="0,0 100,0 100,100 0,100"/>
      </clippath>
    </svg>

    <% if(show_ad_text) { %>
    <div class="ad-text">
      Advertisement
    </div>
    <% } %>

    <div class="text-overlay">
      <a id="storyplate-<%= AD_ID %>-textbg-redirect" target="_blank" href="<%= CLICK_MACRO %>">
        <div class="text-bg"></div>
      </a>
      <a id="storyplate-<%= AD_ID %>-tagline-redirect" target="_blank" href="<%= CLICK_MACRO %>">
        <h1 id="storyplate-tagline"><%= OVERLAY_COPY %></h1>
      </a>
      <a class="cta-read" id="storyplate-<%= AD_ID %>-cta-redirect" href="<%= CLICK_MACRO %>" target="_blank"><%= BUTTON_COPY %></a>

      <div class="sponsor">
        <img class="storyplate-presented" src="<%= STATIC_URL %>/img/presented-by.svg" />
        <img src="<%= STATIC_URL %>/img/logo.png" class="sponsorlogo">
      </div>

    </div>

    <div class="ad-hero">
      <div class="fixed-hero-container">
        <a id="storyplate-<%= AD_ID %>-hero-redirect" target="_blank" href="<%= CLICK_MACRO %>">
          <img class="ad-hero-img" src="https://storyplate.imgix.net/ads/triscuit/img/hero_pumpkin.jpg<%= HERO_IMAGE_ARGS %>" />
        </a>
      </div>
    </div>
    <div class="placeholder">
    </div>
  </div>
</body>
</html>
