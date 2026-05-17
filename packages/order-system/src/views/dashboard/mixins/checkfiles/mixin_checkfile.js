import { getBankAcceptance } from '../../../../api/system/bankAcceptance';
import { TableName } from '../../../../api/tool/enums';
import { excludeParams } from '../../../../api/tool/exclude'; // 导入 excludeParams 方法
import _ from 'lodash';
import { updateGoodsOrderAttachments } from '@/api/system/goodsOrder';
import { updateInventoryAttachments } from '@/api/system/inventoryMain';
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
		 * 从 CheckFiles 回传的附件对象列表提取 id
		 * @param {Array<Object>} attachmentList
		 * @returns {Array<number|string>}
		 */
		extractAttachmentIds(attachmentList) {
			if (!Array.isArray(attachmentList)) {
				return [];
			}
			return attachmentList.map(item => item && item.id).filter(id => id !== null && id !== undefined);
		},
		/**
		 * 解析附件更新应走的业务分支（订单 / 库存 / 通用 onUpdate）
		 * @param {Object} row - 表格行数据
		 * @param {Function} onGet - 父组件传入的详情查询方法（仅用于识别业务类型）
		 * @returns {'goodsOrder'|'inventory'|'generic'}
		 */
		resolveAttachmentUpdateStrategy(row, onGet) {
			const tableName = row && row.metaDataTableName;
			if (tableName && this.isGoodsOrderTable(tableName)) {
				return 'goodsOrder';
			}
			if (tableName && this.isInventoryTable(tableName)) {
				return 'inventory';
			}
			// 列表行可能无 metaDataTableName，用 onGet 函数名兜底（如 ElTableOrder 传入 getGoodsOrder）
			if (typeof onGet === 'function' && onGet.name === 'getGoodsOrder') {
				return 'goodsOrder';
			}
			if (typeof onGet === 'function' && onGet.name === 'getInventoryMain') {
				return 'inventory';
			}
			return 'generic';
		},
		/**
		 * 处理文件更新回调逻辑（上传 / 删除后同步 attachmentIds）
		 * @param {Array<Object>} value - CheckFiles 合并后的整单附件对象列表
		 * @param {Object} row - 当前行的数据对象
		 * @param {Function} onGet - 获取详情（新逻辑不再用于拉附件列表，保留参数兼容旧调用方）
		 * @param {Function} onUpdate - 通用模块的更新接口方法
		 */
		handleUpdateFilePath(value, row, onGet, onUpdate) {
			if (typeof onUpdate !== 'function') {
				this.$message.error('组件内部错误！请检查传入的 onUpdate 参数类型。');
				return Promise.reject(new Error('onUpdate 参数无效'));
			}

			const attachmentIds = this.extractAttachmentIds(value);
			const strategy = this.resolveAttachmentUpdateStrategy(row, onGet);

			// ---------- 新逻辑：不再 onGet 拉详情，直接用前端合并后的 attachmentIds 更新（返回 Promise 供 CheckFiles 失败回滚） ----------
			if (strategy === 'goodsOrder') {
				return updateGoodsOrderAttachments({
					goodsOrderId: row.id,
					attachmentIds
				}).then(() => {
					this.$message.success('更新订单附件成功~');
				});
			}

			if (strategy === 'inventory') {
				return updateInventoryAttachments({
					inventoryMainId: row.id,
					attachmentIds
				}).then(() => {
					this.$message.success('更新库存附件成功~');
				});
			}

			return this.runGenericAttachmentUpdate(row, attachmentIds, onUpdate);

			// ---------- 旧逻辑（保留注释）：onGet 拉最新 attachmentList 再与弹窗列表做并集 ----------
			// if (typeof onGet !== 'function' || typeof onUpdate !== 'function') {
			// 	this.$message.error('组件内部错误！请检查传入的参数类型。');
			// 	return;
			// }
			// onGet(row.id).then(async res => {
			// 	const deepData = _.cloneDeep(res.data);
			// 	const extingFile = (deepData?.attachmentList || []).map(item => item.id) || [];
			// 	const set = new Set([...value.map(item => item.id), ...extingFile]);
			// 	const updatedFiles = [...set];
			// 	let data = {
			// 		...deepData,
			// 		params: {
			// 			...deepData.params,
			// 			attachmentIds: updatedFiles
			// 		}
			// 	};
			// 	data = excludeParams(data, this.$exclude);
			// 	if (`metaDataTableName` in deepData && this.isTableInList(deepData.metaDataTableName)) {
			// 		if (`bankacceptanceId` in deepData && deepData.bankacceptanceId) {
			// 			data.params.bankacceptance = _.cloneDeep(await getBankAcceptance(deepData.bankacceptanceId)).data;
			// 		}
			// 	}
			// 	if (`metaDataTableName` in deepData && this.isGoodsOrderTable(deepData.metaDataTableName)) {
			// 		const payload = {
			// 			goodsOrderId: deepData.id,
			// 			attachmentIds: data.params.attachmentIds
			// 		};
			// 		updateGoodsOrderAttachments(payload).then(() => {
			// 			this.$message.success('更新订单附件成功~');
			// 		});
			// 		return;
			// 	}
			// 	if (`metaDataTableName` in deepData && this.isInventoryTable(deepData.metaDataTableName)) {
			// 		const payload = {
			// 			inventoryMainId: deepData.id,
			// 			attachmentIds: data.params.attachmentIds
			// 		};
			// 		updateInventoryAttachments(payload).then(() => {
			// 			this.$message.success('更新库存附件成功~');
			// 		});
			// 		return;
			// 	}
			// 	data.editReason = 'f871391c-0e97-43e5-89f9-a97837e57a22';
			// 	onUpdate(data).then(() => {
			// 		this.$message.success('操作成功！');
			// 	});
			// });
		},
		/**
		 * 非订单/库存模块：用行数据 + attachmentIds 调 onUpdate
		 * @param {Object} row
		 * @param {Array<number|string>} attachmentIds
		 * @param {Function} onUpdate
		 */
		async runGenericAttachmentUpdate(row, attachmentIds, onUpdate) {
			let data = {
				..._.cloneDeep(row),
				params: {
					...(row.params || {}),
					attachmentIds
				}
			};
			data = excludeParams(data, this.$exclude);
			const tableName = row.metaDataTableName;
			if (tableName && this.isTableInList(tableName) && row.bankacceptanceId) {
				data.params.bankacceptance = _.cloneDeep((await getBankAcceptance(row.bankacceptanceId)).data);
			}
			data.editReason = 'f871391c-0e97-43e5-89f9-a97837e57a22';
			return onUpdate(data).then(() => {
				this.$message.success('操作成功！');
			});
		},
		isTableInList(tableName) {
			const tableList = [TableName.PAYMENT, TableName.RECEIVE_MONEY, TableName.CASH_RECORD];
			return tableList.includes(tableName);
		},
		isGoodsOrderTable(tableName) {
			const tableList = [TableName.GOODS_ORDER];
			return tableList.includes(tableName);
		},
		isInventoryTable(tableName) {
			const tableList = [TableName.INVENTORMAIN];
			return tableList.includes(tableName);
		}
	}
};
