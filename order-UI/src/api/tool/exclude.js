export function excludeParams(target, ...params) {
  params.forEach(item => {
    target[item] = null;
  })
}
