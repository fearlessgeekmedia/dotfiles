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
<link rel="stylesheet" href="/themes/vintage/assets/style.css">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Source+Sans+Pro:wght@300;400;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: {{primaryColor}};
        --accent-color: {{accentColor}};
        --vintage-mode: {{vintageMode}};
    }
    
</style> 