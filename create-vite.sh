# Creates a ready-to-go vite app including react, typescript, react-router, eslint, prettier, tailwindcss & git
# USAGE: create-vite <project-name>

# ---- INSTALL DEPS ----
npm create vite@latest $1 -- --template react-ts
cd $1
npm i react-router-dom
npm i -D tailwindcss postcss autoprefixer prettier prettier-plugin-tailwindcss eslint-config-prettier
npx tailwindcss init -p

# --- SCRIPTS ----
npx npm-add-script -k "pretty" -v "prettier --write ./src" -y

# ---- PROJECT CONFIG FILES ----
# update tailwind config
printf "/** @type {import('tailwindcss').Config} */
export default {
  content: [\"./index.html\", \"./src/**/*.{js,ts,jsx,tsx}\"],
  theme: {
    container: {
      center: true,
      padding: '1rem',
    },
    extend: {},
  },
  plugins: [],
};
" > tailwind.config.js

# add prettier config
printf "{
  \"singleQuote\": true,
  \"printWidth\": 100
}
" > .prettierrc

# add .eslintrc
printf "module.exports = {
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: { ecmaVersion: 'latest', sourceType: 'module' },
  plugins: ['react-refresh'],
  rules: {
    'react-refresh/only-export-components': 'warn',
  },
};
" > .eslintrc.cjs


# ---- SRC ----
cd src

# remove unused assets
rm ./index.css
rm ./App.css
rm -rf ./assets

# create styles/index.css
mkdir styles
printf "@tailwind base;
@tailwind components;
@tailwind utilities;
" > styles/index.css

# update main.tsx
printf "import React from 'react';
import ReactDOM from 'react-dom/client';
import { RouterProvider } from 'react-router-dom';
import { router } from './router';
import './styles/index.css';

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
" > main.tsx

# update App.tsx
printf "export const App = () => {
  return (
    <main className=\"container mt-8\">
      <h1 className=\"text-4xl font-bold\">Hello World</h1>
    </main>
  );
};
" > App.tsx

# add router.tsx
printf "import { createBrowserRouter } from 'react-router-dom';
import { App } from './App';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
  },
]);
" > router.tsx

# ---- GIT & OPEN ----
cd ..
git init
git add ./
git commit -m "Initial commit"
code .