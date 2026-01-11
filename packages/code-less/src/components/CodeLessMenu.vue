<template>
  <div class="codeless-menu">
    <div
      v-for="item in menuItems"
      :key="item.key"
      :class="['menu-item', { active: activeMenu === item.key }]"
      @click="handleClick(item.key)"
    >
      <i :class="item.icon"></i>
      <span>{{ item.label }}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CodeLessMenu',
  props: {
    activeMenu: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      menuItems: [
        {
          key: 'api-endpoint',
          label: 'API 接口管理',
          icon: 'el-icon-connection'
        }
      ]
    };
  },
  methods: {
    handleClick(key) {
      this.$emit('select', key);
    }
  }
};
</script>

<style scoped>
.codeless-menu {
  flex: 1;
  padding: 12px 0;
}

.menu-item {
  display: flex;
  align-items: center;
  height: 48px;
  padding: 0 24px;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  transition: all 0.2s;
}

.menu-item:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.menu-item.active {
  background: rgba(64, 158, 255, 0.3);
  color: #fff;
  border-right: 3px solid #409eff;
}

.menu-item i {
  font-size: 18px;
  margin-right: 12px;
}

.menu-item span {
  font-size: 14px;
}
</style>
