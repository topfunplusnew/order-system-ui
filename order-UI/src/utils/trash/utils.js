//获取UUID
export function getUuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}


export function findFileExtension(filename) {
  // 使用lastIndexOf找到最后一个'.'的位置
  const index = filename.lastIndexOf('.');
  // 如果没有找到'.'，则没有后缀名
  if (index === -1) {
    return '';
  }
  // 返回'.'后面的字符串作为后缀名
  return filename.substring(index + 1);
}
