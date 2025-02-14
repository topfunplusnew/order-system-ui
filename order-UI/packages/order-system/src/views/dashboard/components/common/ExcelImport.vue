<!--excel导入组件 对外展示为一个按钮-->

<script>
import SheetList from '@/views/dashboard/components/common/SheetList.vue';
import { mixin_excel_server } from '@/views/dashboard/components/common/utils/excelServer';
import { read, utils, writeFile } from 'xlsx';

export default {
	name: 'ExcelImport',
	components: { SheetList },
	mixins: [mixin_excel_server],
	data() {
		return {
			// 是否显示excel 展示框
			dialogVisible: false,
			fileList: [], // 上传文件列表
			tableHead: [], // 表头
			tableData: [], // 表数据
			// 要读取哪一个sheet 默认是读取第一个sheet
			sheetIndex: 1,
			// sheet列表
			sheetList: [],
			// 批量开票的弹窗
			invoiceAllVisible: false
		};
	},
	methods: {
		// 点击后上传 通过主动调用ref
		handleUpload() {
			// 清空状态
			this.clearState();
			// 清空上次上传的文件
			this.$refs.fileInput.value = '';
			// 触发input的点击事件
			this.$refs.fileInput.click();
		},
		/**
		 * excel的读写操作 如果后期excel大小过于大在这里优化
		 * @param e Event
		 */
		onChange(e) {
			// 清除状态
			this.handleClearExcel();

			if (e.target.files.length === 0) {
				this.$message.warning('请选择文件,当前没有选择任何文件!!');
				return false;
			}
			// 获取上传的第一个文件
			const file = e.target.files[0];

			if (!this.checkFileType(file)) {
				this.$message.warning(
					`文件格式不正确, 请上传xls/xlsx格式文件!`
				);
				return false;
			}

			// fileReader读取文件
			const fileReader = new FileReader();

			// FileReader 接口的 load 事件在成功读取文件时触发。
			fileReader.onload = ev => {
				try {
					// data是文件读取的二进制数据
					const data = ev.target.result;
					// read是xlsx库提供的一个方法 返回一个workbook工作铺对象 里面包含sheets对象，sheet对象中包含表名，表数据等
					const workbook = read(data, { type: 'binary' });
					// 取对应表生成json表格内容  SheetNames 是所有的 Sheet item就是每一个Sheet
					workbook.SheetNames.forEach(item => {
						// 填充到sheetList中
						this.sheetList.push(item);
						// 放入tableData中 el-table中tableData的数据结构为 [{},{},{}] 对象中每一个属性对应一个column 的prop
						this.tableData.push(
							utils.sheet_to_json(workbook.Sheets[item])
						);
					});
					// 存储vuex中 供给子组件使用
					this.handleStoreExcel(this.tableData);
					// 打开选择sheet的弹窗
					this.dialogVisible = true;
					return true;
					// 重写数据
				} catch (e) {
					console.log('读取excel发生异常:' + e);
					return false;
				}
			};
			fileReader.readAsBinaryString(file);
		},
		// 校验一下文件类型
		checkFileType(file) {
			const fileName = file.name.split('.');
			const fileExt = fileName[fileName.length - 1];
			return ['xls', 'xlsx'].indexOf(fileExt) >= 0;
		},
		// 清除状态
		clearState() {
			this.sheetList = [];
			this.tableData = [];
		},
		// 下载模板
		downloadTemplate() {
			// 模板数据
			const templateData = [
				{
					销方ID: 0,
					销方类型: '己方公司',
					销方名称: '我方科技有限公司',
					购买方ID: 1001,
					购买方类型: '客户',
					购买方名称: '客户公司A',
					价税合计: 10000.0
				},
				{
					销方ID: 2001,
					销方类型: '供应商',
					销方名称: '供应商公司B',
					购买方ID: 0,
					购买方类型: '己方公司',
					购买方名称: '我方科技有限公司',
					价税合计: 5000.5
				},
				{
					销方ID: 3001,
					销方类型: '客户',
					销方名称: '客户公司C',
					购买方ID: 0,
					购买方类型: '己方公司',
					购买方名称: '我方科技有限公司',
					价税合计: 8500.25
				},
				{
					销方ID: 0,
					销方类型: '己方公司',
					销方名称: '我方科技有限公司',
					购买方ID: 4001,
					购买方类型: '供应商',
					购买方名称: '供应商公司D',
					价税合计: 12500.8
				},
				{
					销方ID: 5001,
					销方类型: '供应商',
					销方名称: '供应商公司E',
					购买方ID: 6001,
					购买方类型: '客户',
					购买方名称: '客户公司F',
					价税合计: 15000.6
				}
			];

			// 创建工作簿
			const wb = utils.book_new();

			// 将数据转换为工作表
			const ws = utils.json_to_sheet(templateData);

			// 在数据下方添加说明信息
			const notes = [
				['数据填写规范说明：'],
				['1. ID规则：'],
				['   - 当类型为"己方公司"时，对应的ID必须为0'],
				['   - 其他类型的ID必须为非0的数字'],
				['2. 类型规则：'],
				['   - 类型只能为：己方公司、客户、供应商'],
				['   - 销方和购买方不能同时为己方公司'],
				['   - 销方和购买方不能同时为除己方公司外的其他类型'],
				['3. 金额规则：'],
				['   - 价税合计必须保留两位小数'],
				[''],
				['注：此说明行可删除']
			];

			// 计算数据的行数
			const dataRowCount = templateData.length;

			// 在数据下方添加说明
			utils.sheet_add_aoa(ws, notes, { origin: `A${dataRowCount + 3}` });

			// 设置列宽
			const colWidth = [
				{ wch: 12 }, // 销方ID
				{ wch: 12 }, // 销方类型
				{ wch: 25 }, // 销方名称
				{ wch: 12 }, // 购买方ID
				{ wch: 12 }, // 购买方类型
				{ wch: 25 }, // 购买方名称
				{ wch: 15 } // 价税合计
			];
			ws['!cols'] = colWidth;

			// 将工作表添加到工作簿
			utils.book_append_sheet(wb, ws, '开票模板');

			// 下载文件
			writeFile(wb, '批量开票模板.xlsx');
		}
	}
};
</script>

<template>
	<div>
		<!--    开票按钮-->
		<div>
			<div class="custom-file-input">
				<el-button size="mini" type="success" @click="handleUpload"
					>excel批量开票
				</el-button>
				<el-button size="mini" type="primary" @click="downloadTemplate"
					>下载模板
				</el-button>
				<input
					ref="fileInput"
					type="file"
					class="file-ipt"
					multiple
					@change="onChange"
				/>
			</div>
		</div>

		<!--    批量开票弹窗 这里是主要选择订单的弹窗-->
		<div>
			<el-dialog
				title="请选择一个sheet"
				:visible.sync="dialogVisible"
				width="470px"
			>
				<!-- 展示读取的excel基本信息-->
				<el-card class="box-card">
					<SheetList :sheet-list="sheetList" />
				</el-card>
				<span slot="footer" class="dialog-footer">
					<el-button @click="dialogVisible = false">取 消</el-button>
					<el-button type="primary" @click="dialogVisible = false"
						>确 定</el-button
					>
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
