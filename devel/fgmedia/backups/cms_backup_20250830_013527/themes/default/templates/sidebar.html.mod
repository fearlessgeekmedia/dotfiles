<aside class="sidebar">
    {{#if menu.sidebar}}
        <nav class="sidebar-nav">
            <h3>Navigation</h3>
            <ul>
                {{#each menu.sidebar}}
                    <li><a href="/{{url}}">{{title}}</a></li>
                {{/each}}
            </ul>
        </nav>
    {{/if}}
    
    {{#if widgets.left-sidebar}}
        <div class="sidebar-widgets">
            {{#each widgets.left-sidebar}}
                <div class="widget widget-{{type}}">
                    {{#if title}}
                        <h3 class="widget-title">{{title}}</h3>
                    {{/if}}
                    <div class="widget-content">
                        {{#if type === "documentation-nav"}}
                            {{#if content === "documentation-nav"}}
                                <ul>
                                    <li><a href="/documentation">Getting Started</a></li>
                                    <li><a href="/documentation/creating-themes">Creating Themes</a></li>
                                    <li><a href="/documentation/plugin-development-guide">Plugin Development</a></li>
                                    <li><a href="/documentation/modular-templates">Modular Templates</a></li>
                                </ul>
                            {{else if content === "theme-development-nav"}}
                                <ul>
                                    <li><a href="/documentation/theme-development-workflow">Workflow</a></li>
                                    <li><a href="/documentation/theme-options-guide">Theme Options</a></li>
                                    <li><a href="/documentation/sass-theme-guide">SASS Guide</a></li>
                                </ul>
                            {{else if content === "advanced-nav"}}
                                <ul>
                                    <li><a href="/documentation/export-sites-to-static-html">Static Export</a></li>
                                    <li><a href="/documentation/cms-modes">CMS Modes</a></li>
                                    <li><a href="/documentation/ad-area-system">Ad Area System</a></li>
                                </ul>
                            {{/if}}
                        {{else}}
                            {{content}}
                        {{/if}}
                    </div>
                </div>
            {{/each}}
        </div>
    {{/if}}
    
    {{#if children}}
        <div class="sidebar-pages">
            <h3>Related Pages</h3>
            <ul>
                {{#each children}}
                    <li><a href="/{{url}}">{{title}}</a></li>
                {{/each}}
            </ul>
        </div>
    {{/if}}
</aside> 