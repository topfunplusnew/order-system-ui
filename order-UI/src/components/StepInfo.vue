<script>
import {getUserProfile} from "@/api/system/user";

export default {
  name: "StepInfo",
  data() {
    return {
      //当前登录用户
      loginUser: {}
    }
  },
  props: {
    processInfo: {
      type: Array,
      required: true
    }
  },
  computed: {
    //当前审核进度
    currentStep() {
      //找到step最大的
      return Math.max.apply(null, this.processInfo.map(item => item.step));
    },
  },
  created() {
    //获取当前登录用户信息
    getUserProfile().then(res => {
      console.log(res)
      this.loginUser = res.data;
    })
  },
  methods: {
    findUserIdIndex(userId, arr) {
      if (userId === undefined || userId === null || userId === '') {
        return false
      }
      const splitArr = arr.split(',')
      return splitArr.includes(userId + '')
    },
    //按钮type绑定
    types(item) {
      return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority) ? 'warning' : 'primary'
    },
    //按钮禁用
    isDisable(item) {
      //如果在审核中
      if (item.checkState === '审核中') {
        //todo 根据用户的userId来判断是否该用户需要审核
        // return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority);
        return false
      } else if (item.checkState === '通过') {
        return true //如果该项审批流程通过，则禁用按钮
      } else {
        return true //未通过 则禁用按钮
      }
    },
    //标签
    isTag(item) {
      return item.checkState === '通过' ? 'success' : 'danger'
    },
    //是否添加遮罩层
    //todo
    isChecked(item) {
      if (item.checkState === '通过') {
        return true;
      } else {
        return false;
      }
    },

    //审核
    handleCheckState(item) {
      console.log(item)
    },
  }
}
</script>

<template>
  <div>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核进度:
        </span>
      </el-col>
      <el-col :span="18">
        <el-steps :active="currentStep" finish-status="success" style="margin-top: 20px">
          <!--      循环-->
          <el-step v-for="(item,index) in processInfo" :status="item.checkState==='通过'?'success':'error'"
                   :key="index">
            <template #title>
          <span style="font-weight: bolder">
            {{ item.flowname }}
          </span>
            </template>
            <template #description>
          <span style="font-weight: bolder">
            审核意见:{{ item.auditcomment === null ? '无' : item.auditcomment }}
          </span>
            </template>
          </el-step>
        </el-steps>
      </el-col>
    </el-row>
    <br/>
    <br/>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核明细:
        </span>
      </el-col>
      <el-col :span="18">
        <el-timeline>
          <el-timeline-item v-for="(item,index) in processInfo" :key="index" :timestamp="item.auditdate"
                            placement="top">
            <el-card :class="{'shadow':isDisable(item)}">
              <el-row>
                <el-col :span="22">
                  <h2>{{ item.flowname }}</h2>
                  <p>
                    <span class="tx-bolder">审核结果:</span>
                    <el-tag :type="isTag(item)">{{ item.checkState }}</el-tag>
                  </p>
                  <p>
                    <span class="tx-bolder">审核意见:</span>
                    <span v-if="isChecked(item)">{{ item.auditcomment }}</span>
                    <span v-else> <el-tag type="warning">待审核</el-tag></span>
                  </p>
                </el-col>
                <el-col :span="2">
                  <!--  判断当前审核过程是否为登录用户的userId-->
                  <el-tooltip class="item" effect="dark"
                              :content="!isDisable?'您不用审核该项':'审核'"
                              placement="top-start">
                    <el-button :type="types(item)"
                               :disabled="isDisable(item)" @click="handleCheckState(item)">审核

                    </el-button>
                  </el-tooltip>
                </el-col>
              </el-row>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped lang="scss">
.tx-bolder {
  font-weight: bolder;
}

/*卡片遮罩*/
.shadow {
  opacity: 30%;
}
</style>
