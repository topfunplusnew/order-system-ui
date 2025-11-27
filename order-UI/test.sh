docker run -d \
  -p 40081:40081 \
  -e FRONTEND_PORT=40081 \
  -e BACKEND_PORT=30180 \
  -v /opt/front-test:/opt/front \
  registry.superslash.cn/order-system-ui:latest