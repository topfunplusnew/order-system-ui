<!--编辑原因弹出框-->
<script>
import {addReason} from "@/api/system/user";

export default {
  name: "EditReason",
  props: {
    tableName: '',
    tid: '',
    modifyTime: {
      type: Number,
      default: new Date().getTime()
    }
  },
  data() {
    return {
      formInline: {
        reason: ''
      }
    }
  },
  methods: {
    onSubmit() {
      addReason({...this.formInline, tableName: this.tableName, tid: this.tid, modifyTime: this.modifyTime})
        .then(res => {
          console.log(res)
          this.$message.success('提交成功')
        })
    }
  }
}
</script>

<template>
  <div>
    <el-row>
      <el-col>
        <el-form :model="formInline" class="demo-form-inline">
          <el-form-item label="修改原因">
            <el-input type="textarea" v-model="formInline.reason" placeholder="请输入修改原因"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">确定</el-button>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
