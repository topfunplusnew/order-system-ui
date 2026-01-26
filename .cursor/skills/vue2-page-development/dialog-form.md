# 弹窗表单模板

## 基础弹窗表单

```vue
<el-dialog :title="title" :visible.sync="open" width="600px" append-to-body @close="cancel">
  <el-form ref="form" :model="form" :rules="rules" label-width="100px">
    <!-- 文本输入 -->
    <el-form-item label="名称" prop="name">
      <el-input v-model="form.name" placeholder="请输入名称" maxlength="50" show-word-limit />
    </el-form-item>
    
    <!-- 数字输入 -->
    <el-form-item label="数量" prop="quantity">
      <el-input-number v-model="form.quantity" :min="0" :max="9999" :precision="0" />
    </el-form-item>
    
    <!-- 金额输入（使用 mathjs 计算） -->
    <el-form-item label="金额" prop="amount">
      <el-input v-model="form.amount" placeholder="请输入金额">
        <template #append>元</template>
      </el-input>
    </el-form-item>
    
    <!-- 下拉选择 -->
    <el-form-item label="类型" prop="type">
      <el-select v-model="form.type" placeholder="请选择类型" clearable>
        <el-option v-for="item in typeOptions" :key="item.value" :label="item.label" :value="item.value" />
      </el-select>
    </el-form-item>
    
    <!-- 单选 -->
    <el-form-item label="状态" prop="status">
      <el-radio-group v-model="form.status">
        <el-radio label="0">启用</el-radio>
        <el-radio label="1">禁用</el-radio>
      </el-radio-group>
    </el-form-item>
    
    <!-- 多选 -->
    <el-form-item label="标签" prop="tags">
      <el-checkbox-group v-model="form.tags">
        <el-checkbox v-for="item in tagOptions" :key="item.value" :label="item.value">{{ item.label }}</el-checkbox>
      </el-checkbox-group>
    </el-form-item>
    
    <!-- 日期选择 -->
    <el-form-item label="日期" prop="date">
      <el-date-picker v-model="form.date" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" />
    </el-form-item>
    
    <!-- 日期范围 -->
    <el-form-item label="时间范围" prop="dateRange">
      <el-date-picker v-model="form.dateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" />
    </el-form-item>
    
    <!-- 文本域 -->
    <el-form-item label="备注" prop="remark">
      <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" maxlength="200" show-word-limit />
    </el-form-item>
  </el-form>
  <div slot="footer">
    <el-button @click="cancel">取 消</el-button>
    <el-button type="primary" @click="submitForm" :loading="submitLoading">确 定</el-button>
  </div>
</el-dialog>
```

## 表单校验规则

```javascript
rules: {
  // 必填
  name: [{ required: true, message: '名称不能为空', trigger: 'blur' }],
  
  // 必填 + 长度限制
  code: [
    { required: true, message: '编码不能为空', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  
  // 必填 + 数字范围
  quantity: [
    { required: true, message: '数量不能为空', trigger: 'blur' },
    { type: 'number', min: 1, max: 9999, message: '数量范围 1-9999', trigger: 'blur' }
  ],
  
  // 正则校验
  phone: [
    { required: true, message: '手机号不能为空', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  
  // 选择类必填
  type: [{ required: true, message: '请选择类型', trigger: 'change' }],
  
  // 自定义校验
  amount: [
    { required: true, message: '金额不能为空', trigger: 'blur' },
    { validator: this.validateAmount, trigger: 'blur' }
  ]
}
```

## 自定义校验方法

```javascript
methods: {
  validateAmount(rule, value, callback) {
    if (value === '' || value === undefined) {
      callback(new Error('金额不能为空'));
    } else if (isNaN(Number(value))) {
      callback(new Error('请输入有效数字'));
    } else if (Number(value) <= 0) {
      callback(new Error('金额必须大于0'));
    } else {
      callback();
    }
  }
}
```

## 动态表单（类型切换）

```javascript
watch: {
  'form.type'(val) {
    // 切换类型时清理无关字段
    if (val === '1') {
      delete this.form.fieldB;
      this.form.fieldA = '';
    } else if (val === '2') {
      delete this.form.fieldA;
      this.form.fieldB = '';
    }
  }
}
```

## 表单初始化完整示例

```javascript
// 初始表单方法
getInitForm() {
  return {
    id: undefined,
    name: '',
    code: '',
    type: undefined,
    status: '0',
    tags: [],
    date: '',
    dateRange: [],
    remark: ''
  };
},

// 新增
handleAdd() {
  this.reset();
  this.open = true;
  this.title = '新增';
},

// 修改
handleUpdate(row) {
  this.reset();
  const id = row.id || this.ids[0];
  getDetail(id).then(res => {
    // 深拷贝防止污染
    this.form = JSON.parse(JSON.stringify(res.data));
    this.open = true;
    this.title = '修改';
  });
},

// 重置
reset() {
  this.form = this.getInitForm();
  this.$nextTick(() => {
    this.$refs.form?.resetFields();
  });
},

// 取消
cancel() {
  this.open = false;
  this.$nextTick(() => {
    this.form = this.getInitForm();
    this.$refs.form?.resetFields();
  });
},

// 提交
submitForm() {
  this.$refs.form.validate(valid => {
    if (!valid) return;
    this.submitLoading = true;
    const request = this.form.id ? updateXxx(this.form) : addXxx(this.form);
    request.then(() => {
      this.$message.success(this.form.id ? '修改成功' : '新增成功');
      this.open = false;
      this.getList();
    }).finally(() => {
      this.submitLoading = false;
    });
  });
}
```

## 文件上传

```vue
<el-form-item label="附件" prop="fileList">
  <file-upload v-model="form.fileList" :limit="5" :fileSize="10" />
</el-form-item>
```

## 图片上传

```vue
<el-form-item label="图片" prop="imageUrl">
  <image-upload v-model="form.imageUrl" :limit="1" />
</el-form-item>
```

## 富文本编辑器

```vue
<el-form-item label="内容" prop="content">
  <editor v-model="form.content" :min-height="200" />
</el-form-item>
```
