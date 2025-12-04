// 简单测试脚本：直接运行 node test_getDateRangeDays.js 来验证 getDateRangeDays
// 该脚本会分别测试：
// 1) 传入具体天数（同步路径）
// 2) 不传 days 时依赖配置（需要后端接口或 mock）
// 3) 配置为 N 时返回 null

// 说明：本脚本直接引用项目工具方法。请在项目根以 node 环境运行（需支持 import/ESM 或用 babel/register）；
// 为简单起见，我们使用动态 import，并捕获结果。

const { spawn } = require('child_process');
const path = require('path');

const mjsPath = path.resolve(__dirname, './test_getDateRangeDays.mjs');

const node = process.execPath;
const child = spawn(node, [mjsPath], { stdio: 'inherit' });

child.on('close', code => {
	process.exit(code);
});
