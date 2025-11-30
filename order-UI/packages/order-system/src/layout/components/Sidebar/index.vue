<template>
	<div :class="['sidebar-wrapper', 'layui-side', 'layui-bg-blue', { 'has-logo': showLogo }]">
		<logo v-if="showLogo" :collapse="isCollapse" />
		<el-scrollbar :class="[settings.sideTheme, 'layui-side-scroll']" wrap-class="scrollbar-wrapper">
			<el-menu class="sidebar-menu layui-nav layui-nav-tree beg-navbar layui-bg-blue" :default-active="activeMenu" :collapse="isCollapse" background-color="#f9f9f9" text-color="#000" :unique-opened="false" active-text-color="#156fb2" :collapse-transition="false" mode="vertical">
				<sidebar-item v-for="(route, index) in sidebarRouters" :key="route.path + index" :item="route" :base-path="route.path" />
			</el-menu>
		</el-scrollbar>
	</div>
</template>

<script>
import { mapGetters, mapState } from 'vuex';
import Logo from './Logo';
import SidebarItem from './SidebarItem';

export default {
	components: { SidebarItem, Logo },
	computed: {
		...mapState(['settings']),
		...mapGetters(['sidebarRouters', 'sidebar']),
		activeMenu() {
			const route = this.$route;
			const { meta, path } = route;
			// if set path, the sidebar will highlight the path you set
			if (meta.activeMenu) {
				return meta.activeMenu;
			}
			return path;
		},
		showLogo() {
			return this.$store.state.settings.sidebarLogo;
		},
		isCollapse() {
			return !this.sidebar.opened;
		}
	}
};
</script>
