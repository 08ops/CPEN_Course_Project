import type { Config } from 'tailwindcss';

/**
 * The palette is built around the University of Ghana colours: a deep navy
 * with a gold accent, on a warm neutral background.
 */
const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        navy: {
          50: '#eef2f9',
          100: '#d8e1f0',
          200: '#b3c3e1',
          300: '#8099cb',
          400: '#4c6bb0',
          500: '#2c4a93',
          600: '#1e3576',
          700: '#182a5e',
          800: '#132145',
          900: '#0d1730',
          950: '#070d1c',
        },
        gold: {
          50: '#fffaeb',
          100: '#fdf0c8',
          200: '#fbe08d',
          300: '#f9c94f',
          400: '#f7b32b',
          500: '#e19312',
          600: '#bd6d0c',
          700: '#974d0f',
          800: '#7c3c13',
          900: '#693213',
        },
      },
      fontFamily: {
        sans: ['var(--font-geist-sans)', 'system-ui', 'sans-serif'],
        mono: ['var(--font-geist-mono)', 'ui-monospace', 'monospace'],
      },
      boxShadow: {
        card: '0 1px 2px rgb(16 24 40 / 0.06), 0 1px 3px rgb(16 24 40 / 0.10)',
        lift: '0 4px 6px -1px rgb(16 24 40 / 0.08), 0 2px 4px -2px rgb(16 24 40 / 0.06)',
      },
    },
  },
  plugins: [],
};

export default config;
