import Vue from 'vue'

import Cookies from 'js-cookie'

import Element, { Loading } from 'element-ui'
import './assets/styles/element-variables.scss'
import './element-variables.scss'

import { getConfigKey } from '@/api/system/config'
import { getDicts } from '@/api/system/dict/data'
import '@/assets/styles/index.scss' // global css
import '@/assets/styles/ruoyi.scss' // ruoyi css
import { download } from '@/utils/request'
import {
  addDateRange,
  handleTree,
  parseTime,
  resetForm,
  selectDictLabel,
  selectDictLabels
} from '@/utils/ruoyi'
import App from './App.vue'
import './assets/icons' // icon
import directive from './directive' // directive
import './permission' // permission control
import plugins from './plugins' // plugins
import router from './router'
import store from './store'
// 分页组件
import Pagination from '@/components/Pagination'
// 自定义表格工具组件
import RightToolbar from '@/components/RightToolbar'
// 富文本组件
import Editor from '@/components/Editor'
// 文件上传组件
import FileUpload from '@/components/FileUpload'
// 图片上传组件
import ImageUpload from '@/components/ImageUpload'
// 图片预览组件
import ImagePreview from '@/components/ImagePreview'
// 字典标签组件
import DictTag from '@/components/DictTag'
// 头部标签组件
import VueMeta from 'vue-meta'
// 字典数据组件
import DictData from '@/components/DictData'
// 引入表格横向滚动插件
import horizontalScroll from 'el-table-horizontal-scroll'
// 打印
import print from 'print-js'
import 'print-js/dist/print.css'
// 表单生成器
import VForm from 'vform-builds' // 引入VForm库
import 'vform-builds/dist/VFormDesigner.css' // 引入VForm样式
import service from './utils/request'

// 虚拟滚动
import VueVirtualScroller from 'vue-virtual-scroller'
import 'vue-virtual-scroller/dist/vue-virtual-scroller.css'

Vue.use(VueVirtualScroller)

window.axios = service
Vue.prototype.getDicts = getDicts
Vue.prototype.getConfigKey = getConfigKey
Vue.prototype.parseTime = parseTime
Vue.prototype.resetForm = resetForm
Vue.prototype.addDateRange = addDateRange
// Vue.prototype.adDateRange = adDateRange

Vue.prototype.selectDictLabel = selectDictLabel
Vue.prototype.selectDictLabels = selectDictLabels
Vue.prototype.download = download
Vue.prototype.handleTree = handleTree
Vue.prototype.$print = print

// todo 以下是自己封装的一些常用的繁琐操作函数
// 1.需要排除的字段信息
// 使用: this.form = excludeParams(this.form, this.$exclude)  api/tool/exclude.js
Vue.prototype.$exclude = [
  'addtime',
  'userId',
  'UserName',
  'delFlag',
  'submitflag',
  'cancelFlag',
  'createBy',
  'createTime',
  'updateBy',
  'updateTime',
  'isedit',
  'userName'
]
Vue.prototype.$excludeWithUpdate = [
  'addtime',
  'userId',
  'delFlag',
  'id',
  'orderDetailList',
  'goodsOrderID',
  'ordersNo',
  'customerID',
  'checkUserId',
  'checkState',
  'isAdjust',
  'adjustDate',
  'isAdjusted',
  'adjustOrderid',
  'receiveProof',
  'paymentState',
  'invoiceState',
  'customerIsInvoice',
  'isSupplierInvoice',
  'orderDateEnd',
  'orderDateStart',
  'landCarID',
  'seaCarID',
  'path',
  'submitflag',
  'cancelFlag',
  'createBy',
  'createTime',
  'updateBy',
  'isedit'
]
Vue.prototype.$imgs = ['png', 'jpg', 'jpeg', 'bmp', 'gif', 'webp']
// 2.挂载加载中动态效果
// 使用: 数据加载前:this.$wait()  数据加载后:this.$close()
Vue.prototype.$wait = () => {
  Loading.service({
    fullscreen: true,
    text: '正在加载中，请稍后...'
  })
}
// 结束加载
Vue.prototype.$close = () => {
  Loading.service({}).close()
}

// 3.时间范围查询方法
// targetList: 需要筛选的数组
// targetProperty: 需要筛选的时间字段
// return 筛选后的数组
// 使用: this.$dateRange(this, this.bankList, 'createTime', this.timesQuery.startTime,this.timesQuery.endTime)
Vue.prototype.$dateRange = function (
  _this,
  targetList,
  targetProperty,
  startTime,
  endTime
) {
  // 开始时间 结束时间的时间戳
  const start = new Date(startTime).getTime()
  const end_date = new Date(endTime)
  end_date.setDate(end_date.getDate() + 1)
  const end = end_date.getTime()

  // 校验
  if (startTime === '' || endTime === '') {
    this.$message.error('开始时间或结束时间不能为空!')
    return _this[targetList]
  } else if (start > end) {
    this.$message.error('开始时间不能大于结束时间!')
    return _this[targetList]
  } else {
    // 筛选
    return _this[targetList].filter((item) => {
      const target = new Date(Number(item[targetProperty])).getTime()
      return target >= start && target <= end
    })
  }
}

import DatePickerDialog from './views/dashboard/components/common/DatePickerDialog.vue'

Vue.prototype.$datePicker = function () {
  return new Promise((resolve) => {
    const DatePickerConstructor = Vue.extend(DatePickerDialog)
    const datePickerInstance = new DatePickerConstructor({
      propsData: { resolve }
    })

    // 手动挂载到 DOM 上
    datePickerInstance.$mount()
    document.body.appendChild(datePickerInstance.$el)

    // 显示弹框
    datePickerInstance.show()

    // 捕获关闭事件
    datePickerInstance.$on('resolve', (data) => {
      resolve(data) // 处理日期选择
    })
  })
}
export const isNull = (val) => {
  return !val ? '暂无' : val
}

// 全局组件挂载
Vue.component('DictTag', DictTag)
Vue.component('Pagination', Pagination)
Vue.component('RightToolbar', RightToolbar)
Vue.component('Editor', Editor)
Vue.component('FileUpload', FileUpload)
Vue.component('ImageUpload', ImageUpload)
Vue.component('ImagePreview', ImagePreview)
Vue.use(directive)
Vue.use(plugins)
Vue.use(VueMeta)
// 引入表格横向滚动插件
Vue.use(horizontalScroll)
DictData.install()
Vue.use(Element, {
  size: Cookies.get('size') || 'medium' // set element-ui default size
})
// 表单生成器
Vue.use(VForm)

Vue.config.productionTip = false

// 创建vm 挂载全局事件总线
new Vue({
  el: '#app',
  router,
  store,
  beforeCreate() {
    Vue.prototype.$bus = this
  },
  render: (h) => h(App)
})
