// Datei: `docs/docusaurus.config.ts`
// Anpassung: GitHub Pages-Infos und Navbar für Utilities/Downloads/Login
import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
    title: 'CHRONOS',
    tagline: '',
    //favicon: 'img/favicon_dark.ico',
    stylesheets: [
        {
          href: 'img/favicon.ico',
          rel: 'icon',
          type: 'image/x-icon',
          media: '(prefers-color-scheme: light)',
        },
        {
          href: 'img/favicon_dark.ico',
          rel: 'icon',
          type: 'image/x-icon',
          media: '(prefers-color-scheme: dark)',
        },
    ],
    future: { v4: true },
    url: 'https://Fb14n.github.io',
    baseUrl: '/',
    organizationName: 'Fb14n',
    projectName: 'shift_schedule',
    onBrokenLinks: 'throw',
    i18n: { defaultLocale: 'en', locales: ['en','de'] },
    presets: [
        [
            'classic',
            {
                docs: {
                    sidebarPath: './sidebars.ts',
                },
                blog: { showReadingTime: true },
                theme: { customCss: './src/css/custom.css' },
            } satisfies Preset.Options,
        ],
    ],
    themeConfig: {
        image: 'img/docusaurus-social-card.jpg',

        colorMode: { respectPrefersColorScheme: true },
        navbar: {
            logo: { alt: 'Logo', src: 'img/logo_vertical.svg', srcDark: 'img/logo_vertical_dark.svg' },
            items: [
                { type: 'docSidebar', sidebarId: 'tutorialSidebar', position: 'left', label: 'Tutorial' },
                { to: '/docs/downloads', label: 'Download', position: 'left' },
                { to: '/login', label: 'Login', position: 'right' },
            ],
        },
        footer: { style: 'dark', links: [], copyright: `Copyright © ${new Date().getFullYear()} Fabian Berger` },
        prism: { theme: prismThemes.github, darkTheme: prismThemes.dracula },
    } satisfies Preset.ThemeConfig,
};

export default config;