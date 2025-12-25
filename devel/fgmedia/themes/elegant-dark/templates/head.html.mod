<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Favicon -->
{{#if favicon}}
<link rel="icon" type="image/x-icon" href="{{favicon}}">
<link rel="apple-touch-icon" href="{{favicon}}">
{{else}}
<link rel="icon" type="image/x-icon" href="/favicon.ico">
{{/if}}
<title>{{title}} - {{siteName}}</title>
<link rel="stylesheet" href="/themes/elegant-dark/assets/style.css">
<link href="https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
    :root {
        --accent-color: {{accentColor}};
        --gold-accent: {{goldAccent}};
        --show-animations: {{showAnimations}};
        --elegant-mode: {{elegantMode}};
    }
    
</style> 