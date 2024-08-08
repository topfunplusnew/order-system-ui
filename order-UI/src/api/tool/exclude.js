//将form中的字段赋值为空
export function excludeParams(target, params) {
  console.log(params)
  params.forEach(item => {
    target[item] = null;
  })
  return target;
}
