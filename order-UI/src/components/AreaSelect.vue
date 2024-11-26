<template>
	<div>
		<select
			v-model="mailAddress1"
			style="width: 19rem"
			@change="provinceChange"
		>
			<option v-for="(item, index) in provinceList" :key="index" :value="item">
				{{ item.name }}
			</option>
		</select>
		<select
			v-model="mailAddress2"
			style="width: 19rem; margin-left: 1rem"
			@change="cityChange"
		>
			<option v-for="(item, index) in cityList" :key="index" :value="item">
				{{ item.name }}
			</option>
		</select>
		<select v-model="mailAddress3" style="width: 19rem; margin-left: 1rem">
			<option v-for="(item, index) in countyList" :key="index" :value="item">
				{{ item.name }}
			</option>
		</select>
	</div>
</template>
<script>
export default {
	name: 'AreaSelect',
	data() {
		return {
			mailAddress1: '',
			mailAddress2: '',
			mailAddress3: '',
			provinceList: '',
			cityList: '',
			countyList: ''
		};
	},
	mounted() {
		fetch('/area.json')
			.then(response => response.json())
			.then(res => {
				this.provinceList = res;
			});
	},
	methods: {
		provinceChange() {
			this.cityList = this.mailAddress1.areaList;
			this.countyList = '';
		},
		cityChange() {
			this.countyList = this.mailAddress2.areaList;
		}
	}
};
</script>
