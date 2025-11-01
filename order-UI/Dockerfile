# 多阶段构建 Dockerfile
# 第一阶段：构建阶段
FROM node:18.20.6-alpine AS builder

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV NODE_ENV=production
ENV YARN_CACHE_FOLDER=/app/.yarn-cache

# 安装yarn（如果基础镜像没有）
RUN npm install -g yarn

# 复制package.json和yarn.lock文件（用于依赖缓存）
COPY package.json yarn.lock ./
COPY packages/order-system/package.json ./packages/order-system/

# 安装依赖（使用缓存）
RUN yarn install --frozen-lockfile --ignore-engines --cache-folder $YARN_CACHE_FOLDER

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

# 复制nginx配置文件（如果需要自定义配置）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 创建自定义nginx配置文件
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    # Gzip压缩配置 \
    gzip on; \
    gzip_vary on; \
    gzip_min_length 1024; \
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json; \
    \
    # 前端路由支持（Vue Router history模式） \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    \
    # 静态资源缓存配置 \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
    } \
    \
    # 安全头配置 \
    add_header X-Frame-Options "SAMEORIGIN" always; \
    add_header X-Content-Type-Options "nosniff" always; \
    add_header X-XSS-Protection "1; mode=block" always; \
}' > /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]

