// const appThemeHooks = require('./app_themes')
const animationHooks = require('./animations')

let Hooks = {};

Hooks.TypeIt = {
  mounted() {
    animationHooks.methods.typeit(this);
  },
}

exports.hooks = Hooks;
