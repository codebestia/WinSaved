/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      backgroundImage: {
        'custom-radial':
          'radial-gradient(circle at 25% 40%, #02C0FF 0%, #001F40 40%, transparent 80%), radial-gradient(circle at 75% 75%, #02C0FF 0%, #001F40 25%, #020a1dde 60%)',
        'hero-semi-circle':
          'radial-gradient(circle at center bottom, #043451 30%, #043451 40%, transparent 75%)',
      },
      animation: {
        'slow-bounce': 'bounce 2s infinite',
      },
      keyframes: {
        bounce: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
    },
  },
  plugins: [],
}
