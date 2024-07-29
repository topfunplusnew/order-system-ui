<template>
  <div>
    <!--        头部-->
    <Header>
      <lay-button type="primary" class="buttons" @click="handleCollapse">
        <lay-icon type="layui-icon-slider"></lay-icon>
      </lay-button>
    </Header>
    <div>
      <lay-row>
        <div class="left">
          <MenuInfo :collapse="collapse" />
        </div>
        <lay-transition>
          <div :class="isShow == true ? 'body-85' : 'body-100'">
            <Body></Body>
          </div>
        </lay-transition>
      </lay-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import MenuInfo from '../components/MenuInfo.vue'
import Header from './header/Index.vue'
import Body from './body/Index.vue'
import { computed, ref } from 'vue'
import { LayIcon } from '@layui/layui-vue'
import { useSwitchStore } from '../store'
//点击隐藏功能
const switch_store = useSwitchStore()
const isShow = computed(() => {
  return switch_store.isShow
})

//菜单收起与展开
const collapse = ref(false)
const handleCollapse = () => {
  collapse.value = !collapse.value
  switch_store.changeIsShow()
}
</script>

<style scoped>
.lay-split-panel-item {
  display: flex;
  font-size: 16px;
  font-weight: bold;
  justify-content: center;
  align-items: center;
}

.body-85 {
  width: 99%;
}

.body-100 {
  width: 100%;
}
</style>
