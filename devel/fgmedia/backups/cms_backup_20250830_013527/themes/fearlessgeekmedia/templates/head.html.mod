<meta charset="UTF-8">
<title>{{site_name}} - {{title}}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="color-scheme" content="dark">
<meta name="description" content="{{#if meta_description}}{{meta_description}}{{else}}Professional web design and development services by Fearless Geek Media{{/if}}">
<meta name="generator" content="FearlessCMS">

<link rel="canonical" href="{{current_url}}">
<link rel="stylesheet" href="/themes/fearlessgeekmedia/assets/style.css">

<!-- Fira Mono font for terminal aesthetic -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fira+Mono:wght@400;500&display=swap" rel="stylesheet">

<!-- TypeIt for animated typing effect -->
<script src="https://unpkg.com/typeit@8.7.1/dist/index.umd.js"></script>

<style>
  {{#if themeOptions.accentColor}}
  :root { 
    --color-accent: {{themeOptions.accentColor}}; 
  }
  {{/if}}
  
  {{#if themeOptions.secondaryAccent}}
  :root { 
    --color-secondary: {{themeOptions.secondaryAccent}}; 
  }
  {{/if}}
  
  /* ensure global UI toggles visible if injected */
  .fcms-theme-toggle{display:inline-flex}
</style> 