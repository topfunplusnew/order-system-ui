                <el-input :value="returnForm.originalQuantity || 0" disabled />
            </el-form-item>
            <!-- 退回日期选择项（必填） -->
            <el-form-item label="退回日期" prop="localDate">
                <el-date-picker
                    v-model="returnForm.localDate"
                    type="date"
                    placeholder="请选择退回日期"
                    style="width: 100%"
                    value-format="yyyy-MM-dd"
                    clearable
                />
            </el-form-item>
            <el-form-item label="退回数量" prop="quantity">
                <el-input v-model="returnForm.quantity" placeholder="请输入退回数量" />