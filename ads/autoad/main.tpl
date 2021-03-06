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
      <a id="storyplate-<%= AD_ID %>-textbg-redirect" target="_blank" href="<%= BG_MACRO %>">
        <div class="text-bg"></div>
      </a>
      <a id="storyplate-<%= AD_ID %>-tagline-redirect" target="_blank" href="<%= BG_MACRO %>">
        <h1 id="storyplate-tagline"><%= OVERLAY_COPY %></h1>
      </a>
      <a class="cta-read" id="storyplate-<%= AD_ID %>-cta-redirect" href="<%= CLICK_MACRO %>" target="_blank"><%= BUTTON_COPY %></a>
      <% if (BUTTON2_COPY !== undefined && BUTTON2_COPY !== '') { %>
        <div></div>
        <a class="cta-read cta2" id="storyplate-<%= AD_ID %>-cta2-redirect" href="<%= CLICK_MACRO_2 %>" target="_blank"><%= BUTTON2_COPY %></a>
      <% } %>


      <% if ((LOGO_URL !== undefined && LOGO_URL !== '') && LOGO_COPY === '') { %>
      <div class="sponsor">
        <img class="storyplate-presented" src="<%= STATIC_URL %>/img/<%= PRESENTED %>" />
        <img src="<%= LOGO_URL %>" class="sponsorlogo">
      </div>
      <% } %>

      <% if (LOGO_COPY !== undefined && LOGO_COPY !== '') { %>
      <div class="sponsor">
        <img class="storyplate-presented" src="<%= STATIC_URL %>/img/<%= PRESENTED %>" />
        <span class="sponsorlogo"><%= LOGO_COPY %></span>
      </div>
      <% } %>

      <% if (LEGAL_COPY !== undefined && LEGAL_COPY !== '') { %>
        <span class="ad-legal">
          <%= LEGAL_COPY %>
        </span>
      <% } %>

      <% if (OVERLAY_FLOATS !== undefined && OVERLAY_FLOATS.length > 0) { %>
        <% for (var i in OVERLAY_FLOATS) {
          var el = OVERLAY_FLOATS[i];
          if (el.image) { %>
            <img class="ad-floating-element" src="<%= el.url %>" style="<%= el.style %>" />
          <% } else { %>
            <span class="ad-floating-element" style="<%= el.style %>">
              <%= el.copy %>
            </span>
          <% }
        }
      } %>

    </div>

    <div class="ad-hero-container">
      <% if (FADE_URL !== undefined && FADE_URL !== '') { %>
      <div class="ad-hero ad-hero-fade">
      <% } else { %>
      <div class="ad-hero">
      <% } %>
        <div class="fixed-hero-container">
          <a id="storyplate-<%= AD_ID %>-hero-redirect" target="_blank" href="<%= BG_MACRO %>">
            <picture class="ad-hero-img">
              <% if (MOBILE_HERO_IMAGE_URL) { %>
                <source srcset="<%= MOBILE_HERO_IMAGE_URL %>" media="(max-width: 768px)">
              <% } %>
              <img src="<%= HERO_IMAGE_URL %><%= HERO_IMAGE_ARGS %>" />
            </picture>
            <% if (FADE_URL !== undefined && FADE_URL !== '') { %>
              <img class="ad-hero-fade-img" src="<%= FADE_URL %><%= HERO_IMAGE_ARGS %>" />
            <% } %>
          </a>
        </div>
      </div>
    </div>
    <div class="placeholder">
    </div>
    <% if (BG_FLOATS !== undefined && BG_FLOATS.length > 0) { %>
      <% for (var i in BG_FLOATS) {
        var el = BG_FLOATS[i];
        if (el.image) { %>
          <img class="ad-floating-element" src="<%= el.url %>" style="<%= el.style %>" />
        <% } else { %>
          <span class="ad-floating-element" style="<%= el.style %>">
            <%= el.copy %>
          </span>
        <% }
      }
    } %>
  </div>
</body>
</html>
