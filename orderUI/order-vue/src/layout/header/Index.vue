<template>
  <div>
    <lay-header>
      <lay-row>
        <lay-col md="20" sm="20" xs="20">
          <div class="grid-demo">
            <lay-row space="5">
              <lay-col style="width: 200px; float: left"
                ><h1>订单管理</h1>
              </lay-col>
              <!--  切换状态-->
              <lay-col class="buttons">
                <slot></slot>
              </lay-col>
              <lay-col class="buttons">
                <lay-button type="primary">
                  <lay-fullscreen
                    v-slot="{ enter, exit, toggle, isFullscreen }"
                    @fullscreenchange="fullscreen"
                  >
                    <lay-icon
                      type="layui-icon-screen-full"
                      @click="enter()"
                    ></lay-icon>
                  </lay-fullscreen>
                </lay-button>
                <!-- TODO 测试 -->
                <!-- <lay-button type="primary" @click="handleClick">
                  测试代码
                </lay-button>
                <lay-button>{{ name }}</lay-button> -->
              </lay-col>
            </lay-row>
          </div>
        </lay-col>
        <lay-col md="4" sm="4" xs="4" class="self">
          <div class="grid-demo">
            <lay-dropdown
              updateAtScroll
              style="float: right; margin-top: 10px; margin-right: 3px"
            >
              <lay-button type="primary">
                <lay-icon type="layui-icon-friends"></lay-icon>
                {{ username }}<span v-if="username != '未登录'">，欢迎您~</span>
                <lay-icon type="layui-icon-down"></lay-icon>
              </lay-button>
              <template #content>
                <lay-dropdown-menu>
                  <lay-dropdown-menu-item @click="handleLogout">
                    <template #prefix>
                      <lay-icon type="layui-icon-logout"></lay-icon>
                    </template>
                    <template #default>退出登录</template>
                  </lay-dropdown-menu-item>
                </lay-dropdown-menu>
              </template>
            </lay-dropdown>
          </div>
        </lay-col>
      </lay-row>
    </lay-header>
  </div>
</template>

<script setup lang="ts">
import { logout } from '../../api/user/user.ts'
import { layer } from '@layui/layui-vue'
import { useRouter } from 'vue-router'
import { ref } from 'vue'

const router = useRouter()
const token = ref(sessionStorage.getItem('token'))

const username = ref('')
const temp = sessionStorage.getItem('username')
if (temp) {
  username.value = temp
} else {
  if (!token.value) {
    sessionStorage.removeItem('username')
    username.value = '未登录'
    router.push('/login')
  }
}
//全屏
const fullscreen = function (isFullscreen: any) {
  console.log(isFullscreen)
}

//登出
const handleLogout = () => {
  //如果没有token 或者token村了个空
  if (token.value == undefined || token.value == '') {
    sessionStorage.removeItem('token')
    sessionStorage.removeItem('username')
    layer.msg('您尚未登录~', { time: 2000, icon: 2 })
    router.push('/login')
    //有token
  } else {
    logout(token.value)
      .then((r: any) => {
        console.log(r)
        //如果接口响应200
        if (r.data.code == 200) {
          sessionStorage.removeItem('token')
          sessionStorage.removeItem('username')
          layer.msg('登出成功~', { time: 2000, icon: 1 })
          router.push('/login')
          //其他状态码 直接报错且跳出
        } else {
          layer.msg('系统出错!' + r.data.msg, { time: 2000, icon: 2 })
          sessionStorage.removeItem('username')
          router.push('/login')
        }
      })
      .catch((e) => {
        layer.msg('系统出错!' + e.msg, { time: 2000, icon: 2 })
        sessionStorage.removeItem('username')
        router.push('/login')
        console.log(e)
      })
  }
}

//测试代码
// const name = ref('')
// const handleClick = () => {
//   name.value = 'hello world' //副作用 effect
// }
// //name是依赖 dependency
// watch(name, () => {
//   alert(1)
// })
</script>

<style scoped>
.layui-header {
  line-height: 60px;
  text-align: center;
  background: white;
  color: black;
}

.grid-demo {
  line-height: 60px;
  text-align: center;
  background-color: white;
  color: black;
}

.buttons {
  float: left;
}

.self {
  float: right;
}

@media screen and (max-width: 380px) {
  .buttons {
    float: left;
    display: none;
  }
}

@media screen and (max-width: 227px) {
  .buttons {
    float: left;
    display: none;
  }

  .self {
    display: none;
  }
}
</style>
