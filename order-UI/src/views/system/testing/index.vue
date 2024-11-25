<template>
  <div>
    <!-- <div class="flex-display">
      <div class="left-box">文件上传(input)：</div>
      <input type="file" class="file-ipt" multiple @change="onChange" />
    </div>
    <hr />
    <el-table v-if="tableHead.length" :data="tableData[1]" style="width: 100%">
      <el-table-column
        v-for="(data, key) in tableHead"
        :key="key"
        :prop="data"
        :label="data"
        width="180"
      >
      </el-table-column>
    </el-table> -->

    <!-- <el-button type="primary">点击增加{{ count }}</el-button> -->
  </div>
</template>
<script>
  import Vue from 'vue';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import { read, utils } from 'xlsx';

  Vue.use(ElementUI);
  export default {
    data() {
      return {
        fileList: [], // 上传文件列表
        tableHead: [], // 表头
        tableData: [] // 表数据
      };
    },
    methods: {
      // 上传方法
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
            // export function read(data: any, opts?: ParsingOptions): WorkBook;
            const workbook = read(data, { type: 'binary' });

            // 参数数组
            const params = [];
            // 取对应表生成json表格内容  SheetNames 是所有的 Sheet item就是每一个Sheet
            workbook.SheetNames.forEach(item => {
              // 添加到params这个map中
              params.push({
                name: item,
                // 将workbook中的某个sheet转为js数组
                // sheet_to_json<T>(worksheet: WorkSheet, opts?: Sheet2JSONOpts): T[];
                dataList: utils.sheet_to_json(workbook.Sheets[item])
              });
              // 放入tableData中 el-table中tableData的数据结构为 [{},{},{}] 对象中每一个属性对应一个column 的prop
              this.tableData.push(utils.sheet_to_json(workbook.Sheets[item]));
            });
            // tableData是所有Sheet的数据 tableData[0]是第一个Sheet
            console.log('tableData:', this.tableData)
            // 该算法仅针对表头无合并的情况
            if (this.tableData.length > 0) {
              // 获取excel中第一个表格数据tableData[0][0]，并且将表头提取出来
              for (const key in this.tableData[1][0]) {
                this.tableHead.push(key);
              }
            }
            // todo 获取某一个sheet下的某一行数据的某一个属性
            console.log(this.tableData[1][0]['价税合计'])
            return params;
          // 重写数据
          } catch (e) {
            console.log('error:' + e);
            return false;
          }
        };
        fileReader.readAsBinaryString(file);
      },
    }
  };
</script>
<style lang="scss" scoped>
.upload-demo {
  width: 100%;
}

.flex-display {
  margin: 50px 30px;
  width: 100%;
  display: flex;
  justify-content: flex-start;

  .left-box {
    margin: 20 30;
    height: 36px;
    line-height: 36px;
  }
}

.el-upload {
  margin-left: 40px;

  .el-btn {
    font-size: 16px;
  }

  .el-upload-tip {
    display: inline;
    font-size: 12px;
  }
}

.file-ipt {
  width: 200px;
  height: 36px;
  line-height: 36px;

  button {
    background-color: #409eff;
  }
}

input #file-upload-button {
  background-color: #409eff;
}
</style>

