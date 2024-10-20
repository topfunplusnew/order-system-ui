<template>
  <el-dialog :close-on-click-modal="false" :show-close="false" title="订单历史信息"
             :visible.sync="checkHistoryOrderVisible" width="1100px">
    <el-row>
      <el-col :span="18" :offset="3">
        <el-timeline>
          <el-timeline-item :timestamp="'今天'+parseTime" placement="top">
            <el-button type="success" icon="el-icon-document" @click="checkcurrentOrderItemInfo">查看原订单信息
            </el-button>
          </el-timeline-item>
          <!--            修改的时间线-->
          <el-timeline-item v-for="(item,index) in orderHistoryInfoList" placement="top" :key="index"
                            :timestamp="item.diff.updateTime">
            <el-collapse v-model="activeNames">
              <el-collapse-item :title="item.userName+':'+item.remark" :name="index">
                <el-card>
                  <template #header>
                    <span style="font-weight: bold">修改人:{{ item.userName }}-{{ item.remark }}</span>
                  </template>
                  <div>
                    <CodeDiff
                      :old-string="item.diff.old"
                      :new-string="item.diff.new"
                      :context="10"
                      output-format="line-by-line"/>
                  </div>
                </el-card>
              </el-collapse-item>
            </el-collapse>
          </el-timeline-item>
        </el-timeline>
      </el-col>
    </el-row>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close">关 闭</el-button>
    </div>
  </el-dialog>
</template>
<script>
import CodeDiff from 'vue-code-diff'

export default {
  name: 'OrderHistoryCheck',
  props: {
    activeNames: {},
    checkHistoryOrderVisible: {},
    checkcurrentOrderItemInfo: {},
    orderHistoryInfoList: {},
    parseTime: {}
  },
  components: {CodeDiff},
  methods: {
    close() {
      this.$emit('close')
    },

  }
}
</script>
