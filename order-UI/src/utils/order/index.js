// 工具库
// 防抖函数
export const debounce = (fn, delay = 500) => {
  // 定义一个计时器
  let timer = null

  // 返回一个新的函数
  return function (...args) {
    // 如果有计时器，就清除计时器
    if (timer) {
      clearTimeout(timer)
    }
    // 重新设置计时器
    timer = setTimeout(() => {
      fn.apply(this, args)
    }, delay)
  }
}


export const OTHER_TYPE = [
  {
    value: '客户',
    label: '客户'
  },
  {
    value: '供应商',
    label: '供应商'
  },
]


// 客户 供应商 司机 员工 其他 己方公司 公共字典
export const PUBLIC_DICT_TYPE = {
  // 客户
  CUSTOMER: '客户',
  // 供应商
  SUPPLIER: '供应商',
  // 司机
  DRIVER: '司机',
  // 员工
  EMPLOYEE: '员工',
  // 其他
  OTHER: '其他',
  // 己方公司
  SELF_COMPANY: '己方公司',
}
