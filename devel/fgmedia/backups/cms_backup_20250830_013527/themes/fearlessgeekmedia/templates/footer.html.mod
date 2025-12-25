<footer class="footer">
    <span>
        © {{current_year}} Fearless Geek Media, Built with
        <a href="https://fearlesscms.com" class="footerLink">FearlessCMS</a>
    </span>
    
    {{#if themeOptions.showSocialLinks}}
    <div class="socialNavbar">
        <ul>
            <li><a href="{{#if themeOptions.githubUrl}}{{themeOptions.githubUrl}}{{else}}https://github.com/fearlessgeekmedia{{/if}}" target="_blank" aria-label="GitHub Profile">github</a></li>
            <li><a href="{{#if themeOptions.instagramUrl}}{{themeOptions.instagramUrl}}{{else}}https://instagram.com/fearlessgeekmedia{{/if}}" target="_blank">instagram</a></li>
            <li><a href="{{#if themeOptions.facebookUrl}}{{themeOptions.facebookUrl}}{{else}}https://www.facebook.com/fearlessgeekmedia{{/if}}" target="_blank">facebook</a></li>
            <li><a href="{{#if themeOptions.linktreeUrl}}{{themeOptions.linktreeUrl}}{{else}}https://linktr.ee/fearlessgeekmedia{{/if}}" target="_blank">linktree</a></li>
        </ul>
    </div>
    {{/if}}
</footer> 