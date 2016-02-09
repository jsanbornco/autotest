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

    <div class="ad-text">
      Advertisement
    </div>
    <div class="text-overlay">
      <div class="overlay-border"></div>
      <a id="storyplate-<%= AD_ID %>-textbg-redirect" target="_blank" href="<%= CLICK_MACRO %>">
        <div class="text-bg"></div>
      </a>
      <a id="storyplate-<%= AD_ID %>-tagline-redirect" target="_blank" href="<%= CLICK_MACRO %>">
        <h1 id="storyplate-tagline"><%= OVERLAY_COPY %></h1>
      </a>
      <a class="cta-read" id="storyplate-<%= AD_ID %>-cta-redirect" href="<%= CLICK_MACRO %>" target="_blank"><%= BUTTON_COPY %></a>

      <div class="sponsor">
        <img class="storyplate-presented" src="<%= STATIC_URL %>/img/presented-by.svg" />
        <img src="<%= STATIC_URL %>/img/logo.svg" class="sponsorlogo">
      </div>

    </div>

    <a href="storyplate-<%= AD_ID %>-hero-redirect">
      <div class="ad-hero-bg"></div>
    </a>
    <a id="storyplate-<%= AD_ID %>-video-redirect" target="_blank" href="<%= CLICK_MACRO %>">
      <div class="storyplate-video-container">
      <video
        data-video-id="4663994357001"
        data-account="4365621443001"
        data-player="c2c92e6d-7f3b-45b6-af0f-745a5732b4f9"
        data-embed="default"
        autoplay
        loop
        class="video-js"></video>
      </div>
    </a>
    <div class="placeholder">
    </div>
  </div>
</body>
</html>
