export var methods = {}

const requireModule = require.context('../../../../api/system', false, /\.js$/);

// 遍历文件
requireModule.keys().forEach(fileName => {

  const module = requireModule(fileName);

  // 提取文件名（去掉路径和扩展名）
  const fileNameOnly = fileName.replace(/^.*[\\/]/, '').replace(/\.js$/, '');

  // 报表相关的文件不需要加载方法
  if (fileNameOnly !== 'statement') {
    // 筛选出以 list 开头的方法
    Object.keys(module).forEach(key => {

      // 仅添加以 list 开头且为函数的方法 并且保证拿到的方法是存在的
      if (key.startsWith('get') && typeof module[key] === 'function') {
        methods[key] = module[key]
      }

    });
  }
});


console.log(methods)

