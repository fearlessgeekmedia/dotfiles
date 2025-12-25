<header class="site-header faculty-glyphic-regular">
  <div class="container">
    <div class="header-inner">
      <h1 class="site-title">
        {{#if logo}}
        <img src="/{{logo}}" alt="{{siteName}}" class="h-8">
        {{else}}
        <span class="text-xl font-bold">{{siteName}}</span>
        {{/if}}
      </h1>
      <nav class="main-navigation">
        <div id="myLinks">
          <ul>
            {{menu=main}}
          </ul>
        </div>
        <a href="javascript:void(0);" class="icon" onclick="toggleMenu()">
          <i class="fa fa-bars"></i>
        </a>
      </nav>
    </div>
  </div>
</header>
