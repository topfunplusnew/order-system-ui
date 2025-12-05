#!/bin/sh
set -e

# 1. 设置环境变量
# 获取主机IP（如果未设置）
if [ -z "$HOST_IP" ]; then
    HOST_IP=$(ip route | grep default | awk '{print $3}' | head -n 1)
    [ -z "$HOST_IP" ] && HOST_IP="127.0.0.1"
fi
export HOST_IP

# 设置默认端口
export BACKEND_PORT=${BACKEND_PORT:-30181}
export FRONTEND_PORT=${FRONTEND_PORT:-40085}

# 2. 处理网站根目录
# 如果挂载了 /opt/front/html 但目录为空，从镜像内复制文件
if [ -d "/opt/front/html" ] && [ ! "$(ls -A /opt/front/html 2>/dev/null)" ]; then
    if [ -d "/usr/share/nginx/html" ] && [ "$(ls -A /usr/share/nginx/html 2>/dev/null)" ]; then
        echo "📦 挂载目录为空，正在从镜像内复制文件..."
        cp -a /usr/share/nginx/html/. /opt/front/html/ 2>/dev/null || \
        cp -r /usr/share/nginx/html/* /opt/front/html/ 2>/dev/null || true
        echo "✓ 文件已复制到挂载目录"
    fi
fi

# 确定网站根目录：优先使用环境变量，否则使用挂载目录，最后使用默认
if [ -n "$FRONTEND_WEB_ROOT" ]; then
    WEB_ROOT="$FRONTEND_WEB_ROOT"
elif [ -d "/opt/front/html" ] && [ "$(ls -A /opt/front/html 2>/dev/null)" ]; then
    WEB_ROOT="/opt/front/html"
else
    WEB_ROOT="/usr/share/nginx/html"
fi
export FRONTEND_WEB_ROOT="$WEB_ROOT"

# 3. 创建必要的目录
mkdir -p /opt/front/log

# 4. 找到配置文件模板
CONFIG_TEMPLATE=""
if [ -f /opt/front/nginx.conf.template ]; then
    CONFIG_TEMPLATE="/opt/front/nginx.conf.template"
elif [ -f /opt/front/nginx.conf ]; then
    CONFIG_TEMPLATE="/opt/front/nginx.conf"
elif [ -f /etc/nginx/templates/default.conf.template ]; then
    CONFIG_TEMPLATE="/etc/nginx/templates/default.conf.template"
fi

# 5. 生成nginx配置文件
if [ -n "$CONFIG_TEMPLATE" ]; then
    echo "使用配置文件模板: $CONFIG_TEMPLATE"
    
    # 使用 sed 替换变量（使用 | 作为分隔符避免路径中的 / 冲突）
    # 先处理带默认值的语法 ${VAR:-default}，再处理普通变量 ${VAR}
    sed -e "s|\${FRONTEND_WEB_ROOT:-[^}]*}|${FRONTEND_WEB_ROOT}|g" \
        -e "s|\${HOST_IP:-[^}]*}|${HOST_IP}|g" \
        -e "s|\${BACKEND_PORT:-[^}]*}|${BACKEND_PORT}|g" \
        -e "s|\${FRONTEND_PORT:-[^}]*}|${FRONTEND_PORT}|g" \
        -e "s|\${HOST_IP}|${HOST_IP}|g" \
        -e "s|\${BACKEND_PORT}|${BACKEND_PORT}|g" \
        -e "s|\${FRONTEND_PORT}|${FRONTEND_PORT}|g" \
        -e "s|\${FRONTEND_WEB_ROOT}|${FRONTEND_WEB_ROOT}|g" \
        "$CONFIG_TEMPLATE" > /etc/nginx/conf.d/default.conf
    
    # 验证替换结果
    if grep -q '\${' /etc/nginx/conf.d/default.conf; then
        echo "⚠ 警告: 配置文件中仍有未替换的变量"
        grep '\${' /etc/nginx/conf.d/default.conf || true
    fi
    
    echo "✓ Nginx配置已生成: /etc/nginx/conf.d/default.conf"
    echo "  主机IP: $HOST_IP"
    echo "  后端端口: $BACKEND_PORT"
    echo "  前端端口: $FRONTEND_PORT"
    echo "  网站根目录: $FRONTEND_WEB_ROOT"
else
    echo "⚠ 警告: 未找到nginx配置文件模板"
fi

# 6. 启动nginx
exec "$@"
