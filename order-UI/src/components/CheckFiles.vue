<!--查看文件通用的的组件-->
<!-- 如果一个列需要展示文件 那么就可以用这个组件-->
<script>
import {check_file} from "../views/dashboard/mixins/utils/check_file";
import FileItems from "./FileItems.vue";

export default {
  name: "CheckFiles",
  components: {FileItems},
  mixins: [check_file],
  props: {
    // 文件的地址url字段
    path: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      checkFileList: [],
      dialogVisible: false,
    }
  },
  methods: {
    // 查看文件列表
    checkFiles(path) {
      this.checkFileList = path.split('|')
      this.dialogVisible = true;
    },
    // 点击某一个文件
    handleCheckFile(item) {
      window.open(item)
    }
  }
}
</script>

<template>
  <div>
    <div v-if="!path">
      无附件
    </div>
    <div v-else>
      <el-button size="mini" type="text" @click="checkFiles(path)">查看附件</el-button>
    </div>

    <el-dialog
      title="文件列表"
      :visible.sync="dialogVisible"
      width="30%">
      <div class="file-list">
        <FileItems v-for="(item,index) in checkFileList" :key="index" :file-name="item"
                   @click.native="handleCheckFile(item)"/>
      </div>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.file-list {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  align-items: flex-start;
  align-content: flex-start;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 15px;
  background: #fafafa;
  margin-bottom: 10px;
}
</style>
