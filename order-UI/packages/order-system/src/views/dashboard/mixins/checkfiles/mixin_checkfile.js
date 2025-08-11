import { getBankAcceptance } from '../../../../api/system/bankAcceptance';
import { TableName } from '../../../../api/tool/enums';
import { excludeParams } from '../../../../api/tool/exclude'; // 导入 excludeParams 方法
import _ from 'lodash';
/**
 * 用法示例：
 * <el-table-column
 *   show-overflow-tooltip
 *   label="附件"
 *   align="center"
 *   prop="path"
 *   v-show="columns[15].visible"
 *   width="150px"
 * >
 *   <template slot-scope="scope">
 *     <CheckFiles
 *       :path="scope.row.path"
 *       @needToUpdate="(value) => handleUpdateFilePath(value, scope.row, 'path', getGoodsOrder, updateGoodsOrder)"
 *     />
 *   </template>
 * </el-table-column>
 */

/**
 * 文件说明：
 * 该文件定义了一个 `mixin_checkfile` 混入对象，用于处理文件上传或更新的回调逻辑。主要包含以下功能：
 * 1. 提供 `handleUpdateFilePath` 方法，用于处理上传文件后的数据更新。
 * 2. 支持动态获取指定文件记录，并更新指定字段的值。
 * 3. 通过事件总线关闭文件选择弹窗并刷新数据列表。
 */

export var mixin_checkfile = {
	methods: {
		/**
		 * 处理文件更新回调逻辑
		 * @param {String} value - 上传后的文件路径或文件值
		 * @param {Object} row - 当前行的数据对象
		 * @param {String} prop - 要更新的属性字段名称
		 * @param {Function} onGet - 获取文件记录的接口方法，需返回 Promise
		 * @param {Function} onUpdate - 更新文件记录的接口方法，需返回 Promise
		 */
		handleUpdateFilePath(value, row, onGet, onUpdate) {
			// 检查 onGet 和 onUpdate 是否为函数
			if (typeof onGet !== 'function' || typeof onUpdate !== 'function') {
				this.$message.error('组件内部错误！请检查传入的参数类型。');
				return;
			}
			// 调用 onGet 方法获取文件记录
			onGet(row.id).then(async (res) => {
				const deepData = _.cloneDeep(res.data);
				const extingFile = (deepData?.attachmentList || []).map(item => item.id) || [];
				const set = new Set([...value.map(item => item.id), ...extingFile]);
				const updatedFiles = [...set];
				// 将获取的记录与新的字段值组合
				let data = {
					...deepData,
					params: {
						...deepData.params,
						attachmentIds: updatedFiles
					}
				};
				// 去除无用的属性
				data = excludeParams(data, this.$exclude);
				// 如果包含这个表名 并且在表的列表中 那么需要单独处理
				if (`metaDataTableName` in deepData && this.isTableInList(deepData.metaDataTableName)) {
					// 对于票据的单独处理
					if (`bankacceptanceId` in deepData && deepData.bankacceptanceId) {
						data.params.bankacceptance = _.cloneDeep(await getBankAcceptance(deepData.bankacceptanceId)).data;
					}
				}
				// 这里如果传递editReason给一个固定值 就可以进行修改
				data.editReason = 'f871391c-0e97-43e5-89f9-a97837e57a22';
				// 调用 onUpdate 方法更新文件记录
				onUpdate(data).then(() => {
					this.$message.success('操作成功！');
					// 刷新数据列表
					this.getList();
				});
			});
		},
		isTableInList(tableName) {
			const tableList = [TableName.PAYMENT, TableName.RECEIVE_MONEY];
			return tableList.includes(tableName);
		}
	}
};
