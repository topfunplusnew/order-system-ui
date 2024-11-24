import { methods } from './methods';

export function getMapperMethod(mapper) {

  // 根据字符串匹配对应方法 忽略大小写
  for (const key in methods) {

    if (key.toLowerCase().includes(mapper.toLowerCase())) {

      return methods[key]
    }
  }
}
