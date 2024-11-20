export var mixin_excel_server = {
  methods: {
    // 将读取的数据存储到vuex中
    handleStoreExcel() {
      // 把读取的tableData存储到vuex中
      this.$store.dispatch('excel/setExcelData', this.tableData)
    },
    // 清除读取的数据
    handleClearExcel() {
      this.$store.dispatch('excel/clearExcelData')
    },
    // 读取excel存储的数据
    handleReadExcel() {
      return this.$store.getters.excelData
    },

    // 对暂存数据进行维护
    handleStoreTempData(value) {
      this.$store.dispatch('excel/setTempData', value)
    },
    // 清除暂存数据
    handleClearTempData() {
      this.$store.dispatch('excel/clearTempData')
    },
  }
}
