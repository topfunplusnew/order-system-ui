# 使用官方 Node.js 18 LTS 作为基础镜像
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json（如果存在）
COPY package*.json ./

# 安装依赖
# 如果有 package-lock.json 则使用 npm ci，否则使用 npm install
RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev && npm cache clean --force; \
    else \
      npm install --omit=dev && npm cache clean --force; \
    fi

# 生产阶段
FROM node:18-alpine

# 创建非 root 用户
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 设置工作目录
WORKDIR /app

# 从构建阶段复制 node_modules 和 package.json
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

# 复制源代码
COPY src ./src

# 创建日志目录并设置权限
RUN mkdir -p /app/logs && \
    chown -R nodejs:nodejs /app

# 切换到非 root 用户
USER nodejs

# 暴露端口（可通过环境变量 LOGGER_PORT 修改）
EXPOSE 3001

# 设置环境变量
ENV NODE_ENV=production
ENV LOGGER_PORT=3001
ENV LOGGER_HOST=0.0.0.0

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# 启动应用
CMD ["node", "src/index.js"]

