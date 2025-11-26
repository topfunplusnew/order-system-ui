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
# 复制所有工作区包的package.json（yarn workspaces需要这些文件来识别本地包）
COPY packages/order-system/package.json ./packages/order-system/
COPY packages/config/package.json ./packages/config/
COPY packages/shared/package.json ./packages/shared/
COPY packages/ui-components/package.json ./packages/ui-components/

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

# 安装gettext（包含envsubst工具）和iproute2（用于获取IP）
RUN apk add --no-cache gettext iproute2

# 复制构建产物到nginx目录
COPY --from=builder /app/packages/order-system/dist /usr/share/nginx/html

# 创建配置目录和日志目录
RUN mkdir -p /opt/front /opt/front/log

# 复制nginx配置文件模板到/opt/front（支持挂载覆盖）
COPY nginx.conf /opt/front/nginx.conf.template
# 同时保留默认位置作为后备
COPY nginx.conf /etc/nginx/templates/default.conf.template

# 复制启动脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# 暴露端口（默认正式环境端口，实际由环境变量控制）
EXPOSE 40085 40081

# 启动脚本
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

