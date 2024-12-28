const appThemeHooks = require('./app_themes')

let Hooks = {};

/* Set app themes */
Hooks.AppThemes = {
  mounted() {
    appThemeHooks.methods.initialThemeCheck();
    appThemeHooks.methods.toggleTheme(this);
  },
}

exports.hooks = Hooks;
