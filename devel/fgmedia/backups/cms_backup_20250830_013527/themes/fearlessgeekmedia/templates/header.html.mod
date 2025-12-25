<header class="headerWrapper">
    <div class="header">
        <div>
            <a class="terminal" href="/">
                <span>{{#if themeOptions.terminalBranding}}{{themeOptions.terminalBranding}}{{else}}home@fearlessgeekmedia.com ~ ${{/if}}</span>
            </a>
        </div>
        <input class="side-menu" type="checkbox" id="side-menu">
        <label class="hamb" for="side-menu"><span class="hamb-line"></span></label>
        <nav class="headerLinks">
            {{menu=main}}
        </nav>
    </div>
</header> 