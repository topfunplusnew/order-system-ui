<!--excel导入组件-->

<script>
import {read, utils} from "xlsx";
import SheetList from "@/views/dashboard/components/common/SheetList.vue";
import {mixin_excel_server} from "@/views/dashboard/components/common/utils/excelServer";

export default {
  name: "ExcelImport",
  mixins: [mixin_excel_server],
  components: {SheetList},
  data() {
    return {
      // 是否显示excel 展示框
      dialogVisible: false,
      fileList: [], //上传文件列表
      tableHead: [], //表头
      tableData: [], // 表数据
      // 要读取哪一个sheet 默认是读取第一个sheet
      sheetIndex: 1,
      // sheet列表
      sheetList: [],
      // 批量开票的弹窗
      invoiceAllVisible: false,
    }
  },
  methods: {
    // 点击后上传 通过主动调用ref
    handleUpload() {
      // 清空状态
      this.clearState()
      // 清空上次上传的文件
      this.$refs.fileInput.value = "";
      // 触发input的点击事件
      this.$refs.fileInput.click()
    },
    // 上传事件
    onChange(e) {
      // 获取上传的第一个文件
      const file = e.target.files[0];
      // fileReader读取文件
      const fileReader = new FileReader();
      // FileReader 接口的 load 事件在成功读取文件时触发。
      fileReader.onload = ev => {
        try {
          // data是文件读取的二进制数据
          const data = ev.target.result;
          // read是xlsx库提供的一个方法 返回一个workbook工作铺对象 里面包含sheets对象，sheet对象中包含表名，表数据等
          const workbook = read(data, {type: "binary"});
          // 参数数组
          const params = [];
          // 取对应表生成json表格内容  SheetNames 是所有的 Sheet item就是每一个Sheet
          workbook.SheetNames.forEach(item => {
            // 填充到sheetList中
            this.sheetList.push(item);
            // 添加到params这个map中
            params.push({
              name: item,
              // 将workbook中的某个sheet转为js数组
              dataList: utils.sheet_to_json(workbook.Sheets[item])
            });
            // 放入tableData中 el-table中tableData的数据结构为 [{},{},{}] 对象中每一个属性对应一个column 的prop
            this.tableData.push(utils.sheet_to_json(workbook.Sheets[item]));
          });
          // 存储vuex中 供给子组件使用
          this.handleStoreExcel()
          // 打开选择sheet的弹窗
          this.dialogVisible = true
          // console.log(this.tableData[1][0]['价税合计'])
          return params;
          // 重写数据
        } catch (e) {
          console.log("读取excel发生异常:" + e);
          return false;
        }
      };
      fileReader.readAsBinaryString(file);
    },
    // 清除状态
    clearState() {
      this.sheetList = []
      this.tableData = []
    }
  }
}
</script>

<template>
  <div>
    <!--    开票按钮-->
    <div>
      <div class="custom-file-input">
        <el-button size="mini" type="success" @click="handleUpload">excel批量开票</el-button>
        <input
          type="file"
          v-on:change="onChange"
          class="file-ipt"
          multiple
          ref="fileInput"/>
      </div>
    </div>

    <!--    批量开票弹窗 这里是主要选择订单的弹窗-->
    <div>
      <el-dialog
        title="请选择一个sheet"
        :visible.sync="dialogVisible"
        width="470px">
        <!-- 展示读取的excel基本信息-->
        <el-card class="box-card">
          <SheetList :sheet-list="sheetList"/>
        </el-card>
        <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
       </span>
      </el-dialog>
    </div>


  </div>
</template>

<style scoped lang="scss">
.custom-file-input {
  display: flex;
  align-items: center;
  gap: 10px;
}

.file-ipt {
  display: none; /* 隐藏原始文件输入框 */
}

.file-name {
  font-size: 14px;
  color: #606266;
}

</style>
