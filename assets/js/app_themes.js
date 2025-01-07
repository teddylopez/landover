const sunIcon = document.querySelector('.sun-selector');
const moonIcon = document.querySelector('.moon-selector');
const userTheme = localStorage.getItem('theme') || '';
const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches;

const toggleTheme = () => {
  const isDarkMode = document.documentElement.classList.contains('dark');
  document.documentElement.classList.toggle('dark', !isDarkMode);
  const newTheme = isDarkMode ? 'light' : 'dark';
  localStorage.setItem('theme', newTheme);
};

sunIcon.addEventListener('click', toggleTheme);
moonIcon.addEventListener('click', toggleTheme);

const initialThemeCheck = () => {  const prefersDarkMode = (userTheme === 'dark' || (!userTheme && systemTheme));
  document.documentElement.classList.toggle('dark', prefersDarkMode);
};

initialThemeCheck();
