# FearlessGeekMedia Theme for FearlessCMS

A terminal/hacker aesthetic theme for FearlessCMS, inspired by the FearlessGeekMedia website. This theme features a dark, professional design with green accents and monospace fonts, perfect for tech companies, developers, and creative agencies.

## Features

- **Terminal Aesthetic**: Inspired by command-line interfaces with monospace fonts
- **Dark Theme**: Professional dark color scheme with green accents
- **Responsive Design**: Mobile-friendly navigation and layout
- **Customizable**: Easy to customize colors, branding, and social links
- **Blog Support**: Built-in templates for blog posts and project showcases
- **Social Integration**: Configurable social media links
- **Contact Forms**: Styled form templates for contact and discovery sessions

## Installation

1. Copy the `fearlessgeekmedia` folder to your FearlessCMS `themes` directory
2. In your FearlessCMS admin panel, go to Themes
3. Activate the "FearlessGeekMedia Theme"
4. Customize the theme options as needed

## Theme Options

### Branding
- **Logo Image**: Upload your company logo
- **Terminal Branding**: Customize the terminal prompt text
- **Hero Title**: Main title on the home page
- **Hero Subtitle**: Subtitle text below the main title
- **Hero Tagline**: Animated tagline that appears after the title

### Colors
- **Accent Color**: Primary green accent color (default: #00c767)
- **Secondary Accent**: Secondary green accent color (default: #02a002)

### Social Media
- **Show Social Links**: Toggle social media links display
- **GitHub URL**: Your GitHub profile URL
- **Instagram URL**: Your Instagram profile URL
- **Facebook URL**: Your Facebook page URL
- **Linktree URL**: Your Linktree URL
- **Shop URL**: Your online shop URL
- **Ko-Fi URL**: Your Ko-Fi support page URL

## Templates

### Home Page (`home.html`)
- Hero section with animated title
- Company description
- Social media links
- Terminal-style branding

### Regular Pages (`page.html`)
- Standard content pages (About, Services, etc.)
- List header styling
- Clean, readable layout

### Blog (`blog.html`)
- Blog post listings
- Post excerpts and dates
- Hover effects on post items

### Individual Posts (`post.html`)
- Full blog post display
- Post metadata (date, author, tags)
- Clean typography for readability

### Projects (`projects.html`)
- Project showcase listings
- Project descriptions and dates
- Similar styling to blog posts

### 404 Error Page (`404.html`)
- User-friendly error page
- Navigation back to site
- Consistent with theme design

## Customization

### CSS Variables
The theme uses CSS custom properties for easy color customization:

```css
:root {
  --color-accent: #00c767;
  --color-secondary: #02a002;
  --color-background: #252627;
  --color-surface: #2f2f2f;
  --color-text: #f8f8f8;
  --color-text-muted: #999;
  --color-border: #232323;
  --color-link: #80aadd;
  --color-link-hover: #a0caff;
}
```

### Adding Custom Styles
You can add custom CSS by editing the `assets/style.css` file or by using FearlessCMS's custom CSS feature.

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers

## Dependencies

- **Fira Mono Font**: Google Fonts (automatically loaded)
- **TypeIt**: For animated typing effects (CDN loaded)

## License

MIT License - feel free to use and modify as needed.

## Support

For theme support or customization requests, please contact Fearless Geek Media or open an issue in the theme repository.

## Changelog

### Version 1.0.0
- Initial release
- Terminal aesthetic design
- Responsive layout
- Blog and project templates
- Customizable theme options
- Social media integration 