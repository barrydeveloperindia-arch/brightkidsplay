/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        // Englabs Brand Palette
        englabs: {
          blue: '#0056D2', // Primary Action (Deep Industrial Blue)
          green: '#008A45', // Success / Complete
          red: '#D92D20',   // Error / Stop
          grey: {
            900: '#1A1A1A', // Primary Text (High Contrast)
            700: '#4A4A4A', // Secondary Text
            500: '#9AA0A6', // Disabled / Hints
            100: '#F5F7FA', // Secondary Backgrounds (Sidebar/Cards)
            50: '#F8F9FA',  // Subtle hovers
          },
          white: '#FFFFFF', // Primary Background (Canvas)
        }
      },
      fontFamily: {
        sans: ['Inter', 'Roboto', 'sans-serif'], // High-legibility industrial standard
      },
      boxShadow: {
        // Minimalist elevation for cards (floating look)
        'englabs-card': '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
        'englabs-floating': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
      },
      spacing: {
        '128': '32rem', // for wide Gantt charts
        '144': '36rem',
      }
    },
  },
  plugins: [],
}
