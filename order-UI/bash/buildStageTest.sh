#!/bin/bash

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 回到项目根目录 (相对路径: 从 bash/ 到项目根)
cd ..

# 安装依赖
npm install --progress=false  --legacy-peer-deps

# 构建项目
npm run build

# 打包完成后输出提示
echo "项目已成功构建并打包！"
