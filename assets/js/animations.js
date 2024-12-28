let methods = {};

methods.typeit = function ($this) {
  new TypeIt($this.el, {
    strings: $this.el.dataset.typeitText,
    speed: 40,
    cursor: false,
    waitUntilVisible: true,
  }).go();
}

exports.methods = methods;
