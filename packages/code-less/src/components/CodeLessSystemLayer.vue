<template>
  <div class="codeless-system">
    <div class="codeless-sidebar">
      <div class="codeless-logo">
        <i class="el-icon-cpu"></i>
        <span>低代码平台</span>
      </div>
      <CodeLessMenu :active-menu="activeMenu" @select="handleMenuSelect" />
    </div>
    <div class="codeless-main">
      <div class="codeless-header">
        <span class="codeless-title">{{ currentTitle }}</span>
      </div>
      <div class="codeless-content">
        <component :is="currentView" />
      </div>
    </div>
  </div>
</template>

<script>
import CodeLessMenu from './CodeLessMenu.vue';
import ApiEndpointManager from '../views/ApiEndpointManager.vue';

// 菜单与视图映射
const VIEW_MAP = {
  'api-endpoint': {
    component: ApiEndpointManager,
    title: 'API 接口管理'
  }
};

export default {
  name: 'CodeLessSystemLayer',
  components: {
    CodeLessMenu,
    ApiEndpointManager
  },
  data() {
    return {
      activeMenu: 'api-endpoint'
    };
  },
  computed: {
    currentView() {
      return VIEW_MAP[this.activeMenu]?.component || null;
    },
    currentTitle() {
      return VIEW_MAP[this.activeMenu]?.title || '低代码平台';
    }
  },
  methods: {
    handleMenuSelect(menuKey) {
      this.activeMenu = menuKey;
    }
  }
};
</script>

<style scoped>
.codeless-system {
  display: flex;
  height: 100vh;
  background: #f0f2f5;
}

.codeless-sidebar {
  width: 220px;
  background: linear-gradient(180deg, #1e3a5f 0%, #0d2137 100%);
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
}

.codeless-logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.codeless-logo i {
  font-size: 24px;
  margin-right: 8px;
}

.codeless-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.codeless-header {
  height: 60px;
  background: #fff;
  display: flex;
  align-items: center;
  padding: 0 24px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.codeless-title {
  font-size: 18px;
  font-weight: 600;
  color: #1e3a5f;
}

.codeless-content {
  flex: 1;
  padding: 16px;
  overflow: auto;
}
</style>
