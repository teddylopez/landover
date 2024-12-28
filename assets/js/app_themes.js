let methods = {};

methods.toggleTheme = function ($this) {
  $this.el.addEventListener('click', () => {
    const isDarkMode = document.documentElement.classList.contains('dark');
    document.documentElement.classList.toggle('dark', !isDarkMode);
    const newTheme = isDarkMode ? 'light' : 'dark';
    localStorage.setItem('theme', newTheme);
  });
}

methods.initialThemeCheck = function () {
  const userTheme = localStorage.getItem('theme') || 'dark';
  const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const prefersDarkMode = (userTheme === 'dark' || (!userTheme && systemTheme));
  document.documentElement.classList.toggle('dark', prefersDarkMode);
};

exports.methods = methods;
