# 多阶段构建 Dockerfile
# 第一阶段：构建阶段
FROM node:18.20.6-alpine AS builder

# 设置工作目录
WORKDIR /app

ENV YARN_CACHE_FOLDER=/app/.yarn-cache
RUN npm config set registry https://mirrors.cloud.tencent.com/npm/

# 安装yarn（如果基础镜像没有）
RUN if ! command -v yarn > /dev/null; then npm install -g yarn; fi

# 复制package.json和yarn.lock文件（用于依赖缓存）
COPY package.json yarn.lock ./
COPY packages/order-system/package.json ./packages/order-system/

# 安装依赖（使用缓存）
RUN yarn install-order

# 复制所有源代码
COPY . .

# 构建项目
RUN yarn build

# 第二阶段：生产阶段 - 使用Nginx提供静态文件服务
FROM nginx:alpine

# 设置维护者信息
LABEL maintainer="0434实验室"
LABEL description="订单管理系统前端"

# 复制构建产物到nginx目录
COPY --from=builder /app/packages/order-system/dist /usr/share/nginx/html

# 复制nginx配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 40085

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]

