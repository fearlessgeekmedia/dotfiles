<meta charset="UTF-8">
<title>{{title}} - Fearless Geek Media</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Favicon -->
{{#if favicon}}
<link rel="icon" type="image/x-icon" href="{{favicon}}">
<link rel="apple-touch-icon" href="{{favicon}}">
{{else}}
<link rel="icon" type="image/x-icon" href="/favicon.ico">
{{/if}}
<meta name="color-scheme" content="dark">
<meta name="description" content="{{description}}">
<meta name="generator" content="FearlessCMS">

<link rel="canonical" href="{{current_url}}">
<link rel="stylesheet" href="/themes/{{theme}}/assets/style.css">

<!-- Fira Mono font for terminal aesthetic -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fira+Mono:wght@400;500&display=swap" rel="stylesheet">

<!-- TypeIt for animated typing effect -->
<script src="https://unpkg.com/typeit@8.7.1/dist/index.umd.js"></script>

<style>
    :root { 
        --color-accent: #00c767; 
    }
    
    :root { 
        --color-secondary: #02a002; 
    }
    
    /* ensure global UI toggles visible if injected */
    .fcms-theme-toggle{display:inline-flex}
</style>

<script src="https://cdn.tailwindcss.com"></script> 