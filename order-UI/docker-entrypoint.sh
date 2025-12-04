#!/bin/sh
set -e

# 获取本机IP地址
get_host_ip() {
    # 方法1: 尝试通过host.docker.internal获取（适用于Docker Desktop）
    if getent hosts host.docker.internal > /dev/null 2>&1; then
        HOST_IP=$(getent hosts host.docker.internal | awk '{print $1}')
        if [ -n "$HOST_IP" ]; then
            echo "$HOST_IP"
            return
        fi
    fi
    
    # 方法2: 通过默认网关获取主机IP（最可靠的方法）
    GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n 1)
    if [ -n "$GATEWAY" ]; then
        echo "$GATEWAY"
        return
    fi
    
    # 方法3: 获取第一个非回环IP
    HOST_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
    if [ -n "$HOST_IP" ] && [ "$HOST_IP" != "127.0.0.1" ]; then
        echo "$HOST_IP"
        return
    fi
    
    # 默认值
    echo "127.0.0.1"
}

# 如果未设置HOST_IP，自动获取
if [ -z "$HOST_IP" ]; then
    export HOST_IP=$(get_host_ip)
fi

# 设置默认端口（正式环境）
export BACKEND_PORT=${BACKEND_PORT:-30181}
export FRONTEND_PORT=${FRONTEND_PORT:-40085}

# 确保配置目录、日志目录和网站目录存在
mkdir -p /opt/front /opt/front/log /opt/front/html

# 设置网站根目录（如果挂载了外部目录则使用挂载的，否则使用镜像内的）
export FRONTEND_WEB_ROOT=${FRONTEND_WEB_ROOT:-/usr/share/nginx/html}

# 处理网站目录：
# 1. 如果 /opt/front/html 目录存在且不为空，使用挂载的目录
# 2. 如果 /opt/front/html 目录存在但为空，从镜像内复制文件到该目录
# 3. 否则使用镜像内的构建产物
if [ -d "/opt/front/html" ]; then
    if [ "$(ls -A /opt/front/html 2>/dev/null)" ]; then
        # 目录不为空，使用挂载的目录
        export FRONTEND_WEB_ROOT=/opt/front/html
        echo "✓ 使用挂载的网站目录: $FRONTEND_WEB_ROOT"
    elif [ -d "/usr/share/nginx/html" ] && [ "$(ls -A /usr/share/nginx/html 2>/dev/null)" ]; then
        # 目录为空，从镜像内复制文件（包括隐藏文件）
        echo "📦 挂载的网站目录为空，正在从镜像内复制文件..."
        cp -a /usr/share/nginx/html/. /opt/front/html/ 2>/dev/null || {
            # 如果 cp -a 失败，尝试使用 cp -r
            cp -r /usr/share/nginx/html/* /opt/front/html/ 2>/dev/null || true
        }
        export FRONTEND_WEB_ROOT=/opt/front/html
        echo "✓ 已复制文件到挂载目录: $FRONTEND_WEB_ROOT"
    else
        export FRONTEND_WEB_ROOT=/opt/front/html
        echo "⚠ 警告: 挂载目录为空且镜像内无文件，使用挂载目录: $FRONTEND_WEB_ROOT"
    fi
elif [ -d "/usr/share/nginx/html" ] && [ "$(ls -A /usr/share/nginx/html 2>/dev/null)" ]; then
    # 没有挂载 /opt/front/html，使用镜像内的目录
    export FRONTEND_WEB_ROOT=/usr/share/nginx/html
    echo "✓ 使用镜像内的网站目录: $FRONTEND_WEB_ROOT"
else
    echo "⚠ 警告: 未找到网站文件，请检查挂载或构建产物"
    export FRONTEND_WEB_ROOT=/usr/share/nginx/html
fi

# 如果挂载目录中没有配置文件，从镜像内复制默认配置
if [ ! -f /opt/front/nginx.conf.template ] && [ ! -f /opt/front/nginx.conf ]; then
    if [ -f /etc/nginx/templates/default.conf.template ]; then
        echo "挂载目录中没有配置文件，从镜像内复制默认配置到 /opt/front/nginx.conf.template"
        cp /etc/nginx/templates/default.conf.template /opt/front/nginx.conf.template
    fi
fi

# 输出配置信息（用于调试）
echo "=== Nginx配置信息 ==="
echo "主机IP: $HOST_IP"
echo "后端端口: $BACKEND_PORT"
echo "前端端口: $FRONTEND_PORT"
echo "网站根目录: $FRONTEND_WEB_ROOT"
echo "===================="

# 处理nginx配置模板（优先使用挂载的配置文件）
CONFIG_TEMPLATE=""
if [ -f /opt/front/nginx.conf.template ]; then
    CONFIG_TEMPLATE="/opt/front/nginx.conf.template"
    echo "使用挂载的配置文件: $CONFIG_TEMPLATE"
elif [ -f /opt/front/nginx.conf ]; then
    CONFIG_TEMPLATE="/opt/front/nginx.conf"
    echo "使用挂载的配置文件: $CONFIG_TEMPLATE"
elif [ -f /etc/nginx/templates/default.conf.template ]; then
    CONFIG_TEMPLATE="/etc/nginx/templates/default.conf.template"
    echo "使用默认配置文件: $CONFIG_TEMPLATE"
fi

# 如果找到配置文件模板，则处理环境变量替换
if [ -n "$CONFIG_TEMPLATE" ]; then
    envsubst '${HOST_IP} ${BACKEND_PORT} ${FRONTEND_PORT} ${FRONTEND_WEB_ROOT}' < "$CONFIG_TEMPLATE" > /etc/nginx/conf.d/default.conf
    echo "配置文件已生成: /etc/nginx/conf.d/default.conf"
    echo "网站根目录: $FRONTEND_WEB_ROOT"
else
    echo "警告: 未找到nginx配置文件模板"
fi

# 执行传入的命令（通常是nginx启动命令）
exec "$@"

