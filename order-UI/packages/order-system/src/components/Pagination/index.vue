<template>
	<div :class="{ hidden: hidden }" class="pagination-container">
		<el-pagination :background="background" :current-page.sync="currentPage" :page-size.sync="pageSize"
			:layout="layout" :page-sizes="pageSizes" :pager-count="pagerCount" :total="total" v-bind="$attrs"
			@size-change="handleSizeChange" @current-change="handleCurrentChange" />
	</div>
</template>

<script>
import { scrollTo } from '@/utils/scroll-to';

export default {
	name: 'Pagination',
	props: {
		total: {
			required: true,
			type: Number
		},
		page: {
			type: Number,
			default: 1
		},
		limit: {
			type: Number,
			default: 20
		},
		pageSizes: {
			type: Array,
			default() {
				return [10, 20, 30, 50];
			}
		},
		// 移动端页码按钮的数量端默认值5
		pagerCount: {
			type: Number,
			default: document.body.clientWidth < 992 ? 5 : 7
		},
		layout: {
			type: String,
			default: 'total, sizes, prev, pager, next, jumper'
		},
		background: {
			type: Boolean,
			default: true
		},
		autoScroll: {
			type: Boolean,
			default: true
		},
		hidden: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {};
	},
	computed: {
		currentPage: {
			get() {
				return this.page;
			},
			set(val) {
				this.$emit('update:page', val);
			}
		},
		pageSize: {
			get() {
				return this.limit;
			},
			set(val) {
				this.$emit('update:limit', val);
			}
		}
	},
	created() {
		// 以当前页面路径作为 key 前缀
		const storageKey = window.location.pathname + "-pagination";
		const savedPage = localStorage.getItem(storageKey + "-page");
		const savedLimit = localStorage.getItem(storageKey + "-limit");
		if (savedPage) {
			console.log("Loaded page:", savedPage);
			this.$emit('update:page', Number(savedPage));
		}
		if (savedLimit) {
			console.log("Loaded limit:", savedLimit);
			this.$emit('update:limit', Number(savedLimit));
		}
	},
	watch: {
		page(newVal) {
			const storageKey = window.location.pathname + "-pagination";
			localStorage.setItem(storageKey + "-page", newVal);
			console.log("Saved page:", newVal);
		},
		limit(newVal) {
			const storageKey = window.location.pathname + "-pagination";
			localStorage.setItem(storageKey + "-limit", newVal);
			console.log("Saved limit:", newVal);
		}
	},
	methods: {
		handleSizeChange(val) {
			if (this.currentPage * val > this.total) {
				this.currentPage = 1;
			}
			this.$emit('pagination', { page: this.currentPage, limit: val });
			if (this.autoScroll) {
				scrollTo(0, 800);
			}
		},
		handleCurrentChange(val) {
			this.$emit('pagination', { page: val, limit: this.pageSize });
			if (this.autoScroll) {
				scrollTo(0, 800);
			}
		}
	}
};
</script>

<style scoped>
.pagination-container {
	background: #fff;
	padding: 32px 16px;
}

.pagination-container.hidden {
	display: none;
}
</style>
