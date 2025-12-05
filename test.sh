sudo docker run -d \
  -p 40081:40081 \
  -e FRONTEND_PORT=40081 \
  -e BACKEND_PORT=60036 \
  -e HOST_IP=60.205.5.253 \
  -v /opt/front-test:/opt/front \
  -v /opt/front-test/html:/opt/front/html \
  registry.superslash.cn/order-system-ui:latest

  # 60.205.5.253:60036 测试环境