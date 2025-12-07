docker run -d \
  -p 40085:40085 \
  -e FRONTEND_WEB_ROOT=/opt/front/html \
  -v /opt/front:/opt/front \
  -v /opt/front/html:/opt/front/html \
  registry.superslash.cn/order-system-ui:latest