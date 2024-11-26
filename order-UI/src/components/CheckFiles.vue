<!--查看文件通用的的组件-->
<!-- 如果一个列需要展示文件 那么就可以用这个组件-->
<script>
import { check_file } from '../views/dashboard/mixins/utils/check_file';
import FileItems from './FileItems.vue';
import FileShowItem from './FileShowItem.vue';

export default {
	name: 'CheckFiles',
	components: { FileShowItem, FileItems },
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
			// 检查的文件列表
			checkFileList: [],
			dialogVisible: false,

			// 最大文件个数限制
			maxFileNum: 5
		};
	},

	mounted() {
		// 事件总线 接受dialogVisible的变化 设置一个全局监听器 当监听到某个事件发生的时候 那么就要执行相关逻辑
		this.$bus.$on('changeFileVisible', value => {
			this.dialogVisible = value;
		});
	},
	methods: {
		// 查看文件列表
		checkFiles(path) {
			this.checkFileList = [];
			// 如果path有值 才能分隔 没有值就是本身
			if (path) {
				this.checkFileList = path.split('|').filter(item => item !== '');
			}
			this.dialogVisible = true;
		},
		// 上传附件
		uploadFile(path) {
			// fileList即为已经上传的文件列表
			this.checkFileList = [];
			if (path) {
				this.checkFileList = path.split('|').filter(item => item !== '');
			}
			this.dialogVisible = true;
		},
		// 添加某个文件
		handleAddFile(value) {
			let newPath = null;
			// 如果长度大于等于5 不得上传
			if (this.checkFileList.length >= this.maxFileNum) {
				this.$message.error('最多只能上传' + this.maxFileNum + '个文件');
			} else {
				// 如果push进去后 列表长度为0 那么就拼接一个|
				if (this.checkFileList.length === 0) {
					const item = value + '|';
					// 调用传入的业务接口 修改数据
					this.$emit('needToUpdate', item);
					// 如果不是 那么就直接推入 然后 join
				} else {
					this.checkFileList.push(value);
					newPath = this.checkFileList.join('|');

					// 调用传入的业务接口 修改数据
					this.$emit('needToUpdate', newPath);
				}
			}
		},
		// 删除某个文件
		handleDeleteFile(value) {
			// 弹出确认框 先确认是否要删除
			this.$confirm('是否要删除该文件?', '系统提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				// 筛选掉方法
				const files = this.checkFileList.filter(item => item !== value);
				const newPath = files.length === 0 ? '' : files.join('|');

				// 调用传入的业务接口 修改数据
				this.$emit('needToUpdate', newPath);
			});
		}
	}
};
</script>

<template>
	<div>
		<div>
			<el-dropdown>
				<span class="el-dropdown-link" style="color: orangered">
					附件<i class="el-icon-arrow-down el-icon--right"></i>
				</span>
				<el-dropdown-menu slot="dropdown">
					<el-dropdown-item>
						<el-button size="mini" type="text" @click="uploadFile(path)"
							>上传附件</el-button
						>
					</el-dropdown-item>
					<el-dropdown-item>
						<div v-if="path">
							<el-button size="mini" type="text" @click="checkFiles(path)"
								>查看附件</el-button
							>
						</div>
					</el-dropdown-item>
				</el-dropdown-menu>
			</el-dropdown>
		</div>

		<!--    文件列表-->
		<el-dialog
			title="文件列表(最多上传五个文件)"
			:visible.sync="dialogVisible"
			width="620px"
			append-to-body
		>
			<div class="file-list">
				<!--        上传过的文件列表-->
				<FileItems
					v-for="(item, index) in checkFileList"
					v-if="path"
					:key="index"
					:file-name="item"
					@handleFile="handleDeleteFile"
				/>
				<!--        支持上传-->
				<FileShowItem @handleFile="handleAddFile" />
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false"
					>确 定</el-button
				>
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
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 15px;
	background: #fafafa;
	margin-bottom: 10px;
}
</style>
