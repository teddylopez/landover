const appThemeHooks = require('./app_themes')
const animationHooks = require('./animations')

let Hooks = {};

/* Set app themes */
Hooks.AppThemes = {
  mounted() {
    appThemeHooks.methods.initialThemeCheck();
    appThemeHooks.methods.toggleTheme(this);
  },
}

Hooks.TypeIt = {
  mounted() {
    animationHooks.methods.typeit(this);
  },
}

exports.hooks = Hooks;
