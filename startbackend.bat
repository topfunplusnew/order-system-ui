	
@echo off
chcp 65001 >nul
echo ============================================
echo 订单系统 Docker 一键启动脚本 
echo ============================================
echo.

REM ==================== 配置参数 ====================
REM 订单系统配置
set DOCKER_REGISTRY=docker.nexus.ixuni.win
set IMAGE_NAME=docker/order-system-production
set IMAGE_TAG=latest
set CONTAINER_NAME=order-system-prod251024
set NETWORK_NAME=1panel-network

REM 数据存储路径
set DATA_ROOT=D:\order-system\Docker\orderData

REM MySQL 配置
set MYSQL_CONTAINER=mysql
set MYSQL_VERSION=8.4.7
set MYSQL_PORT=3306
set MYSQL_ROOT_PASSWORD=orderrootpwd
set MYSQL_DATABASE=order_prod251024

REM Redis 配置
set REDIS_CONTAINER=redis
set REDIS_VERSION=8.2.2
set REDIS_PORT=6379
set REDIS_PASSWORD=orderredis

REM RabbitMQ 配置
set RABBITMQ_CONTAINER=rabbitmq
set RABBITMQ_VERSION=4.1.4-management-alpine
set RABBITMQ_PORT=5672
set RABBITMQ_MANAGEMENT_PORT=15672
set RABBITMQ_USER=rabbitmq
set RABBITMQ_PASSWORD=rabbitmq

REM Nginx 配置
set NGINX_CONTAINER=nginx
set NGINX_VERSION=latest
set NGINX_PORT=40085
REM ==================================================

echo [步骤 1/9] 清理旧的容器...
docker stop %CONTAINER_NAME% %NGINX_CONTAINER% %MYSQL_CONTAINER% %REDIS_CONTAINER% %RABBITMQ_CONTAINER% >nul 2>&1
docker rm %CONTAINER_NAME% %NGINX_CONTAINER% %MYSQL_CONTAINER% %REDIS_CONTAINER% %RABBITMQ_CONTAINER% >nul 2>&1
echo [✓] 旧容器已全部清理
echo.

echo [步骤 2/9] 创建 Docker 网络
docker network inspect %NETWORK_NAME% >nul 2>&1
if errorlevel 1 (
    docker network create %NETWORK_NAME%
    echo [✓] 网络 %NETWORK_NAME% 已创建
) else (
    echo [✓] 网络 %NETWORK_NAME% 已存在
)
echo.

echo [步骤 3/9] 启动 MySQL 容器
echo 创建并启动 MySQL 容器...
docker run -d ^
  --name %MYSQL_CONTAINER% ^
  --network %NETWORK_NAME% ^
  -p %MYSQL_PORT%:3306 ^
  -v "%DATA_ROOT%\mysql\data:/var/lib/mysql" ^
  -v "%DATA_ROOT%\mysql\log:/var/log/mysql" ^
  -e MYSQL_ROOT_PASSWORD=%MYSQL_ROOT_PASSWORD% ^
  -e TZ=Asia/Shanghai ^
  --restart always ^
  mysql:%MYSQL_VERSION% --default-time-zone=+08:00

if errorlevel 1 (
    echo [错误] MySQL 容器启动失败！
    pause
    exit /b 1
)
echo [✓] MySQL 容器已创建并启动
echo 等待 MySQL 初始化...
timeout /t 10 /nobreak >nul
echo.

echo [步骤 4/9] 创建数据库
docker exec %MYSQL_CONTAINER% mysql -uroot -p%MYSQL_ROOT_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS %MYSQL_DATABASE% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
echo [✓] 数据库 %MYSQL_DATABASE% 已就绪
echo.

echo [步骤 5/9] 启动 Redis 容器
echo 创建并启动 Redis 容器...
docker run -d ^
  --name %REDIS_CONTAINER% ^
  --network %NETWORK_NAME% ^
  -p %REDIS_PORT%:6379 ^
  -v "%DATA_ROOT%\redis\data:/data" ^
  -v "%DATA_ROOT%\redis\logs:/logs" ^
  -v "%DATA_ROOT%\redis\conf\redis.conf:/usr/local/etc/redis/redis.conf" ^
  -e TZ=Asia/Shanghai ^
  --restart always ^
  redis:%REDIS_VERSION% redis-server /usr/local/etc/redis/redis.conf --requirepass "%REDIS_PASSWORD%"

if errorlevel 1 (
    echo [错误] Redis 容器启动失败！
    pause
    exit /b 1
)
echo [✓] Redis 容器已创建并启动
timeout /t 3 /nobreak >nul
echo.

echo [步骤 6/9] 启动 RabbitMQ 容器
echo 创建并启动 RabbitMQ 容器...
docker run -d ^
  --name %RABBITMQ_CONTAINER% ^
  --hostname %RABBITMQ_CONTAINER% ^
  --network %NETWORK_NAME% ^
  -p %RABBITMQ_PORT%:5672 ^
  -p %RABBITMQ_MANAGEMENT_PORT%:15672 ^
  -v "%DATA_ROOT%\rabbitmq\data:/var/lib/rabbitmq" ^
  -v "%DATA_ROOT%\rabbitmq\log:/var/log/rabbitmq" ^
  -e RABBITMQ_DEFAULT_USER=%RABBITMQ_USER% ^
  -e RABBITMQ_DEFAULT_PASS=%RABBITMQ_PASSWORD% ^
  -e TZ=Asia/Shanghai ^
  --restart always ^
  rabbitmq:%RABBITMQ_VERSION%

if errorlevel 1 (
    echo [错误] RabbitMQ 容器启动失败！
    pause
    exit /b 1
)
echo [✓] RabbitMQ 容器已创建并启动
timeout /t 5 /nobreak >nul
echo.

echo [步骤 7/9] 登录 Docker 私有仓库并拉取订单系统镜像
echo.
set /p DOCKER_USERNAME="请输入 Docker 用户名: "
set /p DOCKER_PASSWORD="请输入 Docker 密码: "
echo.

echo 正在登录到 %DOCKER_REGISTRY%...
docker login %DOCKER_REGISTRY% -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%
if errorlevel 1 (
    echo [错误] Docker 登录失败！请检查用户名和密码。
    pause
    exit /b 1
)
echo [✓] Docker 登录成功
echo.

echo 正在拉取最新的订单系统镜像 (%IMAGE_TAG%)...
docker pull %DOCKER_REGISTRY%/%IMAGE_NAME%:%IMAGE_TAG%
if errorlevel 1 (
    echo [错误] 镜像拉取失败！
    pause
    exit /b 1
)
echo [✓] 镜像拉取完成
echo.

echo [步骤 8/9] 启动订单系统容器
docker run -d ^
  --name %CONTAINER_NAME% ^
  --network %NETWORK_NAME% ^
  --restart unless-stopped ^
  -p 8080:8080 ^
  -e TZ=Asia/Shanghai ^
  -e DB_CONNECT_TIMEOUT=30000 ^
  -e DB_EVICTION_RUN_MILLIS=60000 ^
  -e DB_HOST=%MYSQL_CONTAINER% ^
  -e DB_MAX_EVICTABLE_IDLE_MILLIS=900000 ^
  -e DB_MIN_EVICTABLE_IDLE_MILLIS=300000 ^
  -e DB_NAME=%MYSQL_DATABASE% ^
  -e DB_POOL_INITIAL_SIZE=5 ^
  -e DB_POOL_MAX_ACTIVE=20 ^
  -e DB_POOL_MAX_WAIT=60000 ^
  -e DB_POOL_MIN_IDLE=10 ^
  -e DB_PORT=3306 ^
  -e DB_SLAVE_ENABLED=false ^
  -e DB_SLOW_SQL_MILLIS=1000 ^
  -e DB_SOCKET_TIMEOUT=60000 ^
  -e DRUID_STAT_VIEW_ENABLED=true ^
  -e JAVA_OPTS="-server -Xmx1g -Xms512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 --add-opens java.base/sun.reflect.annotation=ALL-UNNAMED --add-opens java.base/java.lang.invoke=ALL-UNNAMED -XX:ReservedCodeCacheSize=512m" ^
  -e LOG_LEVEL_DZU=info ^
  -e LOG_LEVEL_ROOT=info ^
  -e LOG_LEVEL_SPRING=warn ^
  -e ORDER_EXPORT_PATH=/app/exportPath ^
  -e ORDER_FIXED_TIME=10080 ^
  -e ORDER_FIXED_TIME_ADJUST=20160 ^
  -e ORDER_FIXED_TIME_ORDER=10080 ^
  -e ORDER_MQ_ENV_PREFIX=order-prod251014 ^
  -e ORDER_MQ_VERSION_SUFFIX=v1 ^
  -e ORDER_TEMP_PATH=/app/tempExport ^
  -e ORDER_UPLOAD_PATH=/app/uploadPath ^
  -e RABBITMQ_HOST=%RABBITMQ_CONTAINER% ^
  -e RABBITMQ_PORT=5672 ^
  -e RABBITMQ_VIRTUAL_HOST=/ ^
  -e REDIS_DATABASE=11 ^
  -e REDIS_HOST=%REDIS_CONTAINER% ^
  -e REDIS_POOL_MAX_ACTIVE=8 ^
  -e REDIS_POOL_MAX_IDLE=8 ^
  -e REDIS_POOL_MAX_WAIT=-1 ^
  -e REDIS_POOL_MIN_IDLE=0 ^
  -e REDIS_PORT=6379 ^
  -e REDIS_TIMEOUT=0 ^
  -e SERVER_CONTEXT_PATH=/ ^
  -e SERVER_PORT=8080 ^
  -e TOMCAT_ACCEPT_COUNT=1000 ^
  -e TOMCAT_MAX_THREADS=800 ^
  -e TOMCAT_MIN_SPARE_THREADS=100 ^
  -e DB_PASSWORD=%MYSQL_ROOT_PASSWORD% ^
  -e DB_USER=root ^
  -e DRUID_LOGIN_USERNAME=order ^
  -e DRUID_LOGIN_PASSWORD=123456 ^
  -e RABBITMQ_USERNAME=%RABBITMQ_USER% ^
  -e RABBITMQ_PASSWORD=%RABBITMQ_PASSWORD% ^
  -e REDIS_PASSWORD=%REDIS_PASSWORD% ^
  -v "%cd%\logs:/app/logs" ^
  -v "%cd%\uploadPath:/app/uploadPath" ^
  -v "%cd%\exportPath:/app/exportPath" ^
  %DOCKER_REGISTRY%/%IMAGE_NAME%:%IMAGE_TAG%

if errorlevel 1 (
    echo [错误] 订单系统容器启动失败！
    pause
    exit /b 1
)
echo [✓] 订单系统容器已启动
echo 等待订单系统应用初始化...
timeout /t 10 /nobreak >nul
echo.

echo [步骤 9/9] 启动 Nginx 容器
echo 创建并启动 Nginx 容器...
docker run -d ^
  --name %NGINX_CONTAINER% ^
  --network %NETWORK_NAME% ^
  -p %NGINX_PORT%:80 ^
  -v "%DATA_ROOT%\nginx\dist:/usr/share/nginx/html:ro" ^
  -v "%DATA_ROOT%\nginx\conf\default.conf:/etc/nginx/conf.d/default.conf:ro" ^
  -v "%DATA_ROOT%\nginx\log:/var/log/nginx" ^
  -e TZ=Asia/Shanghai ^
  --restart always ^
  nginx:%NGINX_VERSION%

if errorlevel 1 (
    echo [错误] Nginx 容器启动失败！
    pause
    exit /b 1
)
echo [✓] Nginx 容器已创建并启动
echo.

echo ============================================
echo 全部启动完成！
echo ============================================
echo.
echo 【已启动的服务】
echo  ✓ MySQL           - 端口 %MYSQL_PORT%
echo  ✓ Redis           - 端口 %REDIS_PORT%
echo  ✓ RabbitMQ        - 端口 %RABBITMQ_PORT% (AMQP) / %RABBITMQ_MANAGEMENT_PORT% (管理)
echo  ✓ 订单系统        - 端口 8080
echo  ✓ Nginx           - 端口 %NGINX_PORT%
echo.
echo 【访问地址】
echo  订单系统:        http://localhost:8080
echo  前端页面:        http://localhost:%NGINX_PORT%
echo  Druid 监控:      http://localhost:8080/druid (order/123456)
echo  RabbitMQ 管理:   http://localhost:15672 (%RABBITMQ_USER%/%RABBITMQ_PASSWORD%)
echo.
echo 【常用命令】
echo  查看所有容器:    docker ps
echo  查看订单系统日志: docker logs -f %CONTAINER_NAME%
echo.

echo 等待 5 秒后显示容器状态...
timeout /t 5 /nobreak >nul
echo.
echo ============================================
echo 容器运行状态
echo ============================================
docker ps --filter "name=%MYSQL_CONTAINER%" --filter "name=%REDIS_CONTAINER%" --filter "name=%RABBITMQ_CONTAINER%" --filter "name=%NGINX_CONTAINER%" --filter "name=%CONTAINER_NAME%" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 是否查看订单系统实时日志？(Y/N)
set /p VIEW_LOGS=""
if /i "%VIEW_LOGS%"=="Y" (
    docker logs -f %CONTAINER_NAME%
) else (
    echo.
    echo 启动完成！按任意键退出...
    pause >nul
)