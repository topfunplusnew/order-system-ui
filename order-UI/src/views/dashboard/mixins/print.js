//混入
export var mixin_printHTML = {
  data: function () {

  },
  methods: {
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'],
      })
    },
  }
}
