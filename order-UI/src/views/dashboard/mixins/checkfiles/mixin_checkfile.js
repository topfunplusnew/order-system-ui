import {excludeParams} from "../../../../api/tool/exclude";


// 用法 : @needToUpdate="(value)=>handleUpdateFilePath(value,scope.row,'path',getGoodsOrder,updateGoodsOrder)"

/**
 * 具体使用方法 :
 * <el-table-column show-overflow-tooltip label="附件" align="center" prop="path" v-show="columns[15].visible"
 *                        width="150px">
 *         <template slot-scope="scope">
 *           <CheckFiles :path="scope.row.path"
 *                       @needToUpdate="(value)=>handleUpdateFilePath(value,scope.row,'path',getGoodsOrder,updateGoodsOrder)"/>
 *         </template>
 *       </el-table-column>
 * @type {{methods: {handleUpdateFilePath(*, *, *, *, *): void}}}
 */
export var mixin_checkfile = {
  methods: {
    // 处理修改上传的回调
    handleUpdateFilePath(value, row, prop, onGet, onUpdate) {
      // 如果传入的onGet和onUpdate不是函数类型 那么就报错
      if (typeof onGet !== 'function' || typeof onUpdate !== 'function') {
        this.$message.error('组件内部错误!')
        return;
      }
      // 需要先getId查询一下
      onGet(row.id).then(res => {
        // 封装组件对象
        const data = {
          ...res.data,
          [prop]: value
        }
        // 更新订单的附件字段
        onUpdate(excludeParams(data, this.$exclude)).then(res => {
          this.$message.success("操作成功!")
          // 通知事件总线 让CheckFile的visible关闭
          this.$bus.$emit('changeFileVisible', false)
          this.getList()
        })
      })
    },
  }
}
