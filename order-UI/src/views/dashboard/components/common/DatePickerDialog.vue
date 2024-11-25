<script>
  export default {
    name: 'DatePickerDialog',
    data() {
      return {
        visible: false,
        beginTime: null,
        endTime: null
      }
    },
    methods: {
      // 关闭弹窗
      handleClose() {
        this.visible = false
      },
      // 点击确定
      handleConfirm() {
        if (this.beginTime && this.endTime) {
          this.$emit('resolve', {
            beginTime: this.beginTime,
            endTime: this.endTime
          })
          this.handleClose()
        } else {
          this.$message.error('请选择有效的日期')
        }
      }
    }
  }
</script>

<template>
  <div>
    <el-dialog :visible.sync="visible" title="选择日期" width="350px" @close="handleClose">
      <el-row style="text-align: center">
        <el-date-picker
          v-model="beginTime"
          type="datetime"
          placeholder="开始日期"
          value-format="yyyy-MM-dd HH:mm:ss"
          style="margin-bottom: 10px"
        />
      </el-row>
      <el-row style="text-align: center">
        <el-date-picker
          v-model="endTime"
          type="datetime"
          value-format="yyyy-MM-dd HH:mm:ss"
          placeholder="结束日期"
        />
      </el-row>
      <span slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleConfirm">确认</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss"></style>
