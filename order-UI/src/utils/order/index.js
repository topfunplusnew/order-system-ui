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

// 使用防抖
// const debounceFn = debounce(() => {
//   console.log('防抖')
// }, 1000)


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
