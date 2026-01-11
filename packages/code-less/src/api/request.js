let _request = null;

/**
 * 设置请求实例 (通常是 Axios 实例)
 * @param {Function} request 
 */
export function setRequest(request) {
  _request = request;
}

/**
 * 获取请求实例
 * @returns {Function}
 */
export function getRequest() {
  if (!_request) {
    // 允许在未初始化时通过全局变量获取 (作为 fallback)
    if (window.axios) return window.axios;
    throw new Error('CodeLess SDK: Request method not initialized. Please call setRequest() first.');
  }
  return _request;
}
